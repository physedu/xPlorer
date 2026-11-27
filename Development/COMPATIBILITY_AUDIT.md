# xAct compatibility audit — 27 November 2026

Audited source: `1ef1a5afbb45542cb9cb05f9491a1b06e4f2ef39` (unchanged package at Desktop bundle commit `afc0bb7184aea9e769d82d694709386b5ceb7fdb`). Scope: actual xAct 1.3.0 distribution (xTensor 1.3.0, xCoba 0.8.6, xPert 1.0.6), source inspection and remote Wolfram kernel tests. This is not a full compatibility certification. No package or public release changes are made by this report.

## Confirmed defects

### A. Presentation with named component indices

The earlier Einstein-variation failure was caused by supplying a RowBox as the first entry of SymbolOfCovD, while xTensor's DerSymbolLength and IndexForm require strings. The candidate uses a string for the postfix marker.

A second issue remains. xTensor supports boxes in PrintAs generally, but CIndexForm[ind,chart] reads PrintAs of a coordinate when $CIndexForm is True; IndexForm/AddIndex and the native tensor box machinery then consume that representation. The candidate temporarily installs boxes in PrintAs for labeled coordinates. With a coordinate present both as a scalar factor and as a named component index, formatting is not safe.

Reproduction in a fresh kernel after loading the candidate:

```wl
DefManifold[M,4,{a,b,c,d,e,f,i,j}];
DefMetric[-1,g[-a,-b],CD];
DefTensor[A[-a],M];
RegisterTheory["Metric",g];
RegisterTheory["CovD",CD];
RegisterTheory["Indices",{a,b,c,d,e,f,i,j}];
RegisterTheory["Field",A];
CreateBackground["One",SymbolSuffix->"O",BackgroundLabel->"ONE",ShowObjectLabels->True];
DefineChart["One",{t[],x[],y[],z[]}];
ch=ChartOf["One"];
expr=xO[] AO[{1,-ch}];
Block[{$CIndexForm=True},
  With[{v=PrettyExp[expr,ShowObjectLabels->True]},MakeBoxes[v,StandardForm]]
]
```

The same expression with ShowObjectLabels->False formats without the recorded error. In the labeled case, Format::nouse was recorded; the result also contains the separate headless CurrentValue[FontSize] issue. A matrix of three expressions (coordinate times component, coordinate times covariant component derivative, coordinate times basis derivative), two $CIndexForm states and two native $CovDFormat states passed all 12 unlabelled cases; 6 of 12 labeled cases failed Check, all with $CIndexForm=True. Twenty simpler labeled combinations without explicit coordinate factors passed. Normal of the view remained the original expression. This is a confirmed differential formatting issue in the remote kernel; Desktop appearance remains unverified.

Recommended fix: preserve the native string contract for names consumed by index formatting, and attach visual labels at the final box stage. Alternatively test a native-compatible string encoding for the marker before adopting it. Do not silently disable named component indices, suppress messages, or mutate the actual mathematical expression. Include mixed coordinate/component cases, both derivative styles, round-trip boxes, TeX and restoration of native PrintAs/SymbolOfCovD in acceptance tests.

### B. Explicit background can silently consume foreign objects

Reproduction in a separate fresh kernel:

```wl
DefManifold[M,4,{a,b,c,d,e,f,i,j}];
DefMetric[-1,g[-a,-b],CD];
DefTensor[phi[],M];
DefConstantSymbol[m];
RegisterTheory["Metric",g];
RegisterTheory["CovD",CD];
RegisterTheory["Indices",{a,b,c,d,e,f,i,j}];
RegisterTheory["Field",phi];
RegisterTheory["Parameter",m];
CreateBackground["One",SymbolSuffix->"O"];
CreateBackground["Two",SymbolSuffix->"T"];
DefineChart["One",{t[],x[],y[],z[]}];
DefineChart["Two",{t[],x[],y[],z[]}];
MetricInBasis[gO,DiagonalMatrix[{-1,1,1,1}]];
MetricInBasis[gT,DiagonalMatrix[{-1,1,1,1}]];
ComponentValue[phiO[],2];
ComponentValue[phiT[],7];
AddRules["Two",{m->0}];
```

Observed results:

| Expression | Result |
|---|---|
| phiO[] // ToComponents | 2 |
| phiT[] // ToComponents | 7 |
| SameQ[phiO[] // PortExpression["Two"],phiO[]] | True |
| ToComponents["Two",phiO[]] | 2 |
| ToComponents["Two",phiO[],StrictComponents->True] | 2 |
| FailureQ[(phiO[]+phiT[]) // ToComponents] | True |
| (m phiO[]) // ApplyRules["Two"] | 0 |
| (m phiO[]) // ApplyRules | m phiO[] |

PortExpression currently maps source-manifold symbols to target symbols, then checks only for leftover source-manifold tensors. It does not reject another managed background. ToComponents calls PortExpression then native value resolution; a foreign scalar can therefore resolve to a valid number and escape StrictComponents. Explicit ApplyRules applies the selected rule set without checking ownership. These are semantic safety issues, not just display defects.

Recommended fix: determine all managed owners (including symbols in heads/indices/held expressions) separately from the unique-owner inference helper; reject foreign owners for explicitly targeted calculations before any cache writes. Keep legitimate source expressions, ownerless constants, and intentional multi-owner display supported. Define explicit behavior for applying rules to a source expression; never silently reinterpret a foreign expression. PortExpression is source-to-background, not automatic background-to-background transport. Test same-owner, source, ownerless, foreign and mixed-owner cases across PortExpression, ToComponents, PerturbOn, ApplyRules, ToBasisOf and ToValuesOf.

## Other native integration risks (not additional demonstrated defects)

- Global dispatch: installManagedReadSyntax adds conditional definitions on protected native ToValues, ComponentValue, AllComponentValues and HeldComponentValue; SetBasisChange and unary ToCTensor are also extended. Verify native objects that are not owned by xPlorer retain native dispatch, attributes and options. Check HoldFirst, CVReplace, CVSimplify, delayed and explicit-basis inputs; use fresh kernels and actual native Print.
- Cache layout and private functions: clearGeometry examines DownValues[xCobaCacheTable]; nativeGeometrySpecHead, nativeGeometryRulePresentQ, dependency and state checks rely on private xCoba CacheKeySymbolic, signedbases, Depends and StateOfValID. These are version-sensitive even when public APIs remain unchanged. A missing/stale cache is scientifically more serious than a cosmetic issue. Verify invalidation across metrics, variances, charts, derivative orders and independent backgrounds.
- Lifecycle: deleting managed charts prunes Basis upvalues and xCoba values; deletion also manipulates MasterOf/ServantsOf and temporarily extends Undef. Test that external dependents are blocked, no foreign basis pair is removed, and partial failures leave a diagnosable state.
- Global output hook: $PrePrint is session-wide and xPert installs ScreenDollarIndices. Test different load orders, repeated loading, user-defined output hooks, and copy/TeX. Consider a clearly supported disable/restore mechanism; do not make a blanket claim that all xAct formatting is untouched.
- Native Set state: the package detects RuleToSet state using a private xCoba function and deliberately rejects certain managed operations until SetToRule; do not treat that documented rejection as an unexpected bug.

## Regression evidence on the unchanged candidate

Fresh kernels, portable permutation backend, existing RunGroup runner (which uses a quiet Print sink within groups):

| Group | Passed |
|---|---:|
| Display | 55/55 |
| NativeInterop | 23/23 |
| NativeRead | 22/22 |
| SelectiveInvalidation | 13/13 |
| NativeSetState | 21/21 |
| ChartLifecycle | 13/13 |
| Total | 147/147 |

Previously: 63/63 focused ObjectLabels tests; 36/37 Workflow checks (remaining headless font-size diagnostic); 62/62 executable Desktop-check cells excluding the manual copy/paste check. Those passing checks do not cover the new defects. The original Desktop test ZIP is deliberately unchanged. No general guarantee for other xAct versions, xTras/xPand or arbitrary external native edits follows from this audit.

## Resolution of the two confirmed defects

Candidate package commit `12ccb65580d76976446aaf96a21a80c0542ae3e6`, regression runner correction `bce382bbeed8f302b6f4815a0c761a67f5f63e27`. The user visually confirmed the original Einstein-rendering repair and actual Desktop copy/paste returned True (27 November 2026) on the earlier candidate. The two subsequent fixes are separate and still require Desktop validation of named component indices.

- Named indices: do not temporarily change coordinate PrintAs. Apply labels to the scalar coordinate's interpreted display box only after native index formatting. Named component indices themselves retain their native strings. The initial text-token prototype was discarded because held box replacement was not reliable. Covariant markers retain the earlier postfix string repair.
- Ownership: central expressionOwners/backgroundExpressionGuard detect managed symbol contexts including heads and indices. PortExpression, explicit ApplyRules (including result), ToBasisOf/ToValuesOf, ToComponents/PerturbOn via PortExpression, rule definition and SaveResult reject foreign managed owners. Display of mixed backgrounds remains allowed; source formulas and shared constants remain supported. This does not claim that every possible native operation or component-input dependency is isolated.
- Regression: CompatibilityAuditTests 65/65, ObjectLabelsTests 63/63, ResearchWorkflowTests 37/37 (153/153 inputs), NativeInterop 23/23, ComponentsAndRules 24/24. The test-only filter recognizes exactly the native FontSize -> 3 $Failed/4 rule when CurrentValue[FontSize] returns $Failed in the remote environment. No package-side suppression or font-size patch. The other failures are not filtered.

The remaining native integration risk areas listed above are a separate proposed investigation, not additional confirmed defects. Do not declare universal compatibility or start a broad refactor without agreeing scope with the maintainer. Keep the public Paclet and main unchanged until the new candidate is accepted.

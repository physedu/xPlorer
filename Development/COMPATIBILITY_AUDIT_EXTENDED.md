# Extended xAct compatibility audit and approved remediation plan

Date: 2026-11-27. Version: **1.0.0-beta.1**, development branch. Audited revision: [dcf7d929426b6368a3e633da5e563811d82b80b8](https://github.com/physedu/xPlorer/commit/dcf7d929426b6368a3e633da5e563811d82b80b8), verified identical to develop at the start of the investigation. Package blob: b58fe4c58072468c26b27114022cd1af543defa1. This document supplements, rather than replaces, [COMPATIBILITY_AUDIT.md](COMPATIBILITY_AUDIT.md). The maintainer approved the proposed remediation plan on 2026-11-27. Individual design choices below are recommendations, not new public API contracts. This is a research record; no fixes or new executable repository tests are included in this documentation commit.

## 1. Executive conclusion and release gate

Four new problem families were demonstrated experimentally, three in managed xPlorer state and one reproduced in native xCoba itself. They can lead to incorrect mathematical output without a warning. Do not publish the current public beta until these P0 issues have been addressed and their regressions pass. The overall architecture is sound: FLRW, nondiagonal Schwarzschild, metric revision, selective variance invalidation and same-background field dependencies passed new independent checks. Preserve native xTensor algebra, xCoba component storage and xPert perturbations; avoid a general rewrite or an alternative numerical tensor cache.

| ID | Finding | Severity | Evidence |
| --- | --- | --- | --- |
| A | Foreign background references enter via component assignments, profiles, native managed writes and metric inputs | P0 | Confirmed |
| B | A metric containing unresolved tensor field references gives incorrect curvature relative to the intended coordinate profile | P0 | Confirmed in both xPlorer and native xCoba |
| C | Geometry cached under ambient assumptions is reused under incompatible assumptions | P0 | Confirmed |
| D | Editing a metric can invalidate an associated independent connection's declared compatibility | P0 | Confirmed |

The preceding audit fixed separate named-component-index rendering and direct foreign-expression transport problems. Do not conflate those fixes with the indirect input paths identified here.

## 2. Reproduction environment and provenance

- Wolfram Language 15.0.1, Linux x86-64, remote kernel; no Mathematica Desktop visual acceptance.
- Official [xAct 1.3.0 archive](https://xact.es/download/xAct_1.3.0.zip), downloaded and extracted into temporary directories because xAct was initially absent. xTensor 1.3.0, xCoba 0.8.6, xPert 1.0.6, xPerm 1.2.4.
- Exact xPlorer revision loaded from the immutable raw GitHub URL. Independent kernels, portable permutation backend (xAct`xPerm`$xpermQ=False). Informational verbosity reduced, but no Quiet-based suppression of experimental failures.
- One initial probe aborted with Hold[Throw[Null]]; subsequent probes loaded from temporary .wl files and produced the results reported here. An initial contextual Wolfram lookup timed out; the actual evaluator and archive downloads succeeded.
- xCore, xTras and xPand source inspection was partial; no full runtime certification. xPand source was inspected at master, blob dc75d7631aca3ae80cc9213760beaef2834889df, version 0.4.3 (2015-09-09), not installed in the xAct archive.
- No changes to scientific code, tests, notebooks, main or public release were made during the audit. No full regression-suite rerun, other-version testing, external xPerm backend certification or desktop acceptance was performed.

### Fresh kernel setup for reproductions

Use a fresh kernel for each independent experiment. The remote evaluator used separate files to ensure source symbols are parsed after package loading. If xAct is already installed locally, omit the archive extraction.

```wl
d = CreateDirectory[];
f = FileNameJoin[{d, "xAct.zip"}];
URLDownload["https://xact.es/download/xAct_1.3.0.zip", f];
ExtractArchive[f, d];
AppendTo[$Path, d];
p = FileNameJoin[{d, "xPlorer.wl"}];
URLDownload["https://raw.githubusercontent.com/physedu/xPlorer/dcf7d929426b6368a3e633da5e563811d82b80b8/Paclet/xPlorer.wl", p];
Get[p];
```

Evaluate the next input separately after Get:

```wl
xAct`xPerm`$xpermQ = False;
$DefInfoQ = False;
$CVVerbose = False;
DefManifold[AuditM, 4, {aa,bb,cc,dd,ee,ff,ii,jj}];
DefMetric[-1, gg[-aa,-bb], CDa];
DefTensor[phia[], AuditM];
RegisterTheory["Metric", gg];
RegisterTheory["CovD", CDa];
RegisterTheory["Indices", {aa,bb,cc,dd,ee,ff,ii,jj}];
RegisterTheory["Field", phia];
```

Add the extra source definitions and registrations specified in each test *before* creating its backgrounds. Common two-background setup:

```wl
CreateBackground["One", SymbolSuffix -> "O"];
CreateBackground["Two", SymbolSuffix -> "T"];
DefineChart["One", {tt[],xx[],yy[],zz[]}];
DefineChart["Two", {tt[],xx[],yy[],zz[]}];
SetCMetricSystem["One", DiagonalMatrix[{-1,1,1,1}], ComputeOnSet -> None];
SetCMetricSystem["Two", DiagonalMatrix[{-1,1,1,1}], ComputeOnSet -> None];
```

## 3. Finding A — indirect foreign ownership

**Confirmed.** Direct transport correctly rejects foreign managed objects, but values assigned to managed objects are not uniformly checked. In a fresh kernel with the common setup:

```wl
SetFieldComponents["One", phia, 2];
SetFieldComponents["Two", phia, 7];
ToComponents["Two", phiaT[]] (* 7 *)
SetFieldComponents["Two", phia, phiaO[]]
ToComponents["Two", phiaT[], StrictComponents -> True] (* 2 *)
PortExpression["Two", phiaO[]] (* Failure["ForeignBackground", ...] *)
```

The assignment returned a record with Head in xPlorer`Backgrounds`B2` and Values equal to xPlorer`Backgrounds`B1`phiaO[]. No warning identified the foreign dependency. In a second fresh kernel:

```wl
SetFieldComponents["One", phia, 2];
SetFieldComponents["Two", phia, 7];
RegisterProfile["Two", "Foreign", phia, phiaO[]];
ActivateProfile["Two", "Foreign"];
ToComponents["Two", phiaT[], StrictComponents -> True] (* 2 *)
SetFieldComponents["One", phia, 11];
ToComponents["Two", phiaT[], StrictComponents -> True] (* 11 *)
SetFieldComponents["Two", phia, 7];
ComponentValue[phiaT[], phiaO[]] (* accepted native Rule *)
ToComponents["Two", phiaT[], StrictComponents -> True] (* 11 *)
SetCMetricSystem["Two",
  DiagonalMatrix[{-1, 1 + xxO[]^2, 1, 1}], ComputeOnSet -> None]
MetricMatrixOf["Two"] (* retains the coordinate xxO[] from One *)
```

The last probe establishes acceptance and persistence of a foreign coordinate, not an experimentally wrong curvature for that particular metric. Independent-connection coefficients and secondary chart maps are analogous unchecked input paths by source inspection, not confirmed experimental failures.

**Cause.** [fieldComponentRecord, lines 958–980](https://github.com/physedu/xPlorer/blob/dcf7d929426b6368a3e633da5e563811d82b80b8/Paclet/xPlorer.wl#L958-L980) evaluates profile[input,b] and checks rank, dimensions, LI order and symmetries but not ownership of evaluated values. Profiles reuse that path; captureManagedScalar stores the actual native rule; SetCMetricSystem stores the evaluated matrix without the equivalent owner guard. ToComponents guards the requested expression before native resolution, but foreign symbols introduced by stored values can resolve to valid numbers before the final strict unresolved check.

**Remediation.** Reuse expressionOwners/backgroundExpressionGuard centrally on all managed inputs (including evaluated pure functions, assumptions, delayed rules, native captured scalar/array/sparse/held writes, chart maps, metric and connection arrays, profile registration/activation and replay/reconstruction). Validate before mutation and also validate staged actual values, because evaluation and native simplification may introduce references. Consider guarding expanded/resolved intermediates as a second line of defense, but checking only the final numeric result cannot recover lost provenance. Reject foreign dependencies explicitly; allow shared constants, ownerless values, legitimate source formulas where transport is defined, deliberate multi-owner comparison/display, and already evaluated snapshots. Preserve genuinely unmanaged native dispatch. Test unchanged records, revisions, values and caches on rejection.

## 4. Finding B — metrics depending on fields

**Confirmed; native contract issue, not a new curvature algorithm error.** With a managed background and the common scalar field:

```wl
SetFieldComponents["One", phia, ttO[]^3];
SetCMetricSystem["One", DiagonalMatrix[{-1,phiaO[]^2,phiaO[]^2,phiaO[]^2}],
  ComputeOnSet -> None];
ToComponents["One", RicciScalarCDa[], StrictComponents -> True] (* 0 *)
SetFieldComponents["One", phia, ttO[]^2];
ToComponents["One", RicciScalarCDa[], StrictComponents -> True] (* 0 *)
```

For the intended FLRW profile a(t)=phi(t), R=6(a''/a+(a'/a)^2); the expected values are 90/t^2 and 36/t^2 respectively. The very first calculation is incorrect under that intended interpretation, so cache invalidation alone is insufficient.

Native-only independent control:

```wl
(* Fresh kernel with xAct installed, no xPlorer *)
Needs["xAct`xCoba`"];
xAct`xPerm`$xpermQ=False;
DefManifold[AuditM,4,{aa,bb,cc,dd,ee,ff,ii,jj}];
DefMetric[-1,gg[-aa,-bb],CDa];
DefTensor[phia[],AuditM];
DefChart[chartN,AuditM,{0,1,2,3},{tt[],xx[],yy[],zz[]}];
ComponentValue[phia[],tt[]^3];
ComponentValue[phia[]] (* phia[] -> tt[]^3 *)
ToValues[PDOfBasis[chartN][{0,-chartN}][phia[]]] (* 3 tt[]^2 *)
MetricInBasis[gg,-chartN,DiagonalMatrix[{-1,phia[]^2,phia[]^2,phia[]^2}]];
MetricCompute[gg,chartN,{"RicciScalar"[]}];
ToValues[RicciScalarCDa[]] (* 0 *)
```

Native MetricCompute differentiates stored coordinate arrays with ordinary D; a component rule is not automatically substituted into those arrays before differentiation. See xCoba.m DMetricPointer around line 3857. The managed setter currently accepts this representation without defining its meaning.

**Decision needed.** For beta, prefer safe rejection of unresolved tensor references in geometry inputs or an explicitly documented snapshot of fully resolved coordinate components. Explicit coordinate functions remain the native-compatible workflow. Dynamic metric/connection/field dependency support would require dependency tracking, cycle detection, recomputation, validation and consistent assumptions; do not silently introduce it. This matters for scalar-tensor, conformal and metric-affine work.

## 5. Finding C — assumptions and cache identity

**Confirmed.** Register a source constant ka before CreateBackground:

```wl
DefConstantSymbol[ka];
RegisterTheory["Parameter", ka];
```

Use a fresh One background, then:

```wl
SetCMetricSystem["One",
  DiagonalMatrix[{-1,(1+Abs[ka] ttO[])^2,(1+Abs[ka] ttO[])^2,(1+Abs[ka] ttO[])^2}],
  ComputeOnSet -> None];
pos = Block[{$Assumptions = ka > 0},
  ToComponents["One", RicciScalarCDa[], CVSimplify -> Simplify, StrictComponents -> True]];
neg = Block[{$Assumptions = ka < 0},
  ToComponents["One", RicciScalarCDa[], CVSimplify -> Simplify, StrictComponents -> True]];
ClearComputedValues["One"];
fresh = Block[{$Assumptions = ka < 0},
  ToComponents["One", RicciScalarCDa[], CVSimplify -> Simplify, StrictComponents -> True]];
{neg,fresh} /. {ka -> -2, ttO[] -> 1} (* {24, 8/3} *)
```

Both pos and cached neg were 6 ka^2/(1+ka t)^2. Fresh was 6 ka^2/(1+Abs[ka] t)^2. Correct negative branch is equivalent to 6 ka^2/(1-ka t)^2. The reused result is nine times the correct result at the test point.

**Cause.** [ComputeGeometry, lines 867–894](https://github.com/physedu/xPlorer/blob/dcf7d929426b6368a3e633da5e563811d82b80b8/Paclet/xPlorer.wl#L867-L894) tracks policy={fun,ass}, but Simplify can depend on dynamic $Assumptions and the registered assumptions are not explicitly supplied to the native simplifier at this call. The native capture path and field simplification policies also deserve investigation.

**Remediation.** Define effective assumptions explicitly, preferably using a deterministic managed simplifier with those assumptions instead of ambient state. Alternatively include effective ambient assumptions in cache identity. Handle custom simplifier functions with mutable definitions conservatively. Test both sign branches, explicit registered and call-local assumptions, native MetricCompute entry, field variance and derivative caches, and restoration of ambient state. Retain useful selective caching; do not clear everything on every query. A change to final-output simplification alone cannot restore information already discarded in cached geometry.

## 6. Finding D — independent connection becomes inconsistent after metric update

**Confirmed.** Before creating the background, add:

```wl
DefCovD[DAa[-aa],{},FromMetric->gg,Torsion->True];
RegisterTheory["Connection","Affine",DAa];
```

Create One with the common Minkowski setup. The difference tensor has slot order {upper output, lower derivative, lower input}:

```wl
ga = ConstantArray[0,{4,4,4}];
ga[[2,1,3]]=1;
ga[[3,1,2]]=-1;
SetConnectionComponents["One","Affine",ga,ReferenceConnection->"Primary"];
CheckConnection["One","Affine"]["MetricCompatible"]["Status"] (* "Passed" *)
SetCMetricSystem["One",DiagonalMatrix[{-1,4,1,1}],ComputeOnSet->None]
res = CheckConnection["One","Affine"]["MetricCompatible"];
res["Status"] (* "Failed" *)
res["Residual"][[1,2,3]] (* -3 *)
DAa[-aa][gg[-bb,-cc]] (* 0 *)
```

The metric edit is accepted despite the new residual. The native abstract declaration still implies nabla g=0, whereas the assigned connection has nabla_0 g_12=-3. This is a contradiction between abstract algebra and concrete inputs.

**Cause.** [SetCMetricSystem 793–804](https://github.com/physedu/xPlorer/blob/dcf7d929426b6368a3e633da5e563811d82b80b8/Paclet/xPlorer.wl#L793-L804) calls replayConnections, which calls storeConnection without repeating the initial torsion, flatness and metric-compatibility checks in [SetConnectionComponents 2402–2429](https://github.com/physedu/xPlorer/blob/dcf7d929426b6368a3e633da5e563811d82b80b8/Paclet/xPlorer.wl#L2402-L2429). See also [2390–2401](https://github.com/physedu/xPlorer/blob/dcf7d929426b6368a3e633da5e563811d82b80b8/Paclet/xPlorer.wl#L2390-L2401).

**Remediation.** Revalidate dependent connections under proposed metric, coordinate map, reference connection and effective assumptions before committing new state. Reject incompatible updates and preserve previous input records, native values, saved results, caches and revisions. Never silently change FromMetric/Torsion/Curvature declarations or delete connections. Check flatness after reference-metric changes as well (a risk, not yet reproduced). Test restoration if native write or replay fails.

## 7. Positive control experiments

### FLRW and field variance

For spatially flat FLRW with a(t)=t^p, R=6p(2p-1)/t^2 with the tested sign convention. Native xAct with p=1 gave 6/t^2. Two managed backgrounds were assigned p=1 and p=2, then One was changed to p=3. A covector with lower components {0,1,0,0} was assigned to One.

| Check | Observed, equals expected |
| --- | --- |
| One curvature initially | 6/t_O^2 |
| Two curvature initially | 36/t_T^2 |
| One curvature after metric update | 90/t_O^2 |
| Two curvature unchanged | 36/t_T^2 |
| One raised spatial vector before | {0,t_O^(-2),0,0} |
| One raised spatial vector after | {0,t_O^(-6),0,0} |
| One lower source vector after | {0,1,0,0} |

Register an independent covector Va[-aa] before background creation. Use SetFieldComponents["One",Va,{0,1,0,0}] and ToComponents["One",Va[aa]] / Va[-aa] for the variance probes. Metrics are DiagonalMatrix[{-1,t^(2p),t^(2p),t^(2p)}]. Source scalar curvature is RicciScalarCDa[].

With two registered scalars in the same background, psia[]=phiaO[] and phiaO[]=ttO[]^2, ToComponents["One",CDa[-aa][psia[]],StrictComponents->True] gave {2 ttO[],0,0,0}; after setting phia to ttO[]^3 it gave {3 ttO[]^2,0,0,0}. This validates a representative same-owner transitively dependent field derivative; preserve this behavior.

### Nondiagonal Schwarzschild

Advanced Eddington–Finkelstein coordinates, ds^2=-(1-2M/r)dv^2+2 dv dr+r^2 dOmega^2.

```wl
ef[m_,r_,theta_]:={{-(1-2m/r),1,0,0},{1,0,0,0},
  {0,0,r^2,0},{0,0,0,r^2 Sin[theta]^2}};
```

Native chart coordinates {vv[],rr[],th[],pp[]}, MetricInBasis and MetricCompute for RicciScalar and Kretschmann with CVSimplify->Simplify. Managed background EF with suffix E, same coordinates, SetCMetricSystem with ef[1,rrE[],thE[]], then ef[2,rrE[],thE[]]. ToComponents used StrictComponents->True and CVSimplify->Simplify.

| Invariant | Native/analytic reference | Managed result |
| --- | --- | --- |
| R, M=1 | 0 | 0 |
| Kretschmann, M=1 | 48/r^6 | 48/r^6 |
| Kretschmann, M=2 after update | 192/r^6 (analytic) | 192/r^6 |

These checks support keeping the native geometry and selective invalidation architecture.

## 8. Presentation contracts and global output

The native source confirms PrintAsString accepts strings, held expressions and certain boxes, but downstream consumers are more restrictive. DerSymbolLength expects a String; IndexLength accesses First[SymbolOfCovD[der]]. CIndexForm with $CIndexForm=True uses a coordinate's PrintAs. IndexForm[LI[x__]] can use StringJoin. The earlier coordinate-label repair that leaves native strings intact and decorates interpreted scalar boxes afterward is consistent with those contracts.

Current labelledNotationBoxes uses Internal`InheritedBlock on non-coordinate heads to alter formatting temporarily. It is not intrinsically wrong; prefer final box decoration wherever safe. Verify structural roundtrip using MakeBoxes, ToExpression with HoldComplete, Normal of views, native metadata restoration, TeX and actual Desktop copy/paste. Multiple LI labels, function-based PrintAs, custom covariant markers, nested derivatives, xPand projected tensors, abort restoration and TexAct remain untested here.

xPert sets $PrePrint=ScreenDollarIndices and changes $CovDFormat and ContractMetric/MakeRule options at load. xPlorer composes an existing hook through notebookPrint/updatePrintHook. Test load orders xAct→xPlorer, xPlorer→xTras, xTras→xPlorer, xPand→xPlorer, custom hooks before and after, and repeated loading. Consider a supported enable/disable/restore presentation mechanism. Do not claim global formatting untouched or change mathematical objects for visual labels.

## 9. Native dispatch, Rule/Set and cache structures

Actual native attributes recorded: ComponentValue, AllComponentValues, ToValues, RuleToSet, SetToRule are Protected; HeldComponentValue and WithSetValues are HoldFirst, Protected. ComponentValue[expr,value] uses $CVSimplify; HeldComponentValue uses a distinct unsimplified input route. Preserve evaluation, CVReplace, CVSimplify, delayed inputs, messages, return values and explicit basis dispatch.

Managed upvalues/downvalues extend ComponentValue, HeldComponentValue, AllComponentValues, ToValues, MetricInBasis, MetricCompute, SetBasisChange, unary ToCTensor, DeleteTensorValues, ChangeComponents, UndefChart, UndefBasis, and temporary Undef behavior. See source 1241–1258 and 1435–1507. Test native objects outside xPlorer and all original overloads, especially MetricInBasis with matrices, diagonal vectors, CTensor, tensor expressions, special orthonormal/orthogonal inputs and external bases. Native-only edits outside the documented managed contract remain native; do not falsely promise synchronization.

xCoba stores authoritative and derived groups keyed by ValID, with FoldedRule and TensorValues. Native ToValues (xCoba.m 2401–2404) folds replacement over selected tensor groups. Geometry ReportCompute pointer caches are separate from native component rules; clearing one does not necessarily regenerate the other. Native deletion may change Set state. xPlorer uses FixedPoint[ToValues,expr,12]; this helps resolve nested references but does not detect inconsistent or cyclic dependencies such as phi=psi+1, psi=phi+1. This cycle has not been executed. Detect explicit cycles or reject unresolved dependency graphs; arbitrary mutable Wolfram definitions cannot be fully tracked. Define a bounded, documented contract.

The explicit NativeSetState guard is a deliberate safe limitation, not an established defect. RuleToSet, SetToRule and WithSetValues should retain native behavior. Read-only Set support may be explored without silently converting state. Test held literal versus evaluated/aliased inputs, aborts, restoration and foreign native objects.

Other untested risks: redefinition of external functions, chart maps dependent on mutable parameters, higher perturbation-order derivatives, global curvature sign changes, manually altered native cache entries. Preserve authoritative inputs and avoid a second numerical tensor cache.

## 10. Charts, bases and connections

The architecture of native DefChart/SetBasisChange plus tensor-slot transformations and scalar coordinate substitution is sound for ordinary tensors. For x=x(y), J^mu_alpha=dx^mu/dy^alpha, g'=J^T g J, contravariant vectors transform by J^-1, covectors by J. Connection coefficients additionally need the Hessian term (already represented by ConnectionMatrixOf). Densities require appropriate determinant factors; restrictions on nonzero weight are reasonable pending complete support.

Recommended independent nonlinear test (analytic reference only, not run): x=X+Y^2, y=Y, with t,z unchanged. Flat spacetime metric transforms to {{-1,0,0,0},{0,1,2Y,0},{0,2Y,1+4Y^2,0},{0,0,0,1}} and Gamma^X_YY=2, while Riemann vanishes. Check all variances, secondary-chart native values, affine coefficients, perturbations, and roundtrip. Test singular domains and Jacobian assumptions, foreign map values, parameter-dependent map mutation, unmanaged/noncoordinate bases and deletion of one managed pair without affecting other pairs. No general basis support is claimed.

## 11. Lifecycle and private dependencies

MasterOf, ServantsOf, VisitorsOf and Undef represent genuine native object relations. Deletion functions perform destructive steps before registry removal; failures may leave an incomplete native state even when a registry entry survives. No actual partial deletion was reproduced. Prefer preflight and staged validation, diagnostics for partial failure, blocking further use of a damaged background and explicit recovery; avoid a general Wolfram transaction system.

| Native dependency / structural assumption | Purpose | Risk |
| --- | --- | --- |
| xTensor Private PrintAsString | Normalize labels | Medium |
| xCoba Private CTensorBases | Inspect signed bases | High |
| xCoba Private CacheKeySymbolic | Map geometry specs to heads | High |
| xCoba Private signedbases | Slot variance | High |
| xCoba Private Depends | Geometry dependency graph | High |
| xCoba Private StateOfValID | Rule/Set detection | High |
| xTensor Private $Christoffels | Relative connections and deletion | High |
| xCobaCacheTable and ClearxCobaCache | Inspect/invalidate pointer cache | High |
| FoldedRule and ValID layout | Inspect stored rules and configurations | High |

The last entries are internal structural coupling, not necessarily Private-context symbols. Source anchors in native xCoba.m include CacheKeySymbolic 3543+, signedbases 3619, Depends 4072+, MetricCompute 3288+, DMetricPointer 3857, TensorValues 2022+, ToValues 2401+, WithSetValues 2416+.

Encapsulate necessary private calls in a small internal NativeCompatibility layer with contract/version probes and fail-safe behavior; conceptual functions nativeGeometryDependencies, nativeComponentState, nativeGeometryCacheEntries, nativeClearGeometryCache, nativeConnectionDependencies. Prefer stable public APIs when equivalent, not hand-built replacements for native tensor names. No new public API is required for this refactoring.

## 12. xTras, xPand and other extensions

xTras/xPert.m in the actual distribution implements metric VarD and VarL using xPert; preserve metric, connection and perturbation identities through transport. Planned native/source/transport comparisons: Einstein–Hilbert (G_munu for variation w.r.t. inverse metric, boundary terms omitted), R^2 (2 R R_munu - 1/2 g_munu R^2 + 2(g_munu Box - nabla_mu nabla_nu)R), matter stress tensor, vector Euler–Lagrange, 4D Gauss–Bonnet and Bianchi identities. No new VarL/VarD incompatibility confirmed and no comprehensive execution.

xPand (source at https://github.com/xAct-contrib/xPand/blob/master/xPand.m) uses DefProjectedTensor, SetSlicing, DefMetricFields, SplitPerturbations, multiple LI labels, induced metrics, normal vectors, transversality, projections, global $ConformalTime, and global additions to NoScalar/LieD. A projected tensor is not merely an ordinary tensor with slot symmetries: h_munu=g_munu+n_mu n_nu for unit timelike n, and n^mu T_munu=0 for spatial tensors. Existing field-scope rejection of projections, nonzero weight, foreign bundles and unverified perturbation structures is preferable to partial copying. Distinguish coexistence, supported transport and full integration of foliations. Prioritize coexistence; full xPand integration is not a beta requirement. xCore/xPerm/xPert interfaces and additional extensions also need broader differential testing. xPerm portable backend was used in experiments, not exhaustive external backend testing.

## 13. Existing tests and coverage gaps

Textual inventory: 48 .wl files in Tests and the two public notebooks were scanned at the audited revision. Focused reading included Fixture, RunGroup, CompatibilityAuditTests, 03_Perturbations, 09_ConnectionComponents, 18_SecondaryChartNative and 32_NativeSetState. None of the 48 test files contains the literal $Assumptions; this does not imply absence of every assumptions-related test, only that dynamic ambient changes are not explicitly covered by that literal. Existing direct ForeignBackground regression does not cover new indirect input paths. Prior reports and notebook validations remain historical evidence, not fresh reruns in this audit.

Proposed regression checklist (not yet implemented):

| Test | Acceptance criterion | Priority |
| --- | --- | --- |
| ForeignFieldComponents | Reject cross-owner values, preserve state | P0 |
| ForeignNativeComponentValue | Managed native writes preserve owner contract, including held/sparse/array | P0 |
| ForeignProfile | Reject foreign registration and activation | P0 |
| ForeignMetric | Reject foreign coordinates and preserve previous geometry | P0 |
| ForeignConnection | Reject foreign coefficients | P0 |
| ForeignChartMap | Reject foreign evaluated map | P0 |
| MetricFieldDependency | Enforce explicit reject/snapshot/dynamic contract; no false zero | P0 |
| GeometryAssumptionsCache | Cached and fresh results agree under changed assumptions | P0 |
| ConnectionCompatibilityAfterMetricEdit | Preserve declared metric compatibility | P0 |
| FlatConnectionAfterMetricEdit | Preserve flatness under reference update | P1 |
| MetricEditRollback | Rejected update restores native and managed state | P1 |
| CyclicFieldDependency | Detect cycles and inconsistent dependencies | P1 |
| NonDiagonalChartTransformation | Nonlinear chart tensor and connection reference values | P1 |
| HigherOrderPerturbationCache | Invalidate derived configurations after LI-order edits | P1 |
| PartialLifecycleFailure | Detect damaged state and provide recovery | P1 |
| NativeDispatchDifferential | Compare unmanaged dispatch, attributes/options and state with native-only kernel | P1 |
| xTrasVariationTransport | Source and copied variation equivalence | P2 |
| xPandCoexistence | Independent native usage and load orders | P2 |
| DesktopBoxesRoundtrip | Correct output, interpretation, copy/paste, TeX | P2 |

Test rejected operations for failure *before* mutation, unchanged old values, revision counters, cached geometry, saved results, unrelated backgrounds and native objects. Compare against independent analytic and native references, not solely self-consistency checks. For simplification use equivalence under explicit domains, not only SameQ. Keep real Print and diagnostic messages; do not hide failures. Run focused regressions then all relevant groups and public notebook inputs in fresh kernels; Desktop acceptance and actual paclet installation remain separate release gates.

## 14. Approved implementation sequence

The maintainer accepted this plan; implementation must remain on develop. No new public features before the mathematical correctness gates.

1. **P0 — Isolation:** central owner validation across all managed mathematical entry paths; evaluated inputs, staged native writes, profiles, chart maps and reconstruction. Preserve legitimate comparison and source transport. Add regressions.
2. **P0 — Geometric consistency:** revalidate independent connections upon metric/reference changes and ensure atomic rejection where feasible. Decide and document the semantics of field-dependent geometry (conservative safe rejection or explicit snapshots first; dynamic dependency model only by separate agreement). Add regressions.
3. **P0 — Cache policy:** make assumptions and simplification policy reproducible; detect or control mutable policies and preserve selective invalidation. Add positive and negative branch tests against fresh calculations.
4. **P1 — Internal robustness:** native compatibility adapter, lifecycle preflight/diagnostics and recovery, cycle detection, native dispatch and higher-order cache regression. Avoid a broad rewrite.
5. **P2 — Extended interoperability:** xTras, xPand coexistence, broader bases and perturbations, and further presentation/desktop tests. Full xPand foliation copying is out of current scope.

Recommended decisions still to settle explicitly: reject unresolved field metric inputs versus explicit snapshots; managed explicit assumptions versus ambient assumptions included in cache identity; reject incompatible connection updates while preserving prior state rather than mutating the physical declarations. The preferred options are conservative and fail-safe. Prioritize isolation and connection revalidation, then cache policy, with dynamic geometry support deferred until its semantics are agreed.

## 15. References

- [Audited source tree](https://github.com/physedu/xPlorer/tree/dcf7d929426b6368a3e633da5e563811d82b80b8), [package](https://github.com/physedu/xPlorer/blob/dcf7d929426b6368a3e633da5e563811d82b80b8/Paclet/xPlorer.wl), [tests](https://github.com/physedu/xPlorer/tree/dcf7d929426b6368a3e633da5e563811d82b80b8/Tests).
- [xAct distribution](https://xact.es/download/xAct_1.3.0.zip), [xTensor](https://xact.es/xTensor/), [xCoba](https://xact.es/xCoba/), [xPert](https://xact.es/xPert/), [xTras](https://xact.es/xTras/), [xPand source](https://github.com/xAct-contrib/xPand/blob/master/xPand.m), [xAct forum](https://groups.google.com/g/xAct).
- Wolfram Language: [HoldFirst](https://reference.wolfram.com/language/ref/HoldFirst.html), [MakeBoxes](https://reference.wolfram.com/language/ref/MakeBoxes.html), [$Assumptions](https://reference.wolfram.com/language/ref/$Assumptions.html).
- Previous audit and resolution history: [COMPATIBILITY_AUDIT.md](COMPATIBILITY_AUDIT.md). This extended record is the current remediation reference, not a replacement for earlier regression evidence.


---

## 16. Implementation progress — Phase 1 (2026-11-27)

**Status: implemented on `develop`; focused regression coverage passes.** This section records work performed after the original audit. It does not mark the overall P0 release gate as complete: geometry/connection consistency (Phase 2) and cache policy (Phase 3) remain open.

### 16.1. Changes in `Paclet/xPlorer.wl`

- Added `profileForBackground`, which checks ownership both before and after evaluating a coordinate-dependent profile. Applied it to field, metric and connection inputs.
- Added owner checks to field-record application and profile snapshots, including profile activation/replay.
- Guarded managed scalar writes through `ComponentValue` and `HeldComponentValue`, partial component writes, and complete component arrays. The native scalar capture path checks the staged value and restores the previous value if a foreign dependency appears after evaluation; restoration failure is reported separately.
- Guarded metric arrays, metric component staging, metric assumptions, connection arrays and connection assumptions before committing state.
- Guarded primary and secondary chart maps before chart creation and after evaluating their coordinate values. A failed secondary chart is removed.
- Guarded reconstruction export and import. A reconstruction recipe may refer to its declared original owner, but not to a second active background. Remapped profiles and rule groups are checked before being stored.
- Extended `expressionOwners` to inspect explicit values inside `SparseArray` objects, which are otherwise opaque to ordinary structural traversal.
- Added `theoryExpressionGuard` to prevent active-background objects from entering the global source theory through metric, covariant derivative, index, assumption/condition, field, parameter, formula, connection, presentation or association-snapshot registration. `CreateBackground` also validates the complete source theory before creating a new background.
- Extended held managed syntax recognition to include zero-slot scalar tensor expressions, so held scalar writes can be routed through the managed guard. The native held semantics remain intact.

The guard is deliberately provenance-based: an explicitly evaluated numeric value can be transferred as a snapshot. A live expression referring to another active background is rejected. This avoids claiming that a numeric snapshot still carries recoverable provenance after evaluation.

### 16.2. New regression group

Added [`Tests/36_ForeignInputIsolation.wl`](../Tests/36_ForeignInputIsolation.wl) and registered `ForeignInputIsolation` in [`Tests/RunGroup.wl`](../Tests/RunGroup.wl).

The group covers cross-owner field values, profile bodies and snapshots, native scalar/held/partial/array writes, sparse arrays, assumptions, metric matrices and metric native input, independent-connection inputs, secondary chart maps, theory registration, reconstruction recipes, and preservation of valid same-owner operation and numeric snapshots.

<badge color="success">39/39 passed</badge>

The test group ran in a fresh Wolfram Language 15.0.1 kernel with xAct 1.3.0 and the portable xPerm backend.

### 16.3. Existing focused regression groups

After the source-theory guards were added, the following existing standalone groups were rerun against the updated `develop` source:

| Group | Passed |
| --- | ---: |
| ManagedNativeSyntax | 13/13 |
| HeldFieldValues | 20/20 |
| SparseInputs | 26/26 |
| SelectedFieldReads | 24/24 |
| ProfilesAndCTensor | 33/33 |
| SecondaryChartNative | 3/3 |
| Consolidation | 30/30 |
| FieldCache | 23/23 |
| NativeRead | 22/22 |
| SelectiveInvalidation | 13/13 |
| MetricEdits | 13/13 |
| NativeSetState | 21/21 |
| **Total existing focused checks** | **241/241** |

Together with the new isolation group, this is **280/280 focused checks passed**. Each group was executed in an independent kernel using the exact test file and the matching runner from the audited development revision.

A full `Tests/RunTests.wl` invocation was attempted but did not complete in the remote evaluator: it returned `Hold[Throw[Null]]` while loading the shared Fixture, before a full-suite summary was produced. It is not counted as a pass. The focused group results above are the completed regression evidence; a clean full-suite run remains a validation task.

### 16.4. Next implementation step

Proceed with Phase 2: revalidate every connection whose compatibility or curvature declaration depends on a proposed metric/reference-connection change, before committing that change. A rejected edit must preserve the previous metric, connection records, native component values, revisions and caches. Do not silently rewrite the abstract connection declarations. Add explicit regressions for metric compatibility, flatness, and rollback after a failed validation.


---

## 17. Implementation progress — Phase 2 connection preflight (2026-11-28)

**Status: first confirmed metric-compatibility path repaired; focused regression passes.** This does not yet complete all of Phase 2. Flatness-specific preflight, every independent-connection input mode, all rollback failure modes, and wider existing regression groups remain to be tested.

### 17.1. Defect in the initial preflight implementation

The existing `preflightConnectionMetricChange` iterated over stored connections using `Do`, but used `Return[failure[...]]` from inside the iterator and then ended the surrounding Module with an unconditional `Null`. In the actual Wolfram kernel this did not propagate the incompatibility failure to `SetCMetricSystem`; the proposed metric was accepted. This was reproduced on the previous develop revision with the metric `DiagonalMatrix[{-1,4,1,1}]` and an independently stored metric-compatible connection. The subsequent `CheckConnection` returned `"Failed"`.

### 17.2. Source correction

Commit [ee2f372](https://github.com/physedu/xPlorer/commit/ee2f372646e06b0a8bde7fb8909ce24bc7ea4bdb) changes the loop's failure propagation to a tagged `Catch`/`Throw` path. Any failed connection lookup, torsion check, metric-compatibility check or flatness check now exits the whole preflight and returns its `Failure` to `SetCMetricSystem`. The preflight remains before `clearGeometry` and before native metric assignment. No abstract connection declaration is rewritten.

### 17.3. New regression

Added [`Tests/37_ConnectionMetricPreflight.wl`](../Tests/37_ConnectionMetricPreflight.wl) and registered `ConnectionMetricPreflight` in [`Tests/RunGroup.wl`](../Tests/RunGroup.wl). Commit [686af5b](https://github.com/physedu/xPlorer/commit/686af5b01f7add0564a28da5b9945cd9b1f71d1f).

The fresh-kernel test creates a metric-compatible independent connection with nonzero coefficients, proposes an incompatible metric, and checks that the operation returns `Failure["ConnectionMetricCompatibility",...]`. It verifies that the managed metric, connection coefficients, metric revision, native metric fingerprints, and connection input record all remain unchanged, and that the connection remains compatible after rejection. It also checks the identical-metric no-op.

<badge color="success">10/10 passed</badge>

Runtime: Wolfram Language 15.0.1, Linux x86-64, xAct 1.3.0, xCoba 0.8.6, xPerm 1.2.4 portable backend. Test executed via the repository's `RunGroup["ConnectionMetricPreflight"]` runner in a fresh kernel after downloading the exact source at commit 686af5b.

### 17.4. Scope and remaining work

- The test demonstrates atomic rejection for a metric-compatibility violation. It does not certify every possible native xCoba side effect or failure during later geometry computation.
- The flatness branch (`CurvatureQ[cc] === False`) is present in the preflight but still needs an independent regression using a declared-flat connection and a proposed update that makes its stored coefficients curved.
- Test a connection whose coefficients are relative to `"Coordinates"` as well as `"Primary"`, and multiple named connections where a later failure must reject the entire metric edit.
- Test valid metric edits that preserve compatibility, torsion and flatness.
- The broader focused groups `MetricEdits`, `ObjectsAndConnections` and `MetricConnectionCurvature` did not yield usable pass summaries in this remote run (`$Failed` or zero tests due to the shared test harness/context); they are **not counted as passes or regressions**. Rerun with the normal project test harness before declaring compatibility.
- Phase 2 remains open until these checks and rollback/replay failure paths are covered.

Next: complete the flatness and multi-connection tests, then proceed to Phase 3 (assumption-aware cache policy) only after the remaining P0 geometry checks are closed.

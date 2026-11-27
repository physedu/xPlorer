# xPlorer public API audit - beta.13-dev.36

Status: maintainer review / proposal, not an implementation or release decision.
Source: `Paclet/xPlorer.wl`, develop at commit `03737d74d93d75354b7670ef4c25b4dcd9d939fa`, source blob `230609a568b9f564585b163106defee2e535ae38`. Reviewed public usage declarations and relevant implementation bodies, current Workflow/native interoperability, and supplied xTensor/xCoba documentation. 77 documented callable names (excludes options and variables; not an enumeration of every native overload). No new kernel regression run for this read-only audit; native connection equivalences were verified in the dev.36 work (PR #9). This is an API design audit, not a claim that every replacement has been exercised in every variant.

## Principle

xAct performs the mathematics; xPlorer manages isolated studies, managed input records, cross-background transport, rules, profiles, chart maps, lifecycle and presentation. A native-looking overload supplied by xPlorer is not necessarily stock xAct. Avoid a second public name for an operation already performed naturally with an owned native head. Do not delete the underlying managed engine merely because its public wrapper is redundant.

## Inventory and recommendation

### Retire or consolidate public aliases (18)

| Function | Preferred alternative | Reason / caveat |
|---|---|---|
| `RicciOf` | `Ricci[CDSchw]` | Native curvature-head lookup; dynamic access through BackgroundObject[tag,"Ricci",connection]. |
| `RicciScalarOf` | `RicciScalar[CDSchw]` | Same; not defined for a general connection without a contraction metric. |
| `EinsteinOf` | `Einstein[CDSchw]` | Same; metric connection only. |
| `RiemannOf` | `Riemann[CDSchw]` | Same for primary or AffineAff. |
| `WeylOf` | `Weyl[CDSchw]` | Same; metric connection and dimension restrictions still apply. |
| `ChristoffelOf` | `Christoffel[CDSchw]` | Same; specify the reference derivative with Christoffel[CDSchw,PDOfBasis[chartSchw]] for coordinate coefficients. |
| `TorsionOf` | `Torsion[AffineAff]` | Native torsion head. |
| `ConnectionDifference` | `Christoffel[AffineAff,CDAff][aAff,-bAff,-cAff]` | Native difference tensor; explicit slots are preferable. |
| `ChartOf` | `chartSchw`; `BackgroundValue[tag,"Charts",name]["Chart"]` | The second form is a managed lookup, not an xAct native operation. |
| `BasisOf` | `chartSchw`; `BackgroundValue[tag,"Basis"]` | The managed chart is the basis in the current coordinated-chart model. |
| `CoordinatesOf` | `ScalarsOfChart[chartSchw]`; `Head /@ ScalarsOfChart[chartSchw]` | Native returns scalar expressions, not heads. Use Head /@ only when heads are needed. |
| `MetricMatrixOf` | `BackgroundValue[tag,"MetricMatrix"]` | Same recorded input, not a fresh native read. |
| `ConnectionsOf` | `BackgroundValue[tag,"Connections"]` | Already calls ConnectionsOf internally; invert dependency first. |
| `ToBasisOf` | `expr // ToBasis[chartSchw] // TraceBasisDummy` | Exact native chain, except wrapper error handling. |
| `ToValuesOf` | `expr // ToBasis[chartSchw] // TraceBasisDummy // ToValues` | Native chain; no added managed evaluation policy. |
| `ShowProfiles` | `ShowBackground[tag,"Profiles"]`; `BackgroundValue[tag,"Profiles"]` | Visual vs raw. Invert internal dependency before removing public alias. |
| `PresentationOf` | `ShowBackground[tag,"Presentation"]`; `BackgroundValue[tag,"Presentation"]` | Raw and visual views differ; ensure detailed defaults and overrides remain accessible. |
| `ShowTheoryKeys` | `Keys[TheorySnapshot[]] is NOT equivalent`; `TheoryValue needs a logical-section listing` | Low-value extra command; preserve normalized logical keys if consolidating. Do not equate raw registry keys to logical collection names. |

### Native-first public interface; preserve implementation (4)

| Function | Preferred alternative | Reason / caveat |
|---|---|---|
| `SetCMetricSystem` | `MetricInBasis[gSchw,matrix,opts]` | Managed shorthand routes into this engine; explicit native primary-chart arrays are also captured. Preserve assumptions, validation, replay, invalidation and ComputeOnSet. |
| `SetFieldComponents` | `ComponentValue[phiSchw[],u[rSchw[]]]`; `AllComponentValues[ASchw[{-aSchw,-chartSchw}],array]` | Managed primary input capture and held/sparse/LI cases use its machinery. Keep advanced source-head/function input capability until equivalent native path proven. |
| `ComputeGeometry` | `MetricCompute[gSchw,{"Ricci","Einstein"}]` | This shorthand is a managed extension of the native name, not stock xCoba syntax. Stock explicit MetricCompute[gSchw,chartSchw,"Ricci"[-1,-1]] is a different signature. Preserve cache accounting, force/assumptions and selective targets. |
| `ClearFieldComponents` | `DeleteTensorValues[ASchw]` | Managed full-field deletion dispatches to the same engine; preserve input record cleanup and invalidation. |

### Optional or consolidate after evidence (14)

| Function | Preferred alternative | Reason / caveat |
|---|---|---|
| `ConnectionOf` | `CDSchw`; `AffineAff`; `BackgroundObject[tag,"Affine"]` | Useful source-derivative-to-copy lookup not exactly identical to string lookup. Keep internally or add a tested unified selector. |
| `BackgroundIndices` | `aSchw,bSchw`; `BackgroundValue[tag,"Indices"]` | Useful for dynamic selection and custom Greek indices; native bundle index pools need not equal recorded initial list. Consider removing dedicated public getter. |
| `ApplyRules` | `expr /. BackgroundValue[tag,"Rules"]["Effective"]` | Convenience: rule order matters; keep if explicit abstract specialization is frequent. |
| `UseExpression` | `BackgroundExpression[tag,key] plus ApplyRules or named formula // ToComponents` | Not equivalent to bare alias: actively applies rules; keep if used for specialized abstract results, else unify with BackgroundExpression and explicit option. |
| `BackgroundExpression` | `scalarEqSchw`; `PortExpression[tag,expr]` | Useful dynamic qualified lookup and alias-collision disambiguation; keep if one canonical named-formula reader is needed. |
| `SetFlatRules` | `AddRules with explicit curvature rules` | Convenience, not a flatness check. Consider replacing example with named physically justified rules; never assume flatness. |
| `TheorySector` | `TheoryValue collections filtered by Sector` | Convenient registry-only grouping, not native xAct; possible consolidation into TheoryValue or ShowTheory. |
| `SaveResult` | `Ordinary assignment only if stale-value tracking not required` | Distinct in-memory invalidation benefit, not persistence. Optional; review actual researcher demand before removing. |
| `ResultOf` | `No equivalent ordinary variable with invalidation` | Paired with SaveResult; retire together only if feature dropped. |
| `CheckBackground` | `Native residuals plus Simplify under assumptions` | Higher-level validation with Passed/Failed/Inconclusive and managed consistency; optional, not redundant. |
| `CheckConnection` | `Native torsion and metric-compatibility residuals` | Higher-level explicit diagnostic; optional, not redundant. |
| `AboutXPlorer` | `$XPlorerVersion and README` | Low-impact convenience; retain if useful for reports. |
| `ShowRules` | `ShowBackground[tag,"Rules"]`; `BackgroundValue[tag,"Rules"]["Effective"]` | Numbered view supports RemoveRules positions; preserve that user-facing path. |
| `ShowRuleGroups` | `ShowBackground[tag,"Rules"]`; `BackgroundValue[tag,"Rules"]` | Status form is already the data provider; raw group-only form differs. Consolidate only with exact group/active/individual/effective/conflicts coverage. |

### Keep as managed capabilities (41)

| Function | Why retain |
|---|---|
| `RegisterTheory` | Registry captures native definitions and named formulas |
| `ClearTheory` | Reset registry without undefining native objects |
| `UnregisterTheory` | Dependency-aware removal of registrations |
| `ShowTheory` | Scientific inspection |
| `TheoryValue` | Programmatic logical registry access |
| `TheorySnapshot` | Restorable captured registry |
| `CreateBackground` | Independent cloned native geometry/fields/aliases |
| `AddField` | Copy registered field into existing background |
| `AddConnection` | Copy named independent connection |
| `PortExpression` | Transport new abstract expression across manifolds |
| `DefineChart` | Owned charts, aliases, basis changes and map replay |
| `ToComponents` | Ownership, porting, free slots, rules, lazy geometry, strict unresolved detection and secondary maps |
| `PerturbOn` | Managed xPert variation plus order/form and component output; not just Perturbation |
| `SetConnectionComponents` | Independent coefficient/difference input and capture |
| `ConnectionMatrixOf` | Coefficient reference and nonlinear chart Hessian transformation, not tensor-only basis conversion |
| `ShowBackground` | Scientific read-only view |
| `BackgroundValue` | Managed data accessor |
| `BackgroundObject` | Unified owned-symbol accessor |
| `AddRules` | Managed specialization |
| `ClearRules` | Managed specialization reset |
| `ReplaceRules` | Replace effective independent rules and active groups |
| `RemoveRules` | Remove selected rules, maintain group state |
| `SetRuleGroup` | Named rule definition |
| `ActivateRuleGroups` | Ordered activation with independent rules |
| `DeactivateRuleGroups` | Selective deactivation |
| `RemoveRuleGroup` | Remove group and refresh state |
| `RegisterProfile` | Record managed field inputs |
| `ActivateProfile` | Overlay and replay managed inputs |
| `RemoveProfile` | Delete profile without changing current values |
| `ClearComputedValues` | Clear derived geometry and replay declared inputs |
| `DeleteBackground` | Dependency-aware owned teardown |
| `ClearBackgrounds` | Teardown all owned backgrounds |
| `DeletionPlan` | Preview external blockers and deletion order |
| `DeleteBackgroundObject` | Selective cascade-safe deletion |
| `ReconstructionData` | Export managed reconstruction recipe |
| `RecreateBackground` | Rebuild independent native objects from recipe |
| `SetXPlorerPreferences` | Session presentation defaults |
| `SetNotation` | Background/chart display overrides |
| `SetPresentation` | Owned-head presentation and override inheritance |
| `PrettyExp` | Display-only interpreted view and label plan |
| `ExpressionText` | Replay text and managed TeX/TexAct export; raw TeXForm alone does not preserve formatting contract |

## Legacy option

- `Managed -> True`: legacy marker retained on scalar ComponentValue and full DeleteTensorValues. Ordinary managed calls already capture these operations. Candidate to remove after testing and documenting migration. It is an option, not one of the 77 functions.
- Retain native overloads (MetricInBasis, MetricCompute, ComponentValue, HeldComponentValue, AllComponentValues, DeleteTensorValues, ToCTensor, etc.) as long as they provide validated ownership and synchronization; audit their scope separately. Do not modify unowned xAct objects.

## Proposed sequence

1. Before the public beta, use native heads and commands in tutorials wherever equivalent. Keep compatibility for the current candidate. The existing folded Workflow is a reference, not a requirement to use all public functions.
2. With maintainer approval, remove or deprecate the 18 alias/consolidation candidates and retire the four managed engine names from the preferred public surface, after migrating internal call sites to private implementations. Review the 14 optional/consolidation items separately. This is a maximum proposed first-stage reduction of 22 public names, not an unconditional deletion list.
3. Preserve dynamic lookup through BackgroundObject/BackgroundValue/TheoryValue, failure semantics, native dispatch scope, field/metric/cache invalidation, rule order, recipes, and chart transformations. Keep the compatibility shims until the corresponding acceptance tests pass. Do not change main, historical branches or publish a release as part of this audit.
4. Test equivalent native calls for primary and secondary charts, affine connections, metric perturbations, sparse and held inputs, custom names, external objects, deletion and recreation. Rerun the full historical suite plus Workflow and Quick Start with native Print enabled. Compare actual math and state, not just output appearance. Document intentionally unsupported native patterns.

## Suggested everyday workflow

```wl
(* After native source definitions and registration *)
CreateBackground["Schwarzschild", SymbolSuffix -> "Schw"];
DefineChart["Schwarzschild", {t[],r[],theta[],varphi[]}];
MetricInBasis[gSchw, matrix];
ComponentValue[phiSchw[], u[rSchw[]]];
RicciScalar[CDSchw][] // ToComponents
scalarEqSchw // ToComponents
ShowBackground["Schwarzschild"]
```

The example assumes the source objects, scalarEq registration, matrix and scalar function u already exist. For independent affine connections, use their owned derivative heads directly, e.g. AffineAff[-aAff][phiAff[]], Riemann[AffineAff], Christoffel[AffineAff,CDAff]. Use ConnectionMatrixOf only for the managed coefficient array / chart transformation. For dynamic selection by registry key, use BackgroundObject.

Public distribution should not include this internal audit.

# Phase 2 validation and scientific checkpoint — 2026-11-28

Active roadmap: [ACTIVE_BETA_PLAN.md](ACTIVE_BETA_PLAN.md). All source changes are on develop; no public publication or main merge. Version remains 1.0.0-beta.1.

## Implemented corrections

- [5c32aa0](https://github.com/physedu/xPlorer/commit/5c32aa077fb19469495560afb3bfd06933103a50): reject unresolved xTensor heads in managed metric matrices, except primary coordinate scalars. The user can supply a shared scalar function of coordinates or an explicitly evaluated component snapshot. No automatic dependency graph. This is a safe boundary for the demonstrated native xCoba differentiation behavior, not a change to native tensor algebra.
- [11cd038](https://github.com/physedu/xPlorer/commit/11cd03874c212bd0561d5823320338ab889cd424) and [fbd60b5](https://github.com/physedu/xPlorer/commit/fbd60b5ba70cffbc7e1f97ac08d9ccfd99d09b2e): geometry simplification binds $Assumptions to the requested explicit domain or the background default; ambient assumptions cannot specialize cached results. ToComponents passes its explicit domain through to geometry, native primary reads share the active domain, and primary connection replay retains the requested policy. Native calls may choose their own simplification function; the domain is shared. No general tracking of arbitrary user function definitions.
- [7a753f3](https://github.com/physedu/xPlorer/commit/7a753f3872bf3ea445c660d37bebbf030785a43a): a separate explicit native MetricInBasis[...,Inverse->True,CVSimplify->Simplify] path still cached an inverse equal to 1 instead of 1/9 at k=-2,t=1 and yielded curvature 24. Scope native metric input and inverse installation to declared/active assumptions; reject unresolved tensor input before staging. On geometry policy changes preserve authoritative field sources and selectively invalidate derived groups.
- [07090af](https://github.com/physedu/xPlorer/commit/07090afaf21af4244892eaf240ca0d6ae10c7ada): complete regression group [Tests/38_MetricInputsAndAssumptions.wl](../Tests/38_MetricInputsAndAssumptions.wl) registered as MetricInputsAndAssumptions.

The demonstrated ambient-sign cache result is now 8/3 for k=-2,t=1, with identical explicit policy reuse. Explicit positive and negative domains produce correct results on their respective branches; resetting to Automatic restores the background domain. Explicit coordinate scale factor t^3 produces 90/t^2. The rejected managed, native primary-array, ordinary and held metric edits preserve the previous model. Ordinary coordinate-dependent scalar functions remain supported.

## Fresh regression evidence

Exact tested revision 07090af; source blob 90cef340400e8fbcac7fb5b6a3d3514f97db8daa. Wolfram Language 15.0.1 Linux, xAct 1.3.0, xCoba 0.8.6, portable permutation backend in the harness only.

| Group | Passed |
| --- | ---: |
| MetricInputsAndAssumptions | 21/21 |
| NativeGeometry | 12/12 |
| MetricEdits | 13/13 |
| ConnectionMetricPreflight | 10/10 |
| FieldCache | 23/23 |
| SelectiveInvalidation | 13/13 |
| NativeSetState | 21/21 |
| ForeignInputIsolation | 39/39 |
| Consolidation | 30/30 |
| Total focused executions | 182/182 |

Both actual public scientific notebooks rerun on 07090af, with native printing enabled: Research Workflow 153/153 selected input cells and 37/37 checks; API Examples 419/419 selected input cells, 109/109 checks and 33/33 stages. No recorded warnings, parse errors or unexpected failures. The same notebooks passed on the preceding intermediate revision, but intermediate counts are not added to final counts. The earlier intermediate GeometryRead group passed 13/13 before the final native-inverse fix; not counted in 182.

## Phase 3 scientific evidence

- Existing [Proca example](../Examples/Beta13_Proca.wl) at 07090af: field assignment OK, expected four-component residual {0,0,0,0}, sector keys FieldStrength and VectorEOM. The profile is a test ansatz, not claimed to solve the equations.
- Optional [EinsteinScalarVarL.wl](../Examples/EinsteinScalarVarL.wl) at [926a315](https://github.com/physedu/xPlorer/commit/926a3153e4f1779036a4217e5f49919a57056aca), same package blob: 6/6 checks. Native xTras VarL derives the Einstein-Hilbert equation, VarD derives scalar equation, copied expressions evaluate on Minkowski and spatially flat FLRW with a(t)=t, and analytic and native Einstein components agree. The initial standalone comparison of independent Einstein and Ricci heads without an identity expansion was structurally false; the persisted test compares the actual Ricci expression and the native Einstein components.
- The ordinary notebooks also cover metric perturbations, vector and tensor components, chart maps and a supported metric-affine example. No general solver or xTras implementation added.

## Limits and remaining work

This evidence closes the active Phase 2 tasks in the tested managed scope. It does not certify arbitrary native cache mutations, arbitrary custom simplifiers, secondary native edits, generalized rollback, or every xAct package/version. The native Rule/Set mutation boundary remains unchanged. The optional Rule/Set performance investigation, broader historical groups as practical, final matching paclet, Desktop visual review and publication remain separate tasks. Keep main unchanged pending maintainer acceptance. The earlier actual public paclet matches the earlier source, not this corrected candidate.

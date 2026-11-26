# Public API audit — beta.13-dev.4 (2026-11-26)

Static audit of all 96 usage-declared public symbols in dev.3 (including options and variables), source definitions, current principal notebook, ScalarTheory.wl, Proca example, Fixture and test groups 01–14. Static references are not proof of runtime coverage or absence of external users.

## No explicit references in the inspected notebook, examples or regression sources

| Symbol | Role / decision |
| --- | --- |
| ClearBackgrounds | Bulk cleanup; keep, add test. |
| ChristoffelOf | Convenience accessor, including named connection; keep, add test. |
| CMetricOf | Historical component metric accessor; returns the native metric after component assignment. Review redundancy. |
| ComponentCovDOf | Historical component derivative accessor; returns the native derivative after component assignment. Review redundancy. |
| ToBasisOf | Advanced basis conversion; used internally by ToValuesOf. Keep and test. |
| ToValuesOf | Advanced basis/value conversion; keep and test. |
| TorsionOf | Native torsion head accessor; keep and test. |
| ReplaceRules | Used internally by ClearRules; test direct replacement and ordering. |
| ComputeOnSet | Option, not function; default is exercised during metric assignment, explicit override lacks coverage in scanned sources. |

These are absence of explicit references, not claims of no indirect execution. No public function was removed. ExprMatrixOf has a legacy regression reference but no current notebook use; duplicates ToComponents. PrettyExp is used in the notebook; unlike DisplayExpression it reverses mathematical heads and indices, so it should not be described as a safe interpreted view. Review these before removing. BackgroundObject, ShowTheoryKeys, qualified lookups and suffixed aliases remain supported.

## Applied in dev.4

- Remove private NameKey, MergeTheoryValue, InferFieldKey, FieldPrintAsFromOpts and validBaseOption, with no remaining callers.
- Remove unused legacy message definitions (old Expr registry and fixed 4D assumptions); current functions return structured Failure.
- BackgroundExpression rejects invalid qualified collections; TheoryValue[section,key] now shares the same collection view as TheoryValue[section], including Geometry.
- ExpressionText supports a qualified list key or explicit four-argument form, retaining unqualified forms.
- AboutXPlorer[] and native once-per-kernel startup banner: dynamic version, author, license, dependencies and project link.
- Tests/14_TheoryInspection.wl adds checks for these changes.

Package commit d28f7412a2f8f2467d0338a57fe294121b0b5785; tests efda587cebb708969936dbbd0cdf773893824038. Runtime validation pending: Wolfram MCP failed even for 1+1; last verified code is dev.3. Rerun notebook, registration, lifecycle, display and inspection suites and verify startup count. Do not release or merge to main.

Next: update historical API guide; add explicit coverage for retained unreferenced functions; consider clearer background inspection without exposing mutable registry; review CMetricOf/ComponentCovDOf, ExprMatrixOf and PrettyExp with the author. Do not remove public functions solely based on static reference counts.

## Resolution in dev.5/dev.6 (2026-11-26)

All three redundant accessors removed; DisplayExpression merged into safe PrettyExp, with old reverse mapping removed. Missing chart guard and tests for retained functions. Native xCoba interop tested without new basis API. Profiles and optional CTensor added in dev.6, tested with historical suite and canonical notebook. See BETA13_PLAN.md and BETA13_PROGRESS.md for exact commits and remaining limitations. Historical reference counts above are not current dev.6 counts.

## dev.16 static reference refresh (2026-11-26)

At f621caa1d71136428aa158221a70825d9bffd340, scanned all 98 usage-declared public symbols (including options and variables) against 30 text sources: principal notebook, ScalarTheory, three Examples and 25 test/runner sources. Counts are lexical references, not executed coverage. Three helpers have no explicit reference in those sources: RicciOf, EinsteinOf, WeylOf. They return native geometry heads, with named connection overloads; retain them for convenient inspection and add explicit tests instead of removing them solely for low reference counts.

Not explicitly referenced in the principal notebook: RicciOf, RicciScalarOf, EinsteinOf, WeylOf, ChristoffelOf, ChartOf, BasisOf, CheckBackground, ToBasisOf, ToValuesOf, PerturbationOrderLabel, Checks, ComputeOnSet, ForceCompute, AboutXPlorer, $XPlorerVersion, Presentation, PresentationOf, TorsionOf, ReplaceRules. Several are options or deliberate programmatic/technical interfaces. Existing tests cover many of these; absence in the tutorial does not imply lack of utility.

Focused private review covered recipe remapping, chart records, field record replay, field extension and cache invalidation. Two reproduced reconstruction defects fixed in dev.16. Review candidates not yet established as runtime failures: ComputeGeometry forced/policy-change replay branch does not propagate every replay failure; AddField guarded native creation does not implement full rollback on partial native failure. Do not claim transactional guarantees or remove public symbols. Further private audit and error injection remain pending.

## dev.17 — native-first audit

The package's native field assignment path already calls ComponentValue for rank zero and AllComponentValues for positive rank; ChangeComponents handles variance. The official xCoba 1.3.0 source uses ComponentValue internally in array assignment, metric installation and component derivation. Thus global interception of these functions would conflate inputs and derived values. New owned-object UpValues add disjoint shorthand and explicit Managed -> True for overlapping scalar/deletion operations. No global downvalues modified. Ricci/Riemann/Einstein/Weyl and other geometry getters are native xTensor operations; ToBasisOf/ToValuesOf and ConnectionDifference are candidates for removal after migration. Keep PortExpression, ToComponents, CreateBackground, reconstruction and lifecycle, and background-local xPert handling. DefChart, DefBasis, SetBasisChange, CTensor, ChangeComponents, ToValues, VarD and VarL remain native. No automatic capture of external chart/basis or individual component operations; these need a separate contract.

## dev.18 — scope of native read/write integration

The owned-head extensions now cover ordinary scalar ComponentValue, complete literal primary-chart arrays (including the existing abstract-index shorthand), edits of components in a complete registered source configuration, full DeleteTensorValues, literal primary-chart MetricInBasis and an internal calculation guard for ChangeComponents. A conditional ToValues list-dispatch extension prepares requested primary-chart variances of recorded fields in atoms, sums and arrays, delegating evaluation to the original native rules. Rule-group fingerprints detect changes, and independent field assignment no longer replays all other registered fields. No eager precompute or new public functions. Native explicit MetricCompute, native basis/chart lifecycle and new sparse or partial tensor inputs remain unresolved; old managed setters must not be removed yet.

Further native-entry-point audit: ComponentValue and AllComponentValues query forms, HeldComponentValue, TensorValues (raw rule introspection; should not silently compute), ToCTensor, WithSetValues, RuleToSet/SetToRule, DefChart/UndefChart, DefBasis/UndefBasis, SetBasisChange, MetricCompute native target specifications, native geometry reads, CTensor/SetCMetric, and ClearxCobaCache. Extend only when ownership or freshness requires it; do not redefine pure algebraic operations merely to expand coverage.

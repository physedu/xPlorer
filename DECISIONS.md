# Design decisions

## Next version: beta.13 registration redesign (agreed direction, 2026-11-25)

Status: design only, not implemented or tested. The author-supplied beta.12 package and didactic notebook are preserved on main (merge commit 05b0b407b9bf4067e152594cecb5ba3eaf706d22). See CHANGELOG.md for the intervening betas. The previous beta.7 recovery record remains historical. The decisions in this section supersede earlier registration-interface choices where they conflict.

### 1. Native tensor metadata

Define mathematical objects with xAct first, then register their symbols with xPlorer. Proposed public syntax:

```wl
DefTensor[phi[], M];
DefTensor[A[-a], M];
DefTensor[F[-a,-b], M, Antisymmetric[{-a,-b}]];

RegisterTheory["Field", phi];
RegisterTheory["Fields", {A, F}];
```

Infer rank, slots, index bundles, native symmetry, supported dependencies and effective PrintAs from xAct instead of requiring the user to repeat Scalar, Vector, Tensor, rank or symmetry. Keep those distinctions available internally and in inspection output. Reuse the existing beta.12 metadata-copy machinery wherever possible. Remove the old positional registration forms rather than preserving a parallel legacy interface. Do not confuse discovering metadata with reproducing unsupported structures: reject unsupported properties explicitly.

### 2. Field names and presentation

```wl
RegisterTheory["Field", phi];
RegisterTheory["Field", phi, Name -> "matter"];
RegisterTheory["Field", phi, Name -> "matter",
  SymbolBase -> "phi", PrintAs -> "\[Phi]"];
```

These are alternatives, not sequential registrations of the same field. Name defaults to the original symbol name and is the registry key. SymbolBase defaults to Name and is only needed when the generated symbol base should differ from the key. PrintAs is independent of both and inherits the source presentation by default. For SymbolSuffix -> "Schw", the three alternatives generate phiSchw, matterSchw and phiSchw, respectively. Keep beta.12 automatic aliases, collision protection, genuine xAct tensor heads and isolated background contexts.

### 3. Named collections and bulk registration

Organize the theory conceptually into Geometry, Fields, Parameters, Lagrangians, Expressions and Rules. Existing geometry calls need not change solely for this organization. Distinguish registered tensor heads from derived expressions; a field may be an independent variable or an auxiliary tensor. A Lagrangian is a named expression with a distinct purpose.

```wl
RegisterTheory["Lagrangians", "Gravity" -> Lgrav];
RegisterTheory["Lagrangians", {
  "Matter" -> Lmatter,
  "Vector" -> Lvector,
  "Total" -> Ltotal
}];
RegisterTheory["Expressions", {
  "MetricEOM" -> Eab,
  "ScalarEOM" -> Ephi,
  "StressEnergy" -> Tab
}];
RegisterTheory["Parameters", {m, kappa}];
```

Support individual and multiple registration, including per-item options. Proposed retrieval: TheoryValue["Lagrangians"] and TheoryValue["Lagrangians", "Gravity"]. Define the total Lagrangian explicitly; do not automatically sum all stored terms, because they may represent alternatives or overlapping contributions. Finalize the parameter option grammar during implementation without changing the agreed naming principles.

### 4. Original symbol names for Lagrangians and Expressions (explicit author decision)

The registration key is independent of the name used in a background. If the supplied right-hand side is a named source symbol, use that original symbol as the alias base, not the collection key.

```wl
Lgrav = RicciScalarCD[]/(2 kappa);
RegisterTheory["Lagrangians", "Gravity" -> Lgrav];
CreateBackground["Schwarzschild", SymbolSuffix -> "Schw"];
LgravSchw
```

The resulting alias must be LgravSchw, NOT GravitySchw. The key is still "Gravity". Analogously, "MetricEOM" -> Eab generates EabSchw.

If the supplied right-hand side is a direct expression instead of a named source symbol, require an explicit Head option; never silently invent an alias base from the key.

```wl
RegisterTheory["Lagrangians",
  "Gravity" -> RicciScalarCD[]/(2 kappa), Head -> "Lgrav"];
RegisterTheory["Expressions",
  "RicciSquared" -> RicciCD[a,b] RicciCD[-a,-b], Head -> "R2"];
```

Both examples are alternatives to named-symbol registration. Head names the desired generated alias base; it does not mean the structural Mathematica Head of an expression (which every expression has). Reject anonymous input without Head with a useful diagnostic. Preserve the syntactic source symbol before evaluating its OwnValue; an assigned Lgrav must not be mistaken for anonymous input. Use held parsing (the current RegisterTheory is HoldAll) and test named, direct and nested bulk input. Resolve and store the expression value separately from the original name.

Proposed mixed bulk syntax:

```wl
RegisterTheory["Lagrangians", {
  "Gravity" -> Lgrav,
  "Matter" -> Lmatter,
  "Vector" -> Lvector,
  {"Total" -> Lgrav + Lmatter + Lvector, Head -> "Ltotal"}
}];
```

With suffix Schw this generates LgravSchw, LmatterSchw, LvectorSchw and LtotalSchw. Preserve the existing beta.12 distinction between transported aliases and rule-applied retrieval; document how the new Lagrangian aliases are used in later xAct variations. Keep snapshot isolation and protect occupied names across all categories.

### 5. Physical sectors

Sector is optional cross-cutting metadata, not a replacement for collections, and never automatically imposes equations, assumptions, or rules.

```wl
RegisterTheory["Fields", {
  {A, Sector -> "EM"},
  {F, Sector -> "EM"},
  {phi, Sector -> "Matter"}
}];
RegisterTheory["Lagrangians", {
  {"Maxwell" -> Lem, Sector -> "EM"},
  {"Scalar" -> Lscalar, Sector -> "Matter"}
}];
RegisterTheory["Expressions",
  "MaxwellEOM" -> EA, Sector -> "EM"];
TheorySector["EM"]
```

TheorySector is a proposed query across categories. Multiple-sector membership is a possible extension, not a settled requirement. Do not duplicate mathematical objects merely to classify them.

### 6. Scope and next implementation

Ordinary tensor support is not equivalent to knowing physical spin. Proca and Maxwell can be represented using a vector potential and, optionally, an antisymmetric tensor or a derived field-strength expression. Their physical equations and relations remain explicit. Fierz-Pauli and Kalb-Ramond are further examples of ordinary tensor fields. Preserve the existing xPert metric-perturbation path until automatic detection of its native association has been verified. Additional vector bundles, spinors, tetrads, Clifford algebra, fermionic products and spin connections require separate architecture and validation; do not claim they are supported by generic tensor inference.

Implementation acceptance criteria (proposed engineering checks):
- Fresh-kernel Get and the revised didactic notebook; no startup helpers or mandatory preference setup.
- Verify inferred scalar, vector, symmetric, antisymmetric, mixed-index and higher-rank tensor metadata and transport; reject unsupported bundles/metadata without partial mutation.
- Verify explicit Name/SymbolBase/PrintAs and default native names.
- Verify named RHS retention even after assignment, required Head for direct expressions, mixed bulk registration, collection lookup and sector queries.
- Verify suffix generation, alias collision protection, snapshots, deletion/recreation and rule-applied versus transported retrieval. Preserve beta.12 behavior outside the intentional breaking registration change.
- Update package usages, examples, tests, API guide, and notebook to the new API; no parallel positional legacy interface. Keep English ASCII source, simple Get, and mathematical presentation as agreed.
- Record actual test environment, exact results and limitations before announcing beta.13. No code, test or release changes are implied by this design document.


## Required behavior

- Optional personalization. Existing straightforward calls remain useful without preference setup.
- Presentation precedence: explicit call > background override > theory override > general preference > effective inherited native presentation. This precedence applies only where the API supports the relevant level.
- Mathematical properties have their own validated definition/copy rules. A style preference never changes torsion, signature, symmetry or dependencies.
- No global SetOptions or permanent native xAct naming overrides. Prefer scoped definitions on owned symbols; test cleanup.
- Separate actual symbol, registry key and displayed form. A field phi may use key "phi" and display m. An explicit key "Scalar1" is optional and unrelated to changing the display to M1.
- Contexts isolate objects; normal output should be legible while full identity remains inspectable. Short names must handle duplicate tags, recreation and collisions without relying on labels alone.
- A background is an independent managed collection, not a global mode. Existing background snapshots do not silently change when a theory item is later registered.
- Preserve native tensor objects and user mathematical expressions. Presentation views are not computational replacements. PrettyExp-style comparison views must explain any mapping back to source objects.
- Clear rules, clear field data, invalidate caches, unregister and undefine are different operations with explicit names and effects.
- Ownership is explicit. Imported/source xAct objects are external by default. Never assume registration grants permission to destroy them.
- Default deletion protects dependents; optional bounded cascade and preview do not imply a confirmation prompt for every operation.
- ReconstructionData/RecreateBackground rebuild managed inputs while source definitions remain alive; arbitrary user variables are not globally repaired and kernel undo is not promised.
- Retain a primary connection to preserve simple calls; general connection calculations require adequate independent data and valid identities.
- English ASCII deliverables and theme-inherited notebook styles. Chat may remain Spanish.

## Historical baseline: 14.0.0-beta.2

These observations describe the preserved baseline, not the current beta.

The local 14.0.0-beta.2 source uses private numbered background contexts, supports one metric/Levi-Civita pair per background, and defaults field presentation to the source SymbolName rather than its effective native PrintAs. Full inheritance and multiple-connection integration remain planned. Existing DeleteBackground follows native dependencies and protects external visitors. ClearTheory removes the registry, not all source xAct definitions. Selective public rule removal is planned.

RegisterTheory is HoldAll: an Association stored in a variable may need lexical insertion (for example With) rather than a bare variable argument. Preserve and test supported forms instead of assuming evaluation behavior.

Prior naming-hook and PrintAs experiments are feasibility evidence only. They do not prove full integration of binary connection naming, components, ownership or every native option.

## Decisions resolved during implementation

- Public APIs are described in API_GUIDE.md; DeleteBackgroundObject avoids the protected System DeleteObject name.
- Background contexts retain unique counters; sanitized readable names and field ordinals avoid collisions. Scoped interpreted boxes display bare heads without removing full InputForm identity.
- One tangent bundle is supported. Standard conjugation and native symmetry are copied; density/graded/projected and extended-connection scopes are rejected. Native label-resolution and relative-connection helpers are isolated xAct 1.3.0 dependencies.
- Native family/visitor relationships plus registered expressions/rules guide deletion. Saved results use conservative background-wide invalidation; arbitrary variables remain unmanaged. Actual postconditions are checked and incomplete cleanup is reported.
- A single root source supports Get, a traditional Kernel/init.m loader and a kernel paclet extension. Development directory loading is verified; no binary paclet release is claimed.

Choose routine reversible details autonomously; record rationale and compatibility impact. Ask only for material unresolved scope choices. Do not describe illustrative future syntax as an implemented API.

## dev.16 - reconstruction, native ownership and primary-chart promotion

Retain RecipeVersion 1 and extend recipes with the original DisplayIndices input plus secondary-chart and coordinate head identities. Older version-1 recipes still load with default display indices and only remap identities they actually store. A managed recipe is not a kernel snapshot. In particular it cannot restore undocumented native definitions, external bases, arbitrary notebook variables or cached results.

Managed records are authoritative during replay. Native ComponentValue/AllComponentValues assignments can be used in calculations, but may be overwritten when values are cleared, a profile is activated or metric data are changed. Verified scalar capture: read a resolved primary-chart value with ToValues and explicitly assign it through SetFieldComponents before recording ReconstructionData. For tensors use native xCoba extraction with the desired variance and basis, then record the resolved primary-chart array. Do not silently import every native value; derived values and explicitly supplied inputs are not interchangeable. No new public capture API is introduced.

Do not implement primary-chart promotion by simply changing the Chart/Basis registry fields. DefineChart currently records a one-way map from secondary coordinates to primary coordinates; xPlorer's OutputChart performs a tensor pullback, not general native chart synchronization. Native secondary-chart MetricInBasis and MetricCompute were verified for a cylindrical metric and its nonzero Christoffel coefficient while leaving the managed Cartesian metric unchanged. A future primary promotion must:
- Verify a local inverse and nondegenerate Jacobian under explicit domain assumptions; do not assume a global inverse or choose a branch.
- Transform the metric, field/profile inputs with variance and LI order, and any connection inputs. An independent connection's coefficients have an inhomogeneous transformation, unlike a difference of connections.
- Rebase all other chart maps and coordinate-dependent assumptions/rules, preserve owned identities and guard external native dependents.
- Invalidate derived caches/results and use native xCoba to rebuild geometry; preflight unsupported data before mutation and report incomplete restoration explicitly.
- Compare nontrivial curved and nonlinear chart cases and round trips before exposing a public operation.

This is a proposed design contract, not implemented or generally validated. No new public API in dev.16.

## dev.17 — extend native operations locally, not globally

Use UpValues on copied metric and field heads for disjoint managed shorthand signatures. Do not unprotect or alter global ComponentValue, AllComponentValues, MetricInBasis, MetricCompute or DeleteTensorValues. The two-argument scalar setter is also called by xCoba internals, so require Managed -> True to identify deliberate inputs; the same marker distinguishes full managed deletion from cache clearing. Positive-rank abstract-index array assignment and metric-without-basis calls infer the primary chart. Keep explicit native signatures unchanged. Existing setters remain as tested implementation paths until user-facing migration is complete. Managed partial components, native explicit-basis capture, native chart registration and general basis changes require separate design; do not register computed values automatically. Geometry getters already supplied by xTensor need no replacement. xTras remains optional.

## dev.18 — integrate native reads and writes, calculate on demand

Supersedes dev.17's explicit Managed marker for ordinary scalar writes and full field deletion in managed charts. Retain the marker temporarily as compatibility syntax, not a tutorial requirement. Complete literal arrays with explicit primary basis and single components of a complete recorded source configuration are integrated. Complete literal primary-chart MetricInBasis assignments with native signed basis are managed, with covariant authoritative input. Record actual native values rather than the requested value when native CVReplace can preserve an old value. Preserve native return conventions within tested signatures. Use a dynamic calculation guard around native ChangeComponents, managed storage and replay. A single conditional ToValues list-dispatch rule is needed because sums and lists do not dispatch on tensor UpValues; preserve the original native rules and bypass when not relevant. Use native rule-group fingerprints to detect source/target/metric edits and deletion before reusing a requested full variance, not a duplicate tensor cache. Only replay affected heads on field assignment; a metric change remains conservative. Do not eagerly calculate all variances or impose a rank cutoff. General high-rank single-component efficiency, incomplete component inputs, other charts/bases and full native metric synchronization remain open. No new required dependency.

Defer an explicit temporary native-experiment mode until all relevant entry points have been audited. Prefer one scoped operation rather than per-function flags; warn on bypass, specify the background, and restore only managed inputs/caches, not arbitrary external definitions or kernel state. No bypass API implemented in this checkpoint.

## dev.19 — native MetricCompute and missing native geometry rules

Keep xCoba's native pointer cache and TensorValues distinct. xCoba 1.3.0 returns early from ReportCompute on a pointer-cache hit and does not re-store deleted TensorValues. Detect missing symbolic rule groups via native CacheKeySymbolic and signedbases, then clear the exact ReportCompute key only. Never recalculate unrelated geometry just because a native output group was deleted. Native explicit-chart zero-torsion MetricCompute participates in the managed coverage record; retain native arguments and returns. This adapter is version-specific and does not yet detect arbitrary in-group edits or fully synchronize simplification policies. No bypass mode or public API added.

## dev.20 — native reads use on-demand geometry

Share preparation between ToValues and one-argument ComponentValue/AllComponentValues. Recognize geometry by native head and exact primary-chart standard variance, including the native chart determinant whose symbol context differs from the background context. Batch requests by background and delegate missing configurations and dependencies to native MetricCompute. Rule-group completeness must distinguish actual results from placeholders: check xCore FoldedRule, total coordinate-tuple count and independent identity rules. Preserve raw TensorValues introspection and all native read return formats. Alternative geometry variances, secondary charts, arbitrary direct rule edits and set-state semantics remain deferred. No new public command.

## dev.21 — preserve native source groups during metric changes

Store only source-rule fingerprints in runtime metadata; use actual native rules to verify exact repeat managed field inputs and skip unnecessary replay. Metric changes retain matching authoritative native ValIDs and remove other groups without eager recomputation. xCoba includes LI labels in the ValID basis structure, so different perturbation orders are distinct even with different authoritative variances. Include LI in both source and derived fingerprints. Fall back to the existing managed replay of a head if one of its declared source groups is missing or changed. Non-source derivative/basis values are conservatively invalidated, not classified by detailed metric dependency. Do not claim identical metric no-op or independent connection preservation until tested separately.

## dev.22 — stage native metric-component edits and skip exact repeats

Use a localized native metric symbol to stage individual primary-chart covariant or contravariant component writes. Capture the actual native matrix, validate it through the managed metric setter, and return the native rule on success. A rejected candidate must leave original native metric rules and cached geometry intact. Do not promise rollback of arbitrary external side effects. Exact repeat managed metric inputs with matching assumptions and native lower/upper rule fingerprints preserve geometry and revisions; refresh fingerprints only on known managed installation or native computation from a known source. Preserve existing CVReplace behavior. A vanishing native tensor evaluates to zero before a tagged pattern can be installed; skip unnecessary component hooks on such tensors. No public API addition.

## dev.23 — lazy geometry variance and imploded derivative cleanup

Use the existing native variance transformation and fingerprint path for nonstandard geometry variances, choosing a valid cached conversion or a nearby available standard source. Native standard MetricCompute outputs remain authoritative. Native imploded derivative tensor heads have separate ValIDs and previously survived clearGeometry with stale rules. Discover native associated heads from ReportCompute entries and known chart derivative specifications, delete their values but retain definitions, and support lazy reads of already defined primary-chart derivative heads. No new public command and no claim of general derivative/basis synchronization.

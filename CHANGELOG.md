# Development history

## 14.0.0-beta.13-dev.16 - 26 November 2026

- Preserve custom abstract index choices and remap secondary-chart identities in reconstruction recipes.
- Expose standalone beta.13 regression groups, persist incremental field and native secondary-chart feasibility checks, and harden paclet builder failure handling.
- Verify managed/native scalar replay boundary with an explicit capture path using existing setters.
- Synchronize package and distribution metadata. Full commit-specific evidence in BETA13_PROGRESS.md and Tests/dev16-results.json.
- No new public API, primary-chart promotion, Desktop verification, binary archive installation or beta.13 release.

## Historical development through beta.12

Retrospective from the exported development conversation, 6–25 November 2026. Test counts below are historical reports, not newly rerun tests. No independent source snapshots or tags are fabricated for intermediate versions.

## 14.0.0-beta.12 — 25 November

- CreateBackground exposes free suffixed object, index and expression names in the calling context, e.g. CDSchw[-aSchw][phiSchw[]]. Occupied names are preserved; BackgroundObject still provides explicit lookup and custom aliases. Recreating backgrounds relinks their owned aliases.
- Removed redundant manual alias assignments in the didactic notebook.
- Reported: 115 input cells without warnings, 250 package tests.

## 14.0.0-beta.11 — 24–25 November

- Fixed boxes$... output formatting bug (27 occurrences on 10 PDF pages).
- Made naming/presentation examples executable; retained Program cells for three alternative recipes.
- Reported: 112 cells and 58 checks after printer fix; later notebook revision ran 116 cells without warnings.

## 14.0.0-beta.10 — 24 November

- Automatic short dummy-index display, avoiding collisions with free indices and preserving the original expression on copy.
- Improved scalar, Lagrangian and prefix/postfix derivative presentation.
- One instruction per line within input cells; reduced redundant tutorial prose.
- Reported: 112 cells, 57 checks, kernel-level copy round-trip check.

## 14.0.0-beta.9 — 24 November

- SymbolSuffix independent of background tag; SymbolBase for field heads; direct PrintAs at background creation.
- Registered expression aliases (EabSchw) expose transported expressions; UseExpression additionally applies specialization rules.
- Session/local derivative notation, reversible display and copy/code/LaTeX views.
- Multiple charts per background, OutputChart selection, cylindrical scalar/Hessian example.
- Extended rule inspection and independent connection examples.
- Reported: 104 cells, 52 checks, ten regression groups separately on Wolfram Language 15.0.1 and xAct 1.3.0. Combined evaluator failed internally; later tutorial revision ran 112 cells, 55 checks. Desktop appearance incompletely verified.

## 14.0.0-beta.8 — development snapshot

- Readable metric and derivative heads, inherited/local PrintAs, isolated contexts. Fields still carried numeric ordinals and indices internal names; SymbolSuffix and automatic coordinate-derivative display were pending.
- No independent validation total established.

## Earlier history

Beta.7 reported 196 package checks, 88 notebook inputs and 45 result checks. The earlier changelog follows. The conversation does not unambiguously identify separate beta.3–beta.6 snapshots.

---

# Changes in 14.0.0-beta.7

- Automatic native source label inheritance, local presentation overrides, readable isolated heads and interpreted bare-head output.
- Optional expression views for partial/covariant derivatives; native notation remains the default.
- Explicit value clearing, unregistering, dependency previews and true owned-object/family deletion, including partial metric and chart lifecycles.
- Named independent connections with native curvature families, supported source properties and coefficient/difference input.
- Selective and grouped rules; conservative managed-result invalidation.
- Corrected StrictComponents treatment of coordinate scalars and two old HoldAll test-restoration calls; verified partial-creation cleanup.
- Expanded single didactic notebook, editable build sources, traditional loader and development paclet metadata.
- See API_GUIDE.md for supported scope and VALIDATION.md for actual checks. This is a beta, not unrestricted xAct compatibility.

# xPlorer v14 changes

## Theme compatibility revision - November 23, 2026

- Remove explicit text, background, and border colors, including the forced white notebook background.
- Inherit colors from Mathematica's default styles and user theme.
- Distinguish explanations, executable input, important notes, tips, and reference syntax using typography, spacing, and borders.
- Verify that all 66 inputs and three formulas are unchanged and that the notebook contains no explicit color settings.

## Worked tutorial revision - November 23, 2026

- Restore the original scalar-theory, Minkowski, Schwarzschild, and FLRW narrative and insert explanations beside the operations being learned.
- Organize the tutorial into eight sections with short executable cells and separate non-evaluatable syntax alternatives.
- Explain registration forms, background snapshots, actual tensor access/display, indices, scoped rules, components, changes, perturbations, and deletion through worked cases.
- Embed a restrained stylesheet for headings, code, reference syntax, important notes, and tips; add three typeset reference equations.
- Execute the complete 66-input notebook in one fresh kernel: 36 expected-result checks and three order checks pass with no warning messages.
- Keep package source unchanged and the test machinery outside the visible walkthrough.

## Practical guide revision - November 23, 2026

- Expand xPlorer_Workflow.nb into 18 collapsible chapters with 59 input cells.
- Identify Mathematica, xTensor, xCoba, xPert, and xPlorer responsibilities beside each example.
- Add a coordinate-free tensor gallery, direct background aliases, index membership, contractions, symmetries, and local rules.
- Show explicit partial derivatives alongside native derivative multi-indices.
- Demonstrate selected tensor/stress-energy components, cache reuse, metric changes, perturbations, snapshots, protected deletion, and fresh recreation.
- Validate 48 independent expectations in four groups; retain a single Get cell and English/ASCII-only file contents.
- Keep the v14 beta.2 package implementation unchanged.

## 14.0.0-beta.2

- Rebuild the main notebook as xPlorer_Workflow.nb: abstract theory, Lagrangian and assumptions, variational equation, saved registration, independent manifolds, charts, metrics, and calculations.
- Use physical spacetime labels Minkowski, Schwarzschild, and FLRW instead of Demo names.
- Include ScalarTheory.wl as a reusable definition of the abstract theory, with no concrete geometry or chart.
- Add 13 physical workflow checks and three checks of the order in which geometry is introduced.
- Isolate the optional regression runner from existing Global symbols and restore the caller's context path afterwards.
- Correct restoration of the saved theory association in the optional test runner.
- Fix cold-kernel startup by declaring the xAct dependencies in BeginPackage.
- Load the notebook package with a single ordinary Get call.
- Remove file-discovery helpers, startup flags, version gates, symbol cleanup, and notebook backend overrides.
- Make the example theory explicitly optional; loading the package is sufficient to continue with an existing theory.
- Use direct xAct definitions in the examples, with no custom context or automatic deletion at startup.
- Move the full regression suite to an optional final section.
- Generate notebook input using native Wolfram boxes serialized with ASCII escape sequences.
- Translate the notebook and all documentation into English and keep every delivered text file ASCII-only.

## 14.0.0-beta.1

Added ToComponents, SetFieldComponents, ComputeGeometry, CheckBackground, and PerturbOn. Integrated the earlier notebook helpers while preserving the v13 interface.

Corrected string registration keys, bulk symmetry declarations, generated dummy-index transfer, and index variance. Added background contexts, theory snapshots, and dimension inference.

Added geometry-on-demand, scoped cache invalidation, retained field assignments after metric changes, component selection before contraction, and term-wise contraction evaluation.

Added dependency-ordered deletion, recreation of tags, protection of external dependents, and rollback of failed creation. Linked metric perturbations to xPert and distinguished variations from Taylor coefficients.

Added a portable notebook, 75 regression checks, an MUnit report runner, and an execution record.

## 14.0.0-beta.13-dev.17 (development)

- Owned metric shorthand with native MetricInBasis and MetricCompute; owned full-field array shorthand with AllComponentValues. Scalar ComponentValue and full DeleteTensorValues support explicit Managed -> True. No global xCoba definitions changed.
- Retain current managed setters and native explicit-basis behavior. Update scientific guide examples without adding test cells. No package installer changes.

## 14.0.0-beta.13-dev.18 (development)

- Capture ordinary native scalar inputs, complete literal arrays in the managed primary chart, and individual edits of complete recorded source configurations. Full native field deletion clears the managed record. No Managed marker required in these cases.
- Prepare requested native field variances on demand, cache rule fingerprints rather than arrays, and extend ToValues for compound native reads. Guard derived writes through ChangeComponents. Replay affected field heads instead of every registered field on assignment.
- Integrate literal covariant and contravariant primary-chart MetricInBasis assignments. Propagate failures during forced geometry restoration. Existing setters retained; no packaging changes, no release.

## 14.0.0-beta.13-dev.19 (development)

- Integrate explicit-chart native MetricCompute for the managed primary chart and zero torsion. Recognize native geometry coverage and selectively repair missing TensorValues groups without clearing unrelated xCoba cache entries.

## 14.0.0-beta.13-dev.20 (development)

- Prepare requested standard primary-chart geometry in native ToValues, ComponentValue and AllComponentValues. Share the lazy native field read path; recognize incomplete/identity-only geometry rule groups. Keep TensorValues introspection and abstract reads unchanged.

## 14.0.0-beta.13-dev.21 (development)

- Preserve unchanged native authoritative field groups on metric changes; invalidate derived ValIDs without reinstalling original fields. Exact repeated managed field assignment is a no-op if source rules still match. Include LI labels in source and derived fingerprints and verify deleted perturbation variances are rebuilt.

## 14.0.0-beta.13-dev.22 (development)

- Stage native covariant/contravariant metric-component edits and validate before replacing the managed metric. Preserve geometry and revisions on exact repeated metric assignments with matching native fingerprints. Skip component hooks on identically vanishing tensors.

## 14.0.0-beta.13-dev.25 (development)

- Compute selected primary-chart field components by native metric separation and dummy contraction, for sparse and complete fields including LI orders; retain full native conversion for full requests.
- Cache selected canonical native component fingerprints separately from complete-variance fingerprints; no duplicate tensor arrays or rank thresholds.
- Extend direct primary-chart ToComponents selections and sparse symmetry reads. Correct native call-count instrumentation.
- 688/688 checks in 25 groups, including 24/24 selected-read checks; workflow 365/365, 84/84, 33/33. See Tests/dev25-results.json. General expression and geometry conversion paths remain open.

## 14.0.0-beta.13-dev.24 (development)

- Capture sparse primary-chart native component inputs, including canonical symmetry and LI order, without dense arrays or zero filling.
- Ignore read-created identity and dependent rules in sparse source fingerprints; prepare same-variance sparse symmetry reads using native ComponentValue.
- Preserve sparse inputs through metric changes, reconstruction, clear/replay and profile restoration.
- 26/26 sparse checks; 450/450 across 18 groups; workflow 365/365, 84/84, 33/33. See Tests/dev24-results.json. Cross-variance component requests can still prepare full configurations.

## 14.0.0-beta.13-dev.23 (development)

- Prepare nonstandard primary-chart geometry variances through native ChangeComponents and reuse matching rule fingerprints. Invalidate separate native imploded derivative rule groups on metric changes, retaining tensor definitions and enabling lazy primary-chart queries.

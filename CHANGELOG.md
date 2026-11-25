# Development history through beta.12

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

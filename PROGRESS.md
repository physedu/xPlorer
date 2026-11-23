# Development checkpoint

Date: 2026-11-23
State: Stage 1 validated; Stage 2 is next.

## Repository and recovery

Repository: https://github.com/physedu/xPlorer
Branch: main
Previous preserved commit: bfad1a672b71f3fa76b0ac006e632d33677d8344
Its xPlorer.wl contains a Notebook expression. This checkpoint replaces that path with the actual available 14.0.0-beta.2 package and adds the corresponding xPlorer_Workflow.nb, optional ScalarTheory.wl, tests, validation record and plans. The previous content remains in Git history.

The checkpoint commit containing this document is the recovery point (inspect git log for its SHA). No extension code has been implemented by this planning/publication step.

## Evidence and limitations

- Current source inspected for version, presentation fallback and background lifecycle code.
- Historical validation is recorded in VALIDATION.md and Tests/validation.json: 66 tutorial inputs executed, 36 expected-result and 3 order checks passed; separate package regression baseline comprises 75 distinct checks run in groups.
- These are previous execution records, not a new mathematical test run during publication. The theme-only revision preserved computational boxes and removed explicit colors.
- No new front-end screenshots or full light/dark rendering checks were performed.
- Publication checks: package starts with BeginPackage, notebook contains Notebook, matching standalone package copies, ASCII and checkpoint file integrity. See repository commit for exact contents.

## Next action

1. Read DEVELOPMENT_PLAN.md and DECISIONS.md.
2. Inspect current main and preserve newer user edits; use the actual package published here as the candidate baseline.
3. Stage 1 complete: fresh remote kernels passed core+geometry (48/48) and core+perturbations+lifecycle (67/67), covering all 75 distinct baseline checks. Keep environment-specific backend settings in the test harness only.
4. Implement Stage 2 inheritance and readable naming; validate baseline behavior and targeted cases before proceeding.
5. Continue stages in order, updating this file at each checkpoint.

## Required updates at each checkpoint

Record completed requirements, changed API, checks actually run and outcomes, current limitations, failed attempts that affect future work, next concrete action, and a recoverable commit/tag reference. Push important validated milestones without rewriting history. If publication fails, keep a local commit and report the pending push. Never record credentials or claim unexecuted checks passed.

## Stage 2 completed

Version: 14.0.0-beta.3. Effective source PrintAs is inherited; optional theory/background/later overrides use Presentation and SetPresentation. BackgroundObject returns actual heads. Scoped naming hooks generate readable curvature names and interpreted bare-head boxes retain identity. No global GiveSymbol changes.
New targeted checks: 13/13; existing core checks: 40/40, in a fresh WL 15.0.1 kernel with xAct 1.3.0. PrintAs holds its argument, so inspection of aliases in tests uses With; this was a test-harness correction, not a tensor mutation.
Next: Stage 3 scoped expression views, then lifecycle and multiple connections. Native property coverage and front-end rendering remain limited as specified in the plan.

## Stage 3 completed

DisplayExpression provides interpreted views with Native/MultiIndex/Fraction/Partial/Prime ordinary derivatives and Native/Prefix/Postfix covariant derivatives. SetNotation supplies optional background defaults; per-call choices override them. Normal and box interpretation recover the original expression. Prime falls back to native notation for multiple arguments. No derivative definitions are changed globally.
Checks: 40 core + 13 presentation + 16 notation = 69/69. Native xAct boxes can contain a front-end-dependent font size in a headless kernel, so the checks validate interpreted structure and expression recovery, not pixel rendering. No claim of visual front-end verification.
Next: Stage 4 lifecycle operations.

## Stage 4 completed

Version: 14.0.0-beta.4. Added ClearComputedValues, ClearFieldComponents, UnregisterTheory, DeletionPlan, DeleteBackgroundObject, and ReconstructionData. The name DeleteObject was rejected during development because it is a protected Wolfram built-in; no override is shipped. Removing a primary Levi-Civita connection separately is rejected; delete its metric family instead.
Checks: 40 core + 22 object lifecycle = 62/62. Covers protected registrations, actual field removal, chart deletion/recreation, partial metric removal retaining the manifold, and final cleanup. Existing background lifecycle checks are retained for final regression.
Native chart servants must be removed by their chart owner. For owned cross-family component servants (such as a chart-specific metric determinant), the deletion executor detaches the known servant from its live master before undefinition, after dependency preflight. It does not manipulate external objects. Partial failures retain the registry with an explicit failure report.
ReconstructionData is an input record, not an automatic undo command. Arbitrary user variables remain outside managed invalidation. Next: multiple connections and supported property copying.

# Beta 13 consolidation — dev.31

Development candidate only. No public release or main merge. Source and notebooks tested at `2dfdfa87173303ed11ac8c6115ab9fa968b12175`; see [machine-readable results](Tests/dev31-results.json).

## Provenance and strategy

- Registration dev.30: `6b5574d31bb300ae8f386f2daab8d35f6c8d7b67` (base of develop and the consolidation feature branch).
- Native-integration dev.16: `93b41839bfa328dfde6656d4e2b2b60015a75a01` (selective transplantation, not an automatic merge).
- Common ancestor dev.15: `5b0e5da236ae86846ef9353ca0078fd4a94f46ed`.
- Historical branches remain unchanged; their commit identities are recorded here. Annotated tags were not created because the available GitHub interface does not expose tag creation.
- Version chosen: 14.0.0-beta.13-dev.31. Retain the existing public convenience functions; prefer native xAct syntax in new examples.

## Implemented

1. Native scalar coordinate declarations and suffixed aliases, including collision checks, transactional alias rollback, recipe replay and lifecycle cleanup. String label lists remain supported.
2. Native SetBasisChange on managed chart pairs, with native tensor-slot transformations in ToComponents and distinct scalar coordinate substitution. ConnectionMatrixOf retains the non-tensorial Hessian term.
3. Reject direct replacement of an owned chart pair via SetBasisChange, without intercepting foreign pairs. Retain dev.30's managed chart destruction guards and dependency checks.
4. Unary ToCTensor for uniquely owned expressions, preserving explicit native forms. Snapshot output, not a linked field.
5. Ordered active groups and independent specialization rules; conflict inspection, deactivation, no-op result preservation, reconstruction and deletion coherence.
6. Structured ShowBackground and connection-specific BackgroundObject.
7. Preserve dev.30 metric/field input capture, sparse input behavior, selective reads, native geometry cache coherence and held calls.
8. Add [focused notebook](xPlorer_Consolidated.nb), [acceptance suite](Tests/35_Consolidation.wl), recovered [native coordinate tests](Tests/36_NativeCoordinates.wl), and notebook runner.

## Validation

Wolfram Language 15.0.1 Linux, xAct 1.3.0, portable permutation backend. All 32 RunGroup cases independently executed at the immutable tested commit; 854/854 assertions (792 historical, 30 consolidation, 32 recovered native coordinate tests). Some groups overlap; counts are executions, not unique assertions.

- Historical workflow: 365/365 input executions; 84/84 math checks; 33/33 stages; zero parse, malformed, warning or unexpected-failure cells. Expected invalidated_result failure retained.
- Consolidated workflow: 66/66 input executions; 22/22 checks; zero parse, warning or unexpected-failure cells.
- Optional xTras Einstein-scalar example: 6/6.
- Traditional application: installation in temporary directory, duplicate refusal, Needs loading dev.31, temporary installation removed.
- Paclet development directory: PacletDirectoryLoad and Needs load dev.31, PacletDirectoryUnload returned {}.
- Archive build: Failure["PacletArchive", ...], ArchiveResult $Failed. No archive install/uninstall or Desktop rendering test. No claimed performance speedup.

## Finite release gate

- [x] Integrate the native features on dev.30 without losing existing regressions.
- [x] Validate nonlinear and non-diagonal chart maps, affine coefficients, rule groups, external dependencies and reconstruction.
- [x] Execute both notebooks, complete regression suite and optional xTras example.
- [x] Keep package, paclet, citation metadata and current API guide aligned.
- [ ] On Mathematica Desktop: build the real archive with Tools/BuildPaclet.wl, install it in a clean environment with xAct, restart and verify Needs plus version, run the focused notebook, check visual rendering and uninstall the test archive.
- [ ] Only after the Desktop gate, consider a release PR to main and a verified archive asset.

## Explicit non-goals for this beta

No primary-chart promotion, individual secondary-chart deletion, general foreign-basis replay, arbitrary raw Basis/cache mutation synchronization, general secondary native field assignment, arbitrary connections/fibrations beyond the documented scope, spinor framework, wholesale API removal or performance optimization. Do not mix untracked native writes and managed replay. Local chart domain and invertibility assumptions remain the user's responsibility.

Reproduce: set Global`$XPlorerTestGroup to a group name from Tests/RunGroup.wl in a fresh kernel and Get the runner. For notebook checks Get Tests/WorkflowTests.wl and Tests/ConsolidatedWorkflowTests.wl in separate fresh kernels with xAct installed.

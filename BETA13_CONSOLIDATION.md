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

## Principal workflow update (2026-11-27)

The principal guide is now xPlorer_Workflow.nb. Preserve the eight-section narrative and native mathematical boxes/styles of the existing guide; migrate primary and secondary charts to scalar declarations and suffixed coordinate heads without overwriting aliases. Integrate unary ToCTensor, native basis changes, managed sparse field inputs, explicit primary metric/field calls, independent rule groups and structured inspection. Correct the earlier prose about native capture and managed lifecycle. The original 84 expected-result checks remain, with coordinate references migrated to the native API and 10 new checks. The focused xPlorer_Consolidated.nb remains at its existing path for reproducible technical validation, not as the recommended tutorial.

Exact notebook/test candidate `a34fd3231ad530a27646b064e801b4d25e6e9001`: 380/380 selected input executions, 94/94 mathematical checks, 33/33 stages; zero parse, malformed, warning or unexpected-failure cells; the intentional invalidated_result failure is unchanged. Wolfram Language 15.0.1 Linux, xAct 1.3.0, portable permutation backend; source Get path 21.267951 s. The alternate Needs input was substituted into the temporary runner's load cell and run with PacletDirectoryLoad in a fresh kernel: the same counts, 19.767037 s. These are execution durations, not performance comparisons. Initial run passed 90/92 checks; the remaining two were test-reference errors (old cylindrical coordinate spelling and CTensor's optional third weight slot), not package changes. No change to package source, version, original focused notebook or historical regression results. The author reports building the actual paclet on Desktop; it has not been supplied for verification, and installed-archive execution, uninstallation and visual rendering remain unverified. No release or main merge.

## dev.32 — native printer recursion hotfix (2026-11-27)

Desktop report: CreateBackground["NamingExample", SymbolSuffix->"Demo", PrintAs->"q", Indices->...] hit $IterationLimit at 4096 with either source Get or installed paclet. Subsequent unknown backgrounds are cascading failures. Reproduced dev.31 with actual System Print and a separate notebook-like context, using the portable permutation backend; isolated the same recursion in a minimal Block[Print=Function[...]] example. Prior runners silenced Print and masked the defect. Remove only the local Print interception, preserve the dynamic internal dispatch flag and Catch/Check behavior; native diagnostic messages can now contain long private context names. Mathematical output formatting and API are unchanged. WorkflowTests now leaves Print native by default, with optional Global`$XPlorerWorkflowSilent=True only for secondary quiet runs. Do not wrap the native-printer acceptance run in Block[Print=...].

Dev.32 source a3d8b84c038b8cd52f494e04990a0d1625a60fc6: the first 19 selected post-load notebook inputs execute in a separate notebook-like context with native Print enabled, NamingExample created, no warning cells. Full exact candidate ccc77c6c23be5c855143f28380e5ae0e72933ee1: 380/380 inputs, 94/94 math checks, 33/33 stages; zero parse, malformed, warning or unexpected-failure cells; expected invalidated_result retained; Print ownvalues unchanged (empty). Wolfram 15.0.1 Linux, xAct 1.3.0, portable permutation backend. Windows Desktop and actual dev.32 archive installation not yet verified. No release or main merge. The previously built dev.31 archive must be rebuilt for this code fix.

## dev.33 — object-label presentation and public beta onboarding (2026-11-27)

User-approved scope: labels at session/background/chart/owned-head/single-view levels, not as RegisterTheory field options. Separate symbol suffix from visual label, keep default off, retain existing whole-expression caption. Use native xAct formatting inside a display-only local InheritedBlock of owned heads. No new native global Print or MakeBoxes interception; source tensor definitions and component values remain unchanged. Shared constants and indices remain unlabelled. Mixed-background views use each object's own settings. Chart label defaults distinguish secondary charts. Preserve background/chart overrides and remap recorded head overrides in recipes; transient generated heads without recipe identity are not guaranteed to restore individual exceptions. Direct RegisterTheory[savedRegistry] restores a saved association without With; held native registration remains unchanged.

Two public notebooks: QuickStart (51 selected inputs) for a first scientific calculation and Workflow (398 selected inputs) for the full reference. Preserve original Workflow stages/checks, introduce label examples and remove user-facing With. Retain the consolidated notebook as a development integration test, not a public tutorial. Quick Start optionally reduces native informational printing with xAct settings; full Workflow keeps native Print enabled by default to guard against dev.31's recursion failure. Public release README and Tools/PrepareRelease.wl use a whitelist excluding all development material. No release yet.

Validation: exact final code/notebook candidate `a209092a78b731a4ed8dfef83cab61b8f96edfe6` on Wolfram 15.0.1 Linux and xAct 1.3.0 with portable permutation backend. Full Workflow 398/398 selected cells, 94/94 math checks, 33/33 stages both direct Get and development-directory Needs; no parse/malformed/warning/unexpected failure cells. ObjectLabelsTests 49/49 (actual native box rendering, copy recovery, native/prefix/postfix derivative markers independent of the field, all partial styles, TeX, coordinate and chart settings, mixed owners, vector/tensor/perturbation/affine additions, reconstruction, preserved saved math). Same source tested at earlier candidate 1bf4a0d07e47ecaacab81f96aa809a6a4723831d: Quick Start 51/51 inputs, no warnings or unexpected failures; plane-wave residual, Ricci scalar and unchanged FLRW residual all zero, Kretschmann 48 Mbh^2/r^6. Eight targeted historical groups 247/247 executions (Display 55, Registration 56, TheoryInspection 25, Reconstruction 20, NativeCoordinates 32, Consolidation 30, ChartLifecycle 13, FieldExtensions 16); not a rerun of all 32 historical groups. Synthetic matching ZIP renamed .paclet verified staging and ZIP creation; missing archive rejected. Synthetic archive is not an installable paclet and was not distributed. Real Desktop-built dev.33 archive, installation/uninstallation and front-end visual review remain pending. Initial Quick Start used unsupported explicit metric assumptions; fixed with existing managed shorthand. Initial recipe association-key remap lost a coordinate override; fixed by replacing the rule list before rebuilding the association. No change to the mathematical engine, no main merge or public release.

## dev.34 — scientific workflow and inspection polish (2026-11-27)

User feedback: early and visible object labels/captions, meaningful complete expressions, compact aligned theory tables, readable typed names and clarity about saved results. Extended Minkowski study retains tag MinkowskiFields and uses suffix minkF (AminkF, gminkF, aminkF); affine study uses Aff. Literal underscore is not used in Wolfram symbol names. The extended notebook now separates physical results, profiles/charts, advanced presentation, vector/affine examples, result reuse, perturbations and lifecycle. The temporary naming example is moved after the first physical calculations and restores the original registry. Labels are enabled as an optional tutorial preference; the package default remains off. Add a real unregistered stress-energy observable using PortExpression and independent FLRW energy-density check; use ReplaceDummies on the Lagrangian to avoid free/dummy index capture. SaveResult is optional in-memory invalidation, shown by comparing old and newly computed vector norms, with FailureQ instead of an intentional visible failure. Native deletion messages are explained. Compact left/top-aligned ShowTheory tables use 12-point typography and a three-column sector/collection/key layout, retaining native math entries. Explicit and automatic expression views capture resolved label plans when created, rather than re-reading mutable preferences while rendering. Whole-output captions work for owned non-derivative expressions too.

Exact final candidate 6b95369996b787e2112095560be406077a75d7b5: Workflow 412/412 selected input executions, 102/102 checks, 33/33 stages; zero parse, malformed, warning or unexpected-failure cells, native Print enabled. Quick Start 51/51 selected inputs without warnings or failures on candidate 52869061b8723948b0d30ad0e34651ffdf99cfc5 (unchanged Quick Start and source). On same source, ObjectLabelsTests 49/49 and TheoryInspection 25/25, tested at f84e16a4afaeb40f43e1e7415c5ecd96b428cee7. Wolfram 15.0.1 Linux, xAct 1.3.0, portable backend. Actual Desktop layout and dev.34 paclet construction/install/uninstall not verified; full historical regression suite not repeated. The prior dev.33 archive must be rebuilt. No main merge or publication.

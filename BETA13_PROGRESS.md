# beta.13 development checkpoint

Date: 2026-11-25. Branch: beta13-registration-dev. Current checkpoint is **14.0.0-beta.13-dev.3**, not a release. Earlier dev.2 evidence is retained below. Main remains the author-supplied beta.12.

Validated package commit: ef5ccab0f661aabb1a67df54a24658b4d9d75fa8 (xPlorer.wl blob 73ea50f628b0890ba489f34270f33b38372b84a3).
Proca example correction: b7644d8ebd0949425d108b3cd4445d57016eb45f.

## Changes

- Native xAct metadata inference for scalars, vectors, general ordinary tensors and the verified xPert metric perturbation. No legacy positional Scalar/Vector/Tensor/MetricPert registration.
- Name, SymbolBase, PrintAs and single-sector classification; bulk registration with validation before registry mutation.
- Shared constant-symbol Parameters; numerical specialization remains a background rule.
- Named Lagrangians and Expressions with held RHS name extraction, explicit Head for anonymous formulas, zero-weight scalar validation for Lagrangians, no automatically summed Total.
- One internal Formula map with qualified IDs, public collection/value access and TheorySector. ShowTheory was a raw restorable snapshot in dev.2; dev.3 separates presentation from TheorySnapshot.
- Formal aliases use source symbol names, not registry keys. BackgroundExpression[tag,section,key] and UseExpression[tag,section,key] support qualified lookup. ToComponents accepts {section,key}. Unqualified lookup fails on ambiguous keys. Existing occupied notebook symbols are protected.
- Formula deletion and alias release now follow individual registered dependencies, not whole Lagrangian sections.

## Reproduction and execution evidence

Fresh Wolfram Language 15.0.1 Linux x86-64 kernels, official xAct 1.3.0. In the remote harness, download/extract xAct, load xPert/xCoba, then set xAct xPerm's $xpermQ=False to use portable Wolfram permutations. This is confined to the harness; the package does not change this option. Fetch the exact commit, not a mutable raw branch URL (one remote fetch returned the stale dev.1 file).

1. Load xPlorer.wl, then Get["Tests/13_Registration.wl"] from the repository (using the appropriate path). Registration and lifecycle: 45/45, no failures.
2. Fresh kernel; set $B13GeometryTests=True before loading Tests/13_Registration.wl. Registration and Schwarzschild: 37/37, no failures. The two groups share 33 checks (49 distinct targeted assertions overall).
3. Fresh kernel; load xPlorer.wl, then Get["Examples/Beta13_Proca.wl"]. Uses the native variational derivative, a fixed Schwarzschild geometry and a test covariant profile A_t=r^2. FieldAssignment -> "OK", ExpectedResidual -> {0,0,0,0}. Computed E^t = -6 + mass^2 r^2/(1-2 Mbh/r); the other components vanish. The profile is not assumed to solve the Proca equations. No backreaction or boundary-value solution is claimed.

Initial dev.1 registration/lifecycle group passed 43/45. FindFreeIndices has HoldFirst, so the local value symbol was mistakenly treated as scalar. dev.2 inserts the value lexically via With, checks free indices and zero weight, and both reruns passed. The first Proca draft also had a multiline assignment and an unsupported string field selector; the corrected example uses a parenthesized full Lagrangian and the actual copied symbol ASchw. Only the corrected example is counted as passing.

## Open work (do not release yet)

- The actual author notebook, regression suite and optional ScalarTheory.wl recipe are migrated and validated; see checkpoints below. Still update API_GUIDE and decide whether to reauthor the historical Tools build sources. Loader metadata is updated in dev.3. The legacy 88-input builder is now guarded against overwriting the current notebook.
- Public inspection is implemented in dev.3 below; still audit raw Association restore validation. Strengthen source-definition preflight on later redefinition, unsupported native properties and dependency tests; registration does not freeze all live xAct definitions.
- Audit qualified ExpressionText/export and validate unknown collection arguments. Currently SetFieldComponents uses a source/copied tensor symbol, not a string key. Keep native semantics rather than assume every public operation supports every selector.
- Extend tests for density rejection, extra bundles, SymbolBase/PrintAs, alias collisions with geometry, parameter duplicate source names and additional connections. Sector is a single string; no auto-active theory Rules or multi-sector membership in this checkpoint.
- Historical perturbation calculations, FLRW and additional connections are now rerun in the evening checkpoint below. Actual notebook execution is now validated in the checkpoint below; front-end rendering remains pending. Spinors/tetrads/Clifford algebra remain outside this ordinary-tensor implementation.

Do not merge or tag a release until the migrated workflow and full regression are actually checked. Continue from this branch rather than restarting the validated beta.12 work.

## Regression migration checkpoint (2026-11-25, evening)

The legacy test fixture, core, lifecycle, presentation, object lifecycle and connection tests, and ScalarTheory.wl have been migrated to the beta.13 API. Tested immutable commit b3349deb336e1d1cc3e31d3a577832c378f7b3a0 with Wolfram MCP, WL 15.0.1 and xAct 1.3.0, fresh kernel per group and portable xPerm backend:

| Group | Passed / total |
| --- | --- |
| Geometry | 49/49 |
| Perturbations | 48/48 |
| Lifecycle | 64/64 |
| Display | 34/34 |
| ObjectsAndConnections | 45/45 |
| ComponentsAndRules | 24/24 |
| Reconstruction | 9/9 |
| MetricConnectionCurvature | 6/6 |

All eight groups returned an empty Failures list. Total 279 assertion executions including repeated core checks. The lifecycle group includes one new assertion for immediate rejection of undefined field registration; its raw snapshot fault injection preserves the separate malformed-data creation tests. The core snapshot test now explicitly unregisters/re-registers its formula rather than relying on replacement semantics. Presentation re-registration restores dependent formulas from the raw snapshot. Principal notebook and ScalarTheory.wl validation followed in the next checkpoint. No release or merge to main.

## Author notebook migration and validation (2026-11-25)

Migrated the actual author-supplied beta.12 notebook (115 inputs, eight sections; original blob 02227e5531596b36748f75efa7f8da1eedabe228), not the older 88-input Tools source. Preserved the eight-section teaching flow, native input boxes, embedded stylesheet, cell tags, coordinate-chart examples, independent connections, perturbation and cleanup. Native boxes for changed inputs were generated in Wolfram MCP. The scalar kinetic and mass terms and their explicitly formed total are now three independently registered Lagrangians. Matter sector groups the field, mass constant and formulas. Formula aliases follow source symbol capitalization (scalarEqSchw, lagrangianSchw), while keys remain explicit ("ScalarEq", "Lagrangian"). Anonymous expressions have explicit Head options. No duplicate registration of the Lagrangian in Expressions.

Notebook blob: 786e0eb2bf3291048f19b5422857326b44f7ee26.
Final notebook + workflow test commit: f5ea3d95213d43e4de778ce37544ba2916a4471c.
Kernel: Wolfram Language 15.0.1 Linux x86-64, xAct 1.3.0, portable xPerm backend (test runner only).
Executed actual BoxData sequentially, not a substitute script:
- Inputs: 115/115.
- Parse failures: 0; warning cells: 0.
- Unexpected Failure cells: 0; expected Failure at invalidated_result (saved-result invalidation demonstration).
- Expected-result assertions: 65/65.
- Temporal/workflow-order assertions: 6/6 (startup, naming and label identity, theory before backgrounds, independent manifolds before charts, charts before metric matrices, actual field undefinition).

Includes scalar equations on Minkowski, Schwarzschild, FLRW, Schwarzschild Kretschmann, plane-wave dispersion, cylindrical metric/connection/Hessian/trace, affine gradient and curvature, vector raising, tensor axes, cache, rule and result lifetimes, first/second perturbations and Taylor factor, deletion and recreation. An earlier migration run detected two adjacent display expressions being interpreted as multiplication; corrected to explicit lists and reran. No front-end available for screenshot or visual verification.

Reproduce from a fresh kernel with xAct installed: Get["/path/to/xPlorer/Tests/WorkflowTests.wl"]. The runner checks the actual notebook boxes, captures results at execution time, and returns expected/failed checks separately.

Optional ScalarTheory.wl was aligned with the notebook's initial theory and independently executed at commit 754c85db5f1043f3fb7e3e07433928bc974cd6a2. Confirmed no backgrounds at registration, exact Matter sector keys, scalar variational equation, explicit Lagrangian sum, successful subsequent background creation and copied native metric. The temporary naming demonstration is intentionally omitted from this reusable source recipe.

The historical Tools/tutorial_cells.json and input/formula box caches remain beta.7 authoring sources (88 inputs). Do not regenerate the current notebook from them. Tools/build_notebook.py now requires an explicit --legacy-output destination and refuses the canonical notebook path. The actual xPlorer_Workflow.nb is the source of truth until the authoring sources are rebuilt.

Package code itself is unchanged from dev.2; no release or merge to main. Next: harden the registration/inspection API, finish documentation, metadata and edge-case testing, and check visual layout in Mathematica Desktop.

## dev.3 — theory inspection and installation (2026-11-26)

Package commit 505a423a568325703c89fccc6a128c36645bc327 (blob 7c8a8302210c6e77cf427d1df3892fe60161d77d). ShowTheory[] returns a native compact Column of Grid sections, no registry mutation; ShowTheory[section] shows detail, including actual formula values for Lagrangians and Expressions. Geometry, Fields, Parameters, Lagrangians, Expressions, Connections, Sectors and Metadata are supported; unknown sections return Failure. No external GUI or dynamic state. TheoryValue gains Geometry, Metadata and Sectors views. ShowTheoryKeys[], TheorySector, BackgroundObject, BackgroundExpression and suffixed aliases retained. TheorySnapshot[] explicitly returns the old raw association; optional for manual restore, not needed for normal work. Tests and notebook snapshot calls migrated. The unknown UnregisterTheory section no longer evaluates Keys on a Failure.

Notebook commit 0e115142e3cb4a7048e942878a0bbabaef7a2ece: 117/117 actual cells, 65/65 expected results, six temporal stages true, zero parse failures, zero warning cells, zero unexpected Failure cells. New views evaluate to native Column and Grid. Visual Desktop rendering remains unverified. At f649050aa5f8d137173f874b4ed7129e438bf95d, Registration 45/45, Lifecycle 64/64, Display 34/34, and dedicated TheoryInspection 18/18 passed; other regression groups last run on dev.2.

Traditional application installation: Install.wl defines InstallXPlorer[] (default user Applications directory) and optional explicit application directory. Copies only package, two kernel loaders, license and citation; stages files before renaming; existing installation refused. Verified in temporary Applications directory in Wolfram MCP using Needs, 18/18 inspection checks, and repeated installation refused. User's actual Desktop installation has not been performed. Instructions in README.md.

Paclet: metadata and loaders synchronized to dev.3. Named Asset entries include canonical source, license and citation without maintaining duplicate code. Actual PacletBuild staging at d00c22bc11eea670d2a97e28f29cc512beeb5402 contained all five essential paths including metadata. PacletDirectoryLoad on the staged package and Needs loaded dev.3 successfully. Remote Java security policy blocked final .paclet compression (PacletArchive -> $Failed); Tools/BuildPaclet.wl now explicitly reports that failure. Desktop archive building and PacletInstall remain unverified. No release, no merging experimental code to main.

GPL-3.0-or-later, citation and acknowledgements added to both branches before dev.3. CITATION.cff updated to dev.3 on this branch; main remains beta.12. No ORCID or DOI invented.

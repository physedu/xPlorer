# beta.13 development checkpoint

Date: 2026-11-25. Branch: beta13-registration-dev. This is **14.0.0-beta.13-dev.2**, not a release. Main remains the author-supplied beta.12.

Validated package commit: ef5ccab0f661aabb1a67df54a24658b4d9d75fa8 (xPlorer.wl blob 73ea50f628b0890ba489f34270f33b38372b84a3).
Proca example correction: b7644d8ebd0949425d108b3cd4445d57016eb45f.

## Changes

- Native xAct metadata inference for scalars, vectors, general ordinary tensors and the verified xPert metric perturbation. No legacy positional Scalar/Vector/Tensor/MetricPert registration.
- Name, SymbolBase, PrintAs and single-sector classification; bulk registration with validation before registry mutation.
- Shared constant-symbol Parameters; numerical specialization remains a background rule.
- Named Lagrangians and Expressions with held RHS name extraction, explicit Head for anonymous formulas, zero-weight scalar validation for Lagrangians, no automatically summed Total.
- One internal Formula map with qualified IDs, public collection/value access and TheorySector. ShowTheory remains a raw restorable snapshot at this checkpoint.
- Formal aliases use source symbol names, not registry keys. BackgroundExpression[tag,section,key] and UseExpression[tag,section,key] support qualified lookup. ToComponents accepts {section,key}. Unqualified lookup fails on ambiguous keys. Existing occupied notebook symbols are protected.
- Formula deletion and alias release now follow individual registered dependencies, not whole Lagrangian sections.

## Reproduction and execution evidence

Fresh Wolfram Language 15.0.1 Linux x86-64 kernels, official xAct 1.3.0. In the remote harness, download/extract xAct, load xPert/xCoba, then set xAct xPerm's $xpermQ=False to use portable Wolfram permutations. This is confined to the harness; the package does not change this option. Fetch the exact commit, not a mutable raw branch URL (one remote fetch returned the stale dev.1 file).

1. Load xPlorer.wl, then Get["Tests/13_Registration.wl"] from the repository (using the appropriate path). Registration and lifecycle: 45/45, no failures.
2. Fresh kernel; set $B13GeometryTests=True before loading Tests/13_Registration.wl. Registration and Schwarzschild: 37/37, no failures. The two groups share 33 checks (49 distinct targeted assertions overall).
3. Fresh kernel; load xPlorer.wl, then Get["Examples/Beta13_Proca.wl"]. Uses the native variational derivative, a fixed Schwarzschild geometry and a test covariant profile A_t=r^2. FieldAssignment -> "OK", ExpectedResidual -> {0,0,0,0}. Computed E^t = -6 + mass^2 r^2/(1-2 Mbh/r); the other components vanish. The profile is not assumed to solve the Proca equations. No backreaction or boundary-value solution is claimed.

Initial dev.1 registration/lifecycle group passed 43/45. FindFreeIndices has HoldFirst, so the local value symbol was mistakenly treated as scalar. dev.2 inserts the value lexically via With, checks free indices and zero weight, and both reruns passed. The first Proca draft also had a multiline assignment and an unsupported string field selector; the corrected example uses a parenthesized full Lagrangian and the actual copied symbol ASchw. Only the corrected example is counted as passing.

## Open work (do not release yet)

- Migrate the beta.12 principal notebook, legacy tests, optional ScalarTheory.wl recipe, API_GUIDE, loader metadata and Tools build sources to the breaking API. The beta.12 notebook is intentionally preserved unchanged on this branch for now; it will not run end-to-end with dev.2. The older 196-assertion regression and beta.12 notebook results have NOT been rerun with beta.13.
- Finalize public inspection (grouped Geometry/collections versus raw snapshot) and audit raw Association restore validation. Strengthen source-definition preflight on later redefinition, unsupported native properties and dependency tests; registration does not freeze all live xAct definitions.
- Audit qualified ExpressionText/export and validate unknown collection arguments. Currently SetFieldComponents uses a source/copied tensor symbol, not a string key. Keep native semantics rather than assume every public operation supports every selector.
- Extend tests for density rejection, extra bundles, SymbolBase/PrintAs, alias collisions with geometry, parameter duplicate source names and additional connections. Sector is a single string; no auto-active theory Rules or multi-sector membership in this checkpoint.
- Test full perturbation calculations (registration/copy checked; not the full old perturbation regression), FLRW, additional connections and frontend notebook rendering. Spinors/tetrads/Clifford algebra remain outside this ordinary-tensor implementation.

Do not merge or tag a release until the migrated workflow and full regression are actually checked. Continue from this branch rather than restarting the validated beta.12 work.

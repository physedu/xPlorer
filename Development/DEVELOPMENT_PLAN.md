# xPlorer development plan

Status: the seven stages are implemented within the explicitly documented supported scope in 14.0.0-beta.7. See API_GUIDE.md, VALIDATION.md and PROGRESS.md for actual behavior and evidence; the requirements below remain the design record.
Read DECISIONS.md and PROGRESS.md before changing code. All syntax proposed below is illustrative until implemented and documented.

## Goal and baseline

Support a physicist's workflow: formulate a theory abstractly, register it once, create independent backgrounds, inspect formal tensors, apply particularizations, introduce coordinates and calculate components and equations. Preserve the simple route with one Get and sensible defaults. Personalization is optional and must not reduce mathematical functionality.

The available package baseline is 14.0.0-beta.2, accompanied by xPlorer_Workflow.nb and Tests/. The prior GitHub main at bfad1a672b71f3fa76b0ac006e632d33677d8344 contained a file named xPlorer.wl whose content was a Notebook expression, not a package source. Preserve that commit; publish the available actual package and notebook before implementing extensions. Do not infer mathematical superiority from modification time alone.

Existing behavior to preserve includes theory registration, isolated background copies, expression transport, scoped rules, charts and metric components, scalar/vector/tensor components, perturbations, caching, and background deletion/recreation. Reinspect the code and execute relevant checks before declaring baseline behavior verified in a new environment.

## Stage 1: baseline and compatibility

- Confirm repository state, dependencies, package version, notebook and test entry points; preserve user edits.
- Maintain Get loading without discovery machinery, forced backend settings or version gates in the user notebook.
- Record current API and known limitations. Distinguish registration metadata from enforced equations or assumptions.
- Preserve existing one-background and multi-background workflows; no implicit global active background.
- Acceptance: clean-kernel loading and the existing applicable regression suite pass, or specific environmental blockers are recorded. No unsupported success claims.

## Stage 2: inherited presentation and readable names

- Automatically inherit effective source xAct PrintAs where supported, including resolving default Identity against the source rather than a generated field name.
- Permit overrides during registration, background creation and later changes; offer both source inheritance and explicit customization.
- Example: a source phi defined with PrintAs -> "m" keeps m when copied; an explicit override can display M1 without changing the source, its registry key, or its tensor identity.
- Handle fields, metrics, indices, connection symbols and curvature families where supported. Maintain a documented support matrix rather than silently dropping options.
- Make actual generated heads readable inside an isolated xPlorer context. Improve bare-head output as well as indexed tensor output. InputForm/full identity inspection must remain available.
- Native PrintAs does not alone solve bare-symbol display. Validate any scoped box definitions and naming hooks for xAct compatibility, copying, removal and recreation.
- Do not rename objects already in use. Keep existing getters returning genuine tensor heads.
- Acceptance: inherited/overridden/reset display, simultaneous backgrounds and collisions are checked; SameQ, tensor registration and mathematical results survive presentation changes.

## Stage 3: optional notation and preferences

- Keep native xAct notation as default. Add reversible, scoped display choices for ordinary partial derivatives, multi-indices, fractions/partial notation, single-argument primes, and covariant derivative markers/placement.
- Optional background/connection labels should help compare objects without exposing long internal contexts in normal output.
- Never reorder covariant derivatives, change differentiation arguments, or replace computational tensors with decorative symbols.
- Separate preferences from mathematical options. Changing presentation alone must not invalidate geometry caches.
- Acceptance: supported display forms retain the underlying held expression and copy/evaluation behavior; no global changes to unrelated xAct symbols. Check front-end appearance when available and disclose when only boxes were tested.

## Stage 4: ownership, dependencies and deletion

- Distinguish clearing values, clearing computed caches, unregistering a theory item, deleting an owned xAct object, and deleting a whole background.
- Cover fields, rules, named expressions, charts, connections, metrics, parameters and manifolds according to actual support.
- Build dependency information from native hosts/visitors/servants/master relationships plus tracked Xplorer expressions, rules and results. Respect native family auto-removal; do not undefine servants twice.
- Provide an optional preview containing ownership, removal order, blockers, affected registrations and invalidated results.
- Default to protecting shared/external objects. Registration of an existing source object does not transfer ownership. Cascades must have an explicit bounded scope and must not silently remove other backgrounds or source theory.
- Detect failures and verify postconditions. Report partial failure honestly; do not promise transactional rollback or arbitrary undo.
- Explain that arbitrary expressions and aliases in user variables cannot all be discovered or rewritten. Offer reconstruction recipes for managed objects, not universal kernel restoration.
- Acceptance: deleting blocked objects makes no mutation; deleting owned families really deregisters them; recreation has no stale values and leaves independent backgrounds unchanged.

## Stage 5: multiple abstract connections

- Register/copy named connections in addition to the primary Levi-Civita connection. Preserve existing one-argument getters through a primary default.
- Each connection owns its appropriate curvature family and presentation; select explicitly when ambiguity matters.
- Preserve supported torsion, curvature and metric relations; translate references to copied objects. Validate unsupported combinations explicitly.
- Curvature identities for general connections differ from Levi-Civita identities. Do not assume Ricci symmetry, a scalar curvature, or metric Bianchi checks without their hypotheses.
- Validate scoped native naming hooks, including relative Christoffels for pairs of connections, rather than globally changing xAct GiveSymbol.
- Acceptance: two connections coexist on a background; expression transport, getters, curvatures, relative connection tensors, deletion and recreation are consistent.

## Stage 6: components, rules and invalidation

- Independent connections require supplied coefficients or a difference tensor relative to a known connection; a metric alone does not determine them.
- Extend component evaluation and checks only for declared supported mathematical cases, with correct torsion/nonmetricity treatment.
- Support selective rule removal/replacement, inspection and named groups of particularizations; define precedence and conflicts clearly. Preserve existing AddRules/ApplyRules/ClearRules behavior or document migration.
- Track dependencies of cached results. Mathematical changes invalidate affected results; presentation-only changes do not.
- Show what belongs to the abstract theory and each background, which indices and connection to use, and how to return to previous managed data through documented operations.
- Acceptance: independent known-result cases for component connections, rule conflicts and selective removal, and changes followed by recalculation pass. Do not claim a speedup without measurements.

## Stage 7: teaching notebook and distribution

Maintain one principal didactic notebook and separate technical tests. During development use small targeted checks and checkpoints; do not regenerate an entire guide after every minor edit.

Keep the existing scalar-theory narrative and eight-part progression:
1. Abstract fields, Lagrangian, equations/conditions and registration, before concrete metric data.
2. Independent Minkowski, Schwarzschild and FLRW backgrounds and inspection.
3. Formal tensors before coordinates: retrieval, heads versus indexed expressions, indices, contractions, covariant derivatives and transport.
4. Local rules and particularizations: add, inspect, replace/remove and clear.
5. Coordinates, metric matrices, components and useful physical calculations.
6. Additional fields and tensor structures, showing how later registration affects new copies.
7. Reuse, mathematical changes, cache behavior and perturbations where supported.
8. Cleanup, actual deletion and recreation while preserving other backgrounds.

Insert explanations naturally next to each use: what a function receives, stores, returns, alternative input forms, and later reuse. Explain Mathematica versus xAct versus Xplorer contextually. Integrate connections and display features where needed. Avoid mandatory demo helpers, test dashboards and cumbersome startup cells.

All delivered source and notebook prose must be English and ASCII. Use native mathematical boxes. Inherit theme colors; distinguish code, prose and important notes with typography, spacing and borders. No fixed foreground/background colors. ScalarTheory.wl is an optional source recipe, not a startup dependency.

Organize an installable application and evaluate a paclet after the core stabilizes. Both traditional application folders and paclets can support Needs. Keep Get supported. Do not promise complete coverage of every native option; publish supported cases and limits.

Acceptance: the final notebook executes sequentially in a fresh kernel, includes physical expected results on curved backgrounds, and accurately describes supported features. Keep tests separate and report exact execution environment and any untested visual checks.

## Checkpoints and scope

Each stage must leave usable code, focused regression evidence, updated progress and a descriptive pushed commit. Mark validated usable milestones with version tags; beta milestones remain beta, not stable releases. No release for every small change, no force pushes, no credentials or unnecessary bulky outputs. Record next steps so another session can resume without this chat.

Do not implement unrequested solvers, a GUI, or unrestricted support for all xAct configurations. Correctness and the default workflow take priority over customization breadth.

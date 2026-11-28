# Active development plan — public beta 1

Approved by the maintainer on 2026-11-28. This is the active implementation roadmap on develop. It supersedes the mandatory work sequence in sections 14, 16 and 17 of [COMPATIBILITY_AUDIT_EXTENDED.md](COMPATIBILITY_AUDIT_EXTENDED.md), without invalidating the experimental findings or deleting the historical record.

## 1. Purpose and scope

xPlorer helps researchers formulate a theory once with native xAct, copy it to independent geometric backgrounds, particularize it, and obtain components in one Mathematica kernel. xTensor, xCoba, xPert and optional xTras remain the mathematical engines. Keep the native-first syntax, readable aliases, optional presentation and simple startup established in [DEVELOPMENT_PLAN.md](DEVELOPMENT_PLAN.md), [DECISIONS.md](DECISIONS.md) and [WORKFLOW_STYLE.md](WORKFLOW_STYLE.md).

Different geometries normally belong to different backgrounds. Correcting a metric assignment or changing an ansatz within a study is a secondary convenience, not the architecture's governing use case. Keep existing working capabilities; do not broaden them merely to handle arbitrary kernel modifications.

A clearly documented unsupported operation is an acceptable boundary. Explain how the researcher can proceed using another background, explicit coordinate expressions, a redefined connection, or native xAct where appropriate. Prefer a concise diagnostic where managed code can detect an otherwise misleading operation; do not attempt to intercept every arbitrary native expression. Never silently return incorrect mathematical results for accepted managed inputs. Physical equations, domains and hypotheses remain the researcher's responsibility.

## 2. Current evidence

Reviewed exact develop revision [930ff2c](https://github.com/physedu/xPlorer/commit/930ff2c4b39944f05d7d20698b5bb771e4ace782), Wolfram Language 15.0.1 Linux, xAct 1.3.0, portable permutation backend. Fresh checks on 2026-11-28:

| Check | Result |
| --- | --- |
| Research Workflow | 153/153 selected input cells; 37/37 checks |
| API Examples | 419/419 input cells; 109/109 checks; 33/33 stages |
| ForeignInputIsolation | 39/39 |
| ConnectionMetricPreflight | 10/10 |
| MetricEdits | 13/13 |
| Consolidation | 30/30 |

Both notebook runners reported no unexpected failures or warnings. An initial harness used global symbols d and f which collided with notebook abstract indices; rerunning with isolated harness symbols resolved those artificial failures. The full historical suite and Desktop visual acceptance were not performed. Historical evidence includes 854/854 grouped checks in dev.31 (overlapping groups) and optional xTras examples. The earlier actual public paclet installation/uninstallation and distribution verification are recorded in [main/VALIDATION.md](https://github.com/physedu/xPlorer/blob/main/VALIDATION.md); that archive is not the updated develop source.

## 3. Finite implementation sequence

### Phase 1 — Core consolidation: completed within tested scope

Preserve registration, copying, expression transport, independent backgrounds, managed native component input, specialization, profiles, secondary charts, perturbations and bounded cleanup. Isolation is repaired and tested. Keep the current native-first API and working convenience functions; no wholesale API removal before beta.

### Phase 2 — Correct remaining demonstrated mathematical defects

- [ ] **Assumption-aware geometry cache (finding C).** The FLRW example with scale factor 1+Abs[k] t still returns cached 24 rather than fresh 8/3 at k=-2,t=1 after changing ambient assumptions. Define effective assumptions consistently in the managed/native computation paths, or prevent unsafe reuse; delegate geometry to xCoba and preserve useful selective caching. Test cached versus fresh results, positive/negative branches and explicit assumptions. Do not design a general dependency engine for arbitrary mutable Wolfram functions.
- [ ] **Unresolved tensors in metric components (finding B).** The current code still accepts a matrix containing phi[] with an assigned coordinate profile t^3; its curvature is 0 rather than 90/t^2 under the intended interpretation. Native xCoba reproduces this behavior. Define the supported component-input contract: explicit coordinate expressions, not implicit dynamically linked tensor profiles. Prefer a small detection/rejection mechanism with a helpful explanation and example of supplying coordinate expressions. Do not implement dynamic metric-field dependencies or automatic snapshots without a demonstrated need. Consider the analogous issue in other managed geometry inputs if supported by a concrete reproduction.
- [x] **Cross-background input contamination (finding A).** Retain existing validated guards and regressions.
- [x] **Incompatible metric edit with existing independent connection (finding D, reproduced path).** Retain the tested preflight correction for now. It is not a requirement to support every complex metric/connection modification. A clear restriction or diagnostic explaining alternative usage is sufficient; prefer a simpler documented contract over duplicating xCoba geometry. Do not make exhaustive flatness, multiple-connection replay or general rollback development a release gate. If an accepted supported path demonstrably returns inconsistent mathematics, correct it or restrict it explicitly. Current preflight coverage beyond the reproduced metric-compatibility case is not certified.

Keep changes localized. Preserve native mathematics, no new public API unless necessary. Add focused regressions for the two open defects and ensure the ordinary workflows remain correct.

### Phase 3 — Scientific validation

- [ ] Compare native xAct and managed results in a small set of representative research workflows: Einstein-scalar/Klein-Gordon on independent backgrounds, Maxwell/Proca, metric perturbations, and a supported metric-affine example. Reuse existing examples and tests first.
- [ ] Prioritize interoperability with optional xTras (e.g. native VarD/VarL and expression transport). This was part of the original motivation; do not build special solvers or variation engines. An f(R) example is useful if it adds distinct coverage.
- [ ] **Bounded Rule/Set interoperability and performance experiment (optional, after Phase 2).** See [RULE_SET_RESEARCH.md](RULE_SET_RESEARCH.md): native transitions already work, managed reads are conservatively blocked, a per-ValID restoration prototype preserved mixed state, and prepared-array substitution timings justify further investigation. Test localized read-only compatibility and temporary Set evaluation after component preparation; compare full scientific workflows including conversion overhead and memory. Adopt only if correct, simple and demonstrably useful. Preserve existing explicit limits on Set-state mutations. No global modifications to xCoba transition functions; no unconditional release blocker.
- [ ] Rerun both actual public notebooks and relevant regression groups on the frozen corrected source; record exact revision, environment, expected results and any blockers. Run historical suites where practical; distinguish missing execution evidence from a confirmed mathematical failure.

### Phase 4 — Public beta preparation

- [ ] Freeze the corrected scientific scope. Document supported workflows and intentional limits in the public README/API guide without burdening the introductory tutorial with internal implementation details.
- [ ] Follow WORKFLOW_STYLE.md: native syntax, English prose, one operation per input cell, useful physical expressions, optional presentation, separate installation notebook.
- [ ] Build and verify a matching real paclet and curated distribution (current layout includes the three notebooks). The previous archive already passed remote installation/uninstallation; do not reuse it for changed source. Review Desktop rendering, copy/paste and actual installation as applicable.
- [ ] Keep main as the clean public tree; project only reviewed public files from develop. Publication remains subject to maintainer approval. See RELEASE_CHECKLIST.md and current public VALIDATION.md.

### Phase 5 — Researcher feedback

Prioritize concrete scientific use cases and reproducible reports from beta testers. Do not defer the beta indefinitely to implement hypothetical extensions.

## 4. Explicit non-goals for this beta

- Universal transactions, arbitrary undo, general rollback or dependency tracking for the Mathematica kernel.
- Dynamic metric-field dependency graphs, automatic backreaction or equation solvers.
- Synchronizing every native mutation, arbitrary cache edit, general cycle detection or general external basis replay.
- Full support for native xCoba Rule/Set storage transitions or arbitrary Set-state mutations. RuleToSet changes stored component rules into direct assignments; SetToRule restores rule storage. Preserve native behavior and explicit managed mutation boundaries. The bounded read-only and optional performance experiment in Phase 3 is the sole exception; no permanent automatic state conversion or requirement to learn these commands.
- General extra bundles, spinors, tetrads/Clifford algebra, complete xPand integration, exhaustive cross-version compatibility, or a broad rewrite of private adapters.
- Mass removal of public convenience functions or speculative performance optimization. The API redundancy audit remains a future design reference.

These are not missing mandatory features. Reconsider them only with concrete researcher demand or a reproducible defect in the supported workflow. Keep the historical compatibility audit as a technical evidence and risk register rather than an implementation checklist.

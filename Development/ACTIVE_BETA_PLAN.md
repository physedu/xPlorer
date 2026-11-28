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

- [x] **Assumption-aware geometry cache (finding C).** Corrected on develop; the managed and captured native geometry paths use a scoped explicit assumption domain, not ambient $Assumptions. Explicit domain changes invalidate derived values; identical policy reuses the cache. Native inverse assignment was also found to poison the cache and corrected. See [Phase 2 evidence](PHASE2_VALIDATION.md). Arbitrary mutable user simplifiers remain outside the guarantee.
- [x] **Unresolved tensors in metric components (finding B).** Managed metric input now rejects unresolved xTensor heads other than the primary coordinate scalars, with a diagnostic recommending explicit coordinate expressions or an evaluated snapshot. The demonstrated profile t^3 yields 90/t^2 when supplied in coordinates. Rejection is tested for managed shorthand, native primary matrix and native component edits. Dynamic geometry remains out of scope. See [Phase 2 evidence](PHASE2_VALIDATION.md).
- [x] **Cross-background input contamination (finding A).** Retain existing validated guards and regressions.
- [x] **Incompatible metric edit with existing independent connection (finding D, reproduced path).** Retain the tested preflight correction for now. It is not a requirement to support every complex metric/connection modification. A clear restriction or diagnostic explaining alternative usage is sufficient; prefer a simpler documented contract over duplicating xCoba geometry. Do not make exhaustive flatness, multiple-connection replay or general rollback development a release gate. If an accepted supported path demonstrably returns inconsistent mathematics, correct it or restrict it explicitly. Current preflight coverage beyond the reproduced metric-compatibility case is not certified.

Keep changes localized. Preserve native mathematics, no new public API unless necessary. Add focused regressions for the two open defects and ensure the ordinary workflows remain correct.

### Phase 3 — Scientific validation

- [x] Compare representative scientific workflows: Einstein-scalar/Klein-Gordon on independent backgrounds, Proca on Schwarzschild, metric perturbations and the supported metric-affine example in the notebooks. See [Phase 2 and scientific evidence](PHASE2_VALIDATION.md).
- [x] Prioritize interoperability with optional xTras: [EinsteinScalarVarL.wl](../Examples/EinsteinScalarVarL.wl) passes 6/6 native VarL/VarD and component checks across two backgrounds. No new variation engine. An additional f(R) example is optional future coverage.
- [x] **Bounded Rule/Set interoperability and performance experiment.** See [RULE_SET_RESEARCH.md](RULE_SET_RESEARCH.md). Full-workflow experiments showed mixed timing benefits, higher allocation peaks and exact tested arithmetic results. Broader read-only restoration changed metric and LI[2] fingerprints even though values matched. Do not enable either prototype for this beta; preserve the explicit native transition workflow and safe managed diagnostic. Future targeted optimization/semantic verification is optional and not a release blocker.
- [x] Rerun both actual public notebooks and relevant regression groups on corrected source: 572/572 cells, 146/146 notebook checks, 33/33 stages and 182/182 focused executions at 07090af. See [PHASE2_VALIDATION.md](PHASE2_VALIDATION.md). Full historical suite and Desktop acceptance are not claimed. Rerun relevant checks if the scientific source changes during release preparation.

### Phase 4 — Public beta preparation

- [x] Freeze the corrected scientific scope at source blob 90cef340400e8fbcac7fb5b6a3d3514f97db8daa. Document the metric input and assumption policy and Rule/Set boundary in README, API_GUIDE and tester-facing Release/README. No new public functions.
- [x] Preserve WORKFLOW_STYLE.md and the validated scientific notebooks unchanged; native syntax, English prose, separate installation notebook. Desktop visual acceptance remains pending.
- [ ] Build and verify a matching real paclet and curated distribution (current layout includes the three notebooks). The previous archive already passed remote installation/uninstallation; do not reuse it for changed source. Review Desktop rendering, copy/paste and actual installation as applicable. Remote native archive build attempted at 56de8d9: Java SecurityException, Failure["PacletArchive",...]. Build in Desktop; see RELEASE_CHECKLIST.md.
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

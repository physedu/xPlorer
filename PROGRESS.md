# Recovery checkpoint

Date: 2026-11-23
Version: 14.0.0-beta.7
State: stages 1-7 implemented and validated within API_GUIDE.md's supported scope.
Repository: https://github.com/physedu/xPlorer
Branch: main
Version recovery branch: checkpoint/v14.0.0-beta.7
Version tag: v14.0.0-beta.7
Pre-release: https://github.com/physedu/xPlorer/releases/tag/v14.0.0-beta.7
The validated code recovery point is f91015bf5335690f515c80b9f66b39cbbbd40b2e, now preserved by tag v14.0.0-beta.7. Later documentation-only commits do not change that tag. No history was rewritten.

## What is ready

- Single-Get startup, existing default workflows and independent background snapshots.
- Native source presentation inheritance, optional theory/background/later overrides, readable actual curvature heads and interpreted bare-head display.
- Optional interpreted partial/covariant derivative views that preserve expressions.
- Value clearing, registration removal, dependency previews, bounded owned-object deletion, external protection, partial metric/chart lifecycles and verified cleanup postconditions.
- Named additional connections, appropriate curvature getters, supplied coordinate coefficients or differences from Primary, declaration checks and component evaluation.
- Selective/grouped rules, conservative saved-result invalidation, and managed reconstruction recipes while source definitions remain alive.
- One applied principal notebook, separate technical tests, editable notebook build sources, normal application loader and development paclet metadata.

## Validation

Wolfram Language 15.0.1 Linux x86-64, official xAct 1.3.0. Portable xPerm settings are confined to the test harness.

- Package: 196 distinct assertions pass in fresh-kernel groups. Core assertions repeat in geometry/perturbation/lifecycle groups; see Tests/Final-results.json.
- Actual notebook: 88 input cells executed sequentially, 45 expected-result checks and 3 workflow-order checks passed, zero parse failures and zero warning cells.
- Cold single Get, traditional application Needs and development PacletDirectoryLoad + Needs checked independently.
- English ASCII and theme-inherited notebook styles checked statically. No front-end screenshots, binary paclet release or speedup measurement is claimed.
- Large combined remote requests returned evaluator Internal error; split groups succeeded. Tests/RunGroup.wl supports the same bounded groups for reproducibility.

## Checkpoint history

| Stage | Commit | Result |
| --- | --- | --- |
| Published actual package baseline and plan | 83a8c2fea299cdc669ea794a77e06c75aab0b30f | Replaced mislabeled notebook content at package path; prior history preserved |
| 1: revalidated baseline | 78d4ecaee0a40fd35f43dae0f114d8361b8c59f7 | All 75 original distinct checks covered in groups |
| 2: inherited labels and readable heads | 52a6e57f3d42de0f3aa50770c76125b517e79dfb | Core and targeted presentation checks |
| 3: optional notation | 4dfddd11e63102e715421dc854c8c197d5efc946 | Interpreted expression recovery |
| 4: lifecycle operations | 1cb80d6e3baba313ff09bd69c322fea08e60e520 | Field/chart/metric deletion and recreation |
| 5: connections | e8ec3d01be2bb418cc854a26e0f59d04954e76cd | Independent and metric-associated derivatives, conjugation |
| 6: components and rules | 170243cc979ef4504579d2927859616a21cac136 | Supplied connection data, rule management and invalidation |
| 6: recorded refinements | 7ee0206b84138b801ee6a41e14ed2d1ba703df11 | Additional documentation/checkpoint |
| 7: finalization | f91015bf5335690f515c80b9f66b39cbbbd40b2e | Full worked notebook, installation, support guide and final regression |

## Decisions and fixes that matter when resuming

DeleteBackgroundObject avoids Wolfram's protected System DeleteObject. Native servant families must be removed through their owner; chart-specific metric determinant servants may need a managed detach from the live metric before chart deletion. Relative tensors involving external derivatives block deletion. Postcondition checks do not recreate removed names unnecessarily.

The old lifecycle suite had two HoldAll restoration calls that did not insert the saved Association. They now use With. Invalid field metadata is rejected before mutation, and a genuine source-rank mismatch separately tests partial-creation rollback. An incomplete cleanup now reports remaining definitions instead of falsely claiming rollback.

StrictComponents excludes chart coordinate scalars from unresolved tensors. Scalar wrappers are evaluated as independent contractions, fixing extra metric-connection scalar contractions. Additional metric-connection curvature families are covered by six physical expected-result checks, including nonzero torsion. Native BreakChristoffel must be scoped to compatible tracked relative heads; using its global registry across unrelated bundles generated mixed rule lists in xAct 1.3.0.

Presentation uses isolated native label resolution and scoped naming/box definitions; no permanent global native overrides. Fields with density/graded/projected/orthogonal structure, extra bundles/manifold dependencies and extended/weighted connections are outside current support. See API_GUIDE.md before widening that scope.

RecreateBackground restores managed inputs, not arbitrary kernel state or saved results. It requires the source xAct definitions and rejects recipes with rules on relative-connection tensor heads. Source constants/functions in profiles remain shared.

## Remaining work and limits

1. Verify actual Mathematica front-end appearance under light and dark themes on the user's computer; the mathematical and box-interpretation checks already pass.
2. Expand native option/bundle support only with new requirements and tests; do not relabel untested options as supported.
3. Test other xAct/Wolfram versions before claiming compatibility. Relative-connection and label helpers currently depend on isolated xAct 1.3.0 internals.
4. Build/install a distributable binary paclet if desired; source metadata and development loading are already checked.
5. Tag v14.0.0-beta.7 was created through the authenticated GitHub browser session and published as a pre-release. The API confirms its target is f91015bf5335690f515c80b9f66b39cbbbd40b2e. The connected API tools still lack a tag-creation operation, but this version tag is no longer pending.

Read DEVELOPMENT_PLAN.md, DECISIONS.md, API_GUIDE.md and VALIDATION.md before further development. Compare current main and preserve later user changes. Do not restart completed stages or repeat mathematical tests solely for prose edits.

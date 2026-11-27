# Development archive

Internal design, planning, recovery and release-preparation records for xPlorer. The scientific source and executable tests remain in their normal locations. The public-facing branch excludes these internal files; no historical branches or commits have been rewritten.

## Documents

- [COMPATIBILITY_AUDIT.md](COMPATIBILITY_AUDIT.md) — reproducible compatibility findings, fixes and remaining research scope.
- [COMPATIBILITY_AUDIT_EXTENDED.md](COMPATIBILITY_AUDIT_EXTENDED.md) — four confirmed mathematical-correctness findings, independent reproductions, native integration risks and the approved P0–P2 remediation plan; publication gate pending.

- [WORKFLOW_STYLE.md](WORKFLOW_STYLE.md) — binding editorial and pedagogical rules for the public notebooks.

- [API_AUDIT.md](API_AUDIT.md)
- [API_REDUNDANCY_AUDIT.md](API_REDUNDANCY_AUDIT.md)
- [BETA13_CONSOLIDATION.md](BETA13_CONSOLIDATION.md)
- [BETA13_PLAN.md](BETA13_PLAN.md)
- [BETA13_PROGRESS.md](BETA13_PROGRESS.md)
- [DECISIONS.md](DECISIONS.md)
- [DEVELOPMENT_HISTORY.md](DEVELOPMENT_HISTORY.md)
- [DEVELOPMENT_PLAN.md](DEVELOPMENT_PLAN.md)
- [IMPLEMENTATION_PROMPT.md](IMPLEMENTATION_PROMPT.md)
- [PROGRESS.md](PROGRESS.md)
- [RELEASE_CHECKLIST.md](RELEASE_CHECKLIST.md)

## Historical validation

[ValidationHistory/](ValidationHistory/) contains the original JSON reports, not a fresh run of the public beta. The exact pre-organization snapshot is [5739716](https://github.com/physedu/xPlorer/tree/5739716c53906c7420c9b7697564c331074cf6be). Historical notes may refer to filenames and paths as they existed at the recorded commit.

## Active branch policy — 2026-11-27

The maintainer selected exactly two active branches: `main` (clean public-facing source tree) and `develop` (complete development tree and internal records). PR #14 has been merged into main at [7160eb0](https://github.com/physedu/xPlorer/commit/7160eb0a943ce7fe432adae650e0634d3b2d8ecf). This is the unreleased 1.0.0-beta.1 candidate, not an announcement of publication. No new development work should occur on temporary or historical branches. For future releases, project the public source tree into main, keeping this Development archive and historical-only material on develop. Do not blindly merge the complete development tree into main.

Fresh notebook validation of the clean candidate [d67e5b8](https://github.com/physedu/xPlorer/commit/d67e5b8f09d99ccd457f3237569e992de57ad9aa) passed 131/131 and 419/419 cells, 26/26 and 109/109 checks, and 33/33 advanced stages. See [public validation](https://github.com/physedu/xPlorer/blob/7160eb0a943ce7fe432adae650e0634d3b2d8ecf/VALIDATION.md). The startup banner was observed with the correct version and GitHub URL. The remote native archive builder failed due to a Java security restriction; actual paclet installation, Desktop acceptance and publication remain pending. The main integration was advanced before that gate to establish the two active branches; the publication gate is unchanged.

## Retired branch references

These refs are retained as historical recovery points, not active development branches. Before physically removing refs, preserve their exact tips with permanent archival tags or other reachable references. The connector does not provide branch deletion or tag creation. No history has been rewritten.

| Retired branch | Recorded tip |
| --- | --- |
| `beta12-complete` | [5118f1596581](https://github.com/physedu/xPlorer/commit/5118f1596581fd2e749a37ba3704fd31ab59d75f) |
| `beta12-workflow` | [56b3382ba4bf](https://github.com/physedu/xPlorer/commit/56b3382ba4bf93190bfb410a6d3ecdda485673ac) |
| `beta13-background-inspection` | [69dbc6881935](https://github.com/physedu/xPlorer/commit/69dbc68819350ff17b279cc4618c39fd1afc7037) |
| `beta13-consolidation` | [b165edebd2e5](https://github.com/physedu/xPlorer/commit/b165edebd2e58050d3b2a9681f4c21698f7f0d61) |
| `beta13-native-integration-dev` | [52046c8f1f4c](https://github.com/physedu/xPlorer/commit/52046c8f1f4caf5d1e86f568ed254c60d6f87ed2) |
| `beta13-presentation-onboarding` | [de7d72a79a24](https://github.com/physedu/xPlorer/commit/de7d72a79a2418ffab96e9bb42c16835fd9f933e) |
| `beta13-public-notebook-pair` | [fd89a07ec0ea](https://github.com/physedu/xPlorer/commit/fd89a07ec0ea4ad12c02495f0c9b175002ff75ea) |
| `beta13-registration-dev` | [0a736e8a040f](https://github.com/physedu/xPlorer/commit/0a736e8a040f26fb919f2141a19d3e0cf7e13e28) |
| `beta13-release-onboarding-polish` | [e1e56ff1fe43](https://github.com/physedu/xPlorer/commit/e1e56ff1fe43368e761f58cdfbd6b808e3c7f207) |
| `beta13-workflow-polish` | [094c639123d5](https://github.com/physedu/xPlorer/commit/094c639123d59ae0f4a504a50831b38849c025f4) |
| `beta14-release-candidate` | [ba0abe6aef51](https://github.com/physedu/xPlorer/commit/ba0abe6aef51a9191bf70c7997ac28d7c3b36c5f) |
| `checkpoint/v14.0.0-beta.7` | [19673f642510](https://github.com/physedu/xPlorer/commit/19673f642510d39119d263e390131b883112bb7c) |
| `fix-native-print-dev32` | [f0812c3fba33](https://github.com/physedu/xPlorer/commit/f0812c3fba3391e03f23305dd41cfeb1b8d975be) |
| `public-beta1-candidate` | [3342fa6c4aae](https://github.com/physedu/xPlorer/commit/3342fa6c4aae1e035879334c2bd9fb6f0751edce) |
| `public-beta1-clean` | [0e10dca6d922](https://github.com/physedu/xPlorer/commit/0e10dca6d922c3ed8cce7202c472eb4a8297603a) |
| `workflow-collapsible-navigation` | [2ace58250e6c](https://github.com/physedu/xPlorer/commit/2ace58250e6c2ee062fc11f3e441de4e96ea512f) |
| `workflow-dev31` | [fb04bef7acda](https://github.com/physedu/xPlorer/commit/fb04bef7acda2031bdbe2ff0ba4445df39ba0a8b) |
| `workflow-startup-and-affine-restore` | [72990b1f1dd0](https://github.com/physedu/xPlorer/commit/72990b1f1dd01f2de0f29b8d76451e1480b1a486) |

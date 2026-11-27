# Development history and transition to public beta 1

Decision date: 2026-11-27. Status: first public beta candidate, not a published release.

## Why the version changed

The internal series `14.0.0-beta.*` records iterative private research development, not fourteen public major releases. The final integrated internal candidate was `14.0.0-beta.13-dev.36`, at [20f1316](https://github.com/physedu/xPlorer/commit/20f131646a2c80ed2b02ead03e0f379fd0091ae1). A provisional `14.0.0-beta.14` was prepared on a separate branch but never merged into develop or published. The maintainer chose `1.0.0-beta.1` for the first public beta, with proposed tag `v1.0.0-beta.1`. Future public versions follow semantic-versioning conventions. This is a new public numbering scheme, not a rewrite or loss of the prior work.

The new public candidate is derived from the integrated dev.36 code, not from the unmerged provisional beta.14 branch. No scientific functionality is intentionally changed: the package version, metadata, citation, notebook startup and flat distribution layout are synchronized. Internal testers must uninstall previous numerically higher 14.x paclets and restart the kernel before testing Needs with beta 1. Preserve independent xAct installations and research notebooks.

## Evolution of the project

- Early internal checkpoints and beta 12 established the package and workflows.
- The beta 13 native-integration and registration streams were consolidated on develop, retaining both managed native xCoba interoperability and explicit theory registration. The original source heads and independent background copies remain central to the design.
- dev.32 fixed recursive native informational printing; later candidates introduced optional visual object labels, more compact inspection, native-first examples and readable notebook navigation.
- dev.36 moved the affine example to the end and split the public documentation into the seven-section research Workflow and the full API Examples reference. The earlier Quick Start is retained as development material, not distributed.
- The API redundancy audit is a roadmap, not a set of implemented removals. Do not remove public commands as part of this release freeze.

See [BETA13_CONSOLIDATION.md](BETA13_CONSOLIDATION.md), [BETA13_PROGRESS.md](BETA13_PROGRESS.md), [API_REDUNDANCY_AUDIT.md](API_REDUNDANCY_AUDIT.md), [DECISIONS.md](DECISIONS.md) and merged PRs #3–#12 for the detailed development evidence.

## Historical branch map

The following commit identifiers are the observed branch tips before adding transition documentation. They remain immutable recovery points even if a branch receives a documentation-only commit. Do not cherry-pick the public version change back into historical code; do not force-push, delete or rewrite historical refs.

| Branch | Pre-transition commit | Role |
|---|---|---|
| `checkpoint/v14.0.0-beta.7` | [`f91015bf5335`](https://github.com/physedu/xPlorer/commit/f91015bf5335690f515c80b9f66b39cbbbd40b2e) | Early internal checkpoint |
| `beta12-complete` | [`ff85df23f951`](https://github.com/physedu/xPlorer/commit/ff85df23f951fc94aa655ac08763a67f4fd53f51) | Beta 12 development checkpoint |
| `beta12-workflow` | [`e05eecb8be96`](https://github.com/physedu/xPlorer/commit/e05eecb8be9670949c2bf8b8ff7e6a947fa3ab1f) | Beta 12 workflow |
| `beta13-native-integration-dev` | [`93b41839bfa3`](https://github.com/physedu/xPlorer/commit/93b41839bfa328dfde6656d4e2b2b60015a75a01) | Native xCoba integration stream (dev.16) |
| `beta13-registration-dev` | [`6b5574d31bb3`](https://github.com/physedu/xPlorer/commit/6b5574d31bb300ae8f386f2daab8d35f6c8d7b67) | Registration stream (dev.30) |
| `beta13-consolidation` | [`1ae0ad681def`](https://github.com/physedu/xPlorer/commit/1ae0ad681def6f7da30ccf0139c699a95d54f1ff) | Consolidation of native and registration streams |
| `workflow-dev31` | [`87a3fb5ad8ce`](https://github.com/physedu/xPlorer/commit/87a3fb5ad8ceecb753b8226dd5f4e8dd6e584e00) | Consolidated workflow |
| `fix-native-print-dev32` | [`bf1dea928109`](https://github.com/physedu/xPlorer/commit/bf1dea928109051e8c0f5ba9c5c0f655b53301ad) | Native Print recursion fix |
| `beta13-presentation-onboarding` | [`3844ad4fc24a`](https://github.com/physedu/xPlorer/commit/3844ad4fc24a7dabe8883b5403fdbf0e85f163c2) | Object labels and public onboarding |
| `beta13-workflow-polish` | [`8d6eb521e788`](https://github.com/physedu/xPlorer/commit/8d6eb521e7882c752bcf6e85bd0b4bf186e4eb2e) | Workflow polish and label capture |
| `beta13-background-inspection` | [`bdf3c6886007`](https://github.com/physedu/xPlorer/commit/bdf3c68860075d62942a6091525e98740035facb) | Readable inspection and separate raw access |
| `beta13-release-onboarding-polish` | [`24304a970143`](https://github.com/physedu/xPlorer/commit/24304a970143e0635f691344e6c118c2bb802afc) | Native-first onboarding and table hierarchy |
| `workflow-collapsible-navigation` | [`0f0ab5e694c3`](https://github.com/physedu/xPlorer/commit/0f0ab5e694c3519a1a792c61e5c238586c667281) | Folded notebook navigation |
| `workflow-startup-and-affine-restore` | [`ec3064f50b23`](https://github.com/physedu/xPlorer/commit/ec3064f50b23df00ebdbb516fffbf6fbe76d9cbc) | Scientific priority and optional affine example |
| `beta13-public-notebook-pair` | [`12ba8ced0d1b`](https://github.com/physedu/xPlorer/commit/12ba8ced0d1bef5b422f5680491675ec12e666e5) | Intermediate research workflow and exhaustive API reference |
| `beta14-release-candidate` | [`19ff48ffe205`](https://github.com/physedu/xPlorer/commit/19ff48ffe205b245b41963ff2d07659f73191fe3) | Provisional 14.0.0-beta.14 numbering, superseded before merge or release |
| `develop` | [`20f131646a2c`](https://github.com/physedu/xPlorer/commit/20f131646a2c80ed2b02ead03e0f379fd0091ae1) | Last integrated internal dev.36 state before public renumbering |
| `main` | [`6e3f3b048702`](https://github.com/physedu/xPlorer/commit/6e3f3b04870239e84ceb2ce2216087533ebaa4db) | Existing main; no public beta code merge yet |

## Public release layout

Seven visible files in the curated distribution ZIP:

```text
xPlorer-1.0.0-beta.1/
  xPlorer-1.0.0-beta.1.paclet
  xPlorer.wl
  xPlorer_Workflow.nb
  xPlorer_API_Examples.nb
  README.md
  LICENSE
  CITATION.cff
```

The repository still contains the complete Paclet/ build tree. PacletInfo.wl, Kernel/init.m, Kernel/init.wl, license and citation remain inside the installable archive. They are not duplicated as a second expanded folder in the curated ZIP. The flat source can be loaded directly via Get; both notebooks also support the development checkout layout. The release preparation tool verifies all six required internal files against the frozen source tree before copying the seven public files. The repository and automatically generated source archives remain development material.

## Release gate

- Freeze scientific scope; correct verified bugs only before beta.
- Validate both actual public notebooks and relevant regression tests; check both Get and Needs.
- Build a new archive from the public 1.0.0-beta.1 source. A dev.35 or dev.36 archive is not the public beta and must not be renamed or uploaded as such.
- Verify archive bytes, installation/uninstallation and light/dark Desktop appearance; record the exact commit and hashes.
- Publish a GitHub pre-release with proposed tag v1.0.0-beta.1 and separate ZIP and paclet assets only after maintainer acceptance. Until then main remains the earlier code, and develop is the candidate.

The historical validation results describe the commits actually tested; they are not retrospective claims about untested versions. Public beta acceptance results are recorded in the accompanying progress notes.

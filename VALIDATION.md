# Validation — xPlorer 1.0.0-beta.1 candidate

## Executed evidence

The maintainer's recorded test candidate is [4ed4712](https://github.com/physedu/xPlorer/commit/4ed4712d06a6a926acacc41d91d303f3af2699e7). Environment: Wolfram Language 15.0.1, Linux, xAct 1.3.0, portable permutation backend; native printing enabled.

| Test | Result |
| --- | --- |
| Research Workflow, flat source loading and registered development directory loading | 131/131 selected cells, 26/26 checks for each |
| API Examples, direct source loading in repository layout | 419/419 selected cells, 109/109 checks, 33/33 stages |
| Warnings and unexpected failures in those runs | 0 |

The release staging helper was exercised with a synthetic ZIP containing the six required internal files, renamed .paclet. The output contained seven top-level files and byte-identical plain source. This was not an actual installable paclet test.

These results describe the recorded candidate, not a fresh run on the reorganized repository. Subsequent source changes are limited to the introductory banner and AboutXPlorer output; the scientific source and both public notebooks are unchanged by this organization. The supplemental integration notebook has been relocated into Tests/Fixtures/ and its runner path adjusted; the relocated runner has not been executed here.

## Revalidation of the clean public source tree — 27 November 2026

Exact tested commit: [d67e5b8](https://github.com/physedu/xPlorer/commit/d67e5b8f09d99ccd457f3237569e992de57ad9aa). Fresh remote Wolfram Language 15.0.1 Linux kernels, xAct 1.3.0, portable permutation backend, native printing enabled, repository direct-source loading.

| Test | Result |
| --- | --- |
| Research Workflow | 131/131 cells, 26/26 checks |
| API Examples | 419/419 cells, 109/109 checks, 33/33 stages |
| Warnings, parse errors and unexpected failures | None reported by the respective runners |
| Startup banner | Correct version 1.0.0-beta.1 and GitHub URL observed |

CreatePacletArchive failed in the remote evaluator because of a Java security restriction; no actual installable archive or Desktop acceptance is claimed. The integration fixture and complete regression suite have not been rerun.

## Revised public notebooks — 27 November 2026

The revised Workflow at [7c7b2e1](https://github.com/physedu/xPlorer/commit/7c7b2e1915269a919991ae59b6b835ba5e052dd3) passed 136/136 selected input cells and 28/28 checks, with no warnings or unexpected failures. API Examples at [5e58e9f](https://github.com/physedu/xPlorer/commit/5e58e9f26de3f95279664fe22f4f78525bc95045) passed 419/419 cells, 109/109 checks and 33/33 stages; it is unchanged at the newer revision. Both used fresh Wolfram Language 15.0.1 Linux kernels with xAct 1.3.0 and direct-source loading. The Needs cell also loaded version 1.0.0-beta.1 from a registered paclet development directory. Actual archive installation and Desktop visual acceptance remain pending.

## Actual beta archive and distribution — 27 November 2026

The maintainer-supplied paclet was verified byte-for-byte against all six files in the frozen public Paclet tree. In a fresh remote Wolfram Language 15.0.1 Linux kernel with xAct 1.3.0, PacletInstall succeeded, Needs loaded xPlorer 1.0.0-beta.1, and PacletUninstall succeeded (PacletFind returned an empty list afterward). This is an actual archive installation check, not the earlier development-directory test. Desktop visual acceptance remains pending.

The curated ZIP was downloaded again from [78ca776](https://github.com/physedu/xPlorer/commit/78ca77620cdb5a9eca7a933a05d23de5c108dcba), extracted, and verified to contain exactly seven files. Its paclet, plain source, notebooks, license and citation match the public source tree byte-for-byte; the README is the tester-facing guide.

SHA-256:
- Paclet: `1502273632ab33859fd836f00208da83e11c1ded90fb4cd60066368b00d74798`
- ZIP: `1ffd03f34e22a3eefb777a7d306b55923a10816c48308f38559c7d226d068621`

## Final Workflow presentation revision — 27 November 2026

The revised Workflow at [e32d96a](https://github.com/physedu/xPlorer/commit/e32d96a47bfb5ca1cdda752c7c2131e0d0478514) passed 140/140 selected input cells and 28/28 checks, with no warnings or unexpected failures. The revision removes grouped display wrappers and retains meaningful notation examples. API Examples and the supplied paclet are unchanged. The regenerated seven-file ZIP at [5a80400](https://github.com/physedu/xPlorer/commit/5a8040085d8d1f5c4f3fa5b6b7bbc640a25a5a01) was downloaded and extracted; its paclet, source, notebooks, license and citation all match the corresponding repository files. Its SHA-256 is `bbaa456c5c29875e301c339dc19a59bcf0dd437391c8eda9e30febf5eb929b53` (supersedes the previous ZIP hash above). Full Desktop visual acceptance remains pending.

## Reproduce

Install xAct separately. Check out the tested revisions on the development branch for the test runners, which are not distributed on main. Use a fresh Mathematica kernel for each runner, adjusting paths to your checkout:

```wl
Get["/path/to/xPlorer/Tests/ResearchWorkflowTests.wl"]
Get["/path/to/xPlorer/Tests/WorkflowTests.wl"]
```

Run each line in a separate fresh kernel. See [test sources on develop](https://github.com/physedu/xPlorer/tree/develop/Tests) for grouped regression tests and additional checks.

## Before public release

The actual archive installation/uninstallation and curated ZIP verification have passed in the remote kernel. Review both notebooks in Mathematica Desktop, including the first-use installation path and visual output, before publication. A full historical regression rerun remains pending. Mathematica 13.0+ is the declared minimum; the recorded environment does not establish compatibility with every supported version.

No full Desktop visual acceptance or performance speedup is claimed; actual archive installation was verified in the remote kernel as documented above. Historical results and their original versions are preserved under [Development/ValidationHistory](https://github.com/physedu/xPlorer/tree/59030c6df0ad282b18b279ae620bf6ec215e8206/Development/ValidationHistory) and [development decisions](https://github.com/physedu/xPlorer/tree/59030c6df0ad282b18b279ae620bf6ec215e8206/Development/DECISIONS.md).

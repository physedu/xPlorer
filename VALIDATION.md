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

## Reproduce

Install xAct separately. Use a fresh Mathematica kernel for each runner, adjusting paths to your checkout:

```wl
Get["/path/to/xPlorer/Tests/ResearchWorkflowTests.wl"]
Get["/path/to/xPlorer/Tests/WorkflowTests.wl"]
```

Run each line in a separate fresh kernel. See [Tests/README.md](Tests/README.md) for grouped regression tests and additional checks.

## Before public release

Build the actual paclet from the current source, verify installation and uninstallation, execute both notebooks and inspect Desktop output, verify the curated ZIP and record exact artifact hashes. A full historical regression rerun remains pending. Mathematica 13.0+ is the declared minimum; the recorded environment does not establish compatibility with every supported version.

No final Desktop appearance, archive installation or performance speedup is claimed. Historical results and their original versions are preserved under [Development/ValidationHistory](https://github.com/physedu/xPlorer/tree/59030c6df0ad282b18b279ae620bf6ec215e8206/Development/ValidationHistory) and [development decisions](https://github.com/physedu/xPlorer/tree/59030c6df0ad282b18b279ae620bf6ec215e8206/Development/DECISIONS.md).

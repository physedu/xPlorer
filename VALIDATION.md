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

## Greek frequency notation revision — 27 November 2026

Both public notebooks now use the symbol `w` with native xAct `PrintAs -> "\[Omega]"`. Fresh runs of [3f64d1b](https://github.com/physedu/xPlorer/commit/3f64d1b6f62dcfcf0d907ab1241341390c156d92) passed 140/140 Workflow cells, 28/28 checks, 419/419 API cells, 109/109 checks and 33/33 stages; no warnings or unexpected failures were reported. The PrintAs value was verified as Greek omega in both runs. The seven-file ZIP at [9eb6cb2](https://github.com/physedu/xPlorer/commit/9eb6cb29718100e8a54fb54b2e3e549d6ac4f567) contains the revised notebooks byte-for-byte; SHA-256 `6592c63ff8d9aa10d41d5b2bc6fef46cfc0737122cb5af3213fdaeac188c78a9` supersedes the earlier ZIP checksums. The paclet is unchanged.

## Revised scientific tutorials and separate installation notebook — 27 November 2026

The public notebooks at [8b03cba](https://github.com/physedu/xPlorer/commit/8b03cba37931f029dfefc26c1a866f66bb2075d2) passed 134/134 Workflow input cells, 31/31 checks (including actual StandardForm box differences for labels, renamed objects and derivative styles), and 419/419 API input cells, 109/109 checks and 33/33 stages. No unexpected failures or warnings were reported by the runners. The main scientific groups are closed and their subsections open. The dedicated installation notebook was tested by evaluating its local archive installation, Needs, version and public-beta uninstallation cells in the remote kernel (the confirmation dialog was simulated). The file picker and visual Desktop appearance were not tested. The distribution now contains eight files, including xPlorer_Install.nb; the unchanged paclet and all other non-README files were verified byte-for-byte against the repository after extracting the ZIP at [09f947c](https://github.com/physedu/xPlorer/commit/09f947c51d051df336db0d662de36f7b9da4c0f9). The current ZIP SHA-256 is `40643431cd853a34f7091480ad003c8b7a2ec508535af368394bdeeb3aa53918`, superseding earlier hashes.

## Editorial revision — 27 November 2026

The Workflow prose was revised to follow the maintainer's paragraph-based editorial rules on develop. All 135 tagged input cells remained byte-identical. Running the extracted distribution at [4f99fd0](https://github.com/physedu/xPlorer/commit/4f99fd0629e03c7a871fa5fddb7e815fc25b880b) selected and executed 134/134 cells and passed 31/31 checks, with no warnings or unexpected failures. The ZIP contains eight files and the extracted Workflow matches the repository byte-for-byte. Current ZIP SHA-256: `17aa990efb409f6ba28012453a6500260455a3d17caa99630ca25e6e2e397480`, superseding earlier hashes. Desktop paragraph layout remains to be reviewed by the maintainer.

## Einstein-scalar tutorial and metric perturbations — 27 November 2026

The revised Workflow at [18f731e](https://github.com/physedu/xPlorer/commit/18f731eaddf44de909049e7214b38e875e18cedc) executed 153/153 selected input cells and passed 36/36 checks in a fresh remote Wolfram Language kernel with xAct 1.3.0, with no recorded warnings or unexpected failures. The new checks cover the tensor wave equations on Minkowski and spatially flat FLRW, second inverse-metric variation and its Taylor coefficient, a quadratic short-wavelength wave-energy expression, its phase average, and expression presentation. Full second-order Einstein components exceeded the remote execution limit and are not included. A postfix rendering failure for the long perturbation expression was avoided by retaining native covariant notation; this does not establish a general fix to the package's rendering path. The eight-file ZIP at [4439ef4](https://github.com/physedu/xPlorer/commit/4439ef4aff426db7725e5bce27fe8fffcd3a6f81) was downloaded and extracted; every file matches its source, including the tester-facing README on develop. SHA-256: `f116af12a85f3408b933dbb0f7e48a254d11ad7b5654962785202d59d8dc4533` (supersedes earlier ZIP hashes). The Paclet and API Examples are unchanged. Desktop visual review remains pending.

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

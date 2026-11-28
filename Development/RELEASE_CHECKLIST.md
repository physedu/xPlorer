# Beta release preparation

This checklist is for the maintainer, not included in the public ZIP. Keep develop and the historical branches unchanged except for reviewed work. Do not publish or merge main until the local acceptance gate passes.

1. Freeze the candidate source and matching PacletInfo.wl, citation and notebook versions.
2. Run the research Workflow, API Examples, label box regression, and relevant mathematical and lifecycle tests with the native printer enabled for notebook acceptance.
3. In Mathematica Desktop, start a fresh kernel. Open xPlorer_Install.nb or evaluate:

```wl
build = Get[FileNameJoin[{NotebookDirectory[], "Tools", "BuildPaclet.wl"}]];
build["PacletArchive"]
```

4. Remove any internal 14.0.0-beta.* paclets first, then install that archive in a clean environment with xAct present. Restart and confirm Needs["xPlorer`"] loads the matching version, run Workflow and API Examples; inspect labels on/off, copy/paste and TeX, including different chart coordinates. Check uninstallation and reinstall if practical.
5. Produce a clean local distribution with:

```wl
Get[FileNameJoin[{NotebookDirectory[], "Tools", "PrepareRelease.wl"}]];
PrepareXPlorerRelease[build["PacletArchive"]]
```

The preparation script compares SHA-256 hashes of all required files within the local paclet to the current Paclet directory, then copies only an explicit whitelist. It refuses an existing staging folder/ZIP or a mismatched archive. If ZIP compression fails after staging, manually compress the reported directory. Do not include an archive from an older candidate.

Public distribution:
- xPlorer.wl (standalone source). Metadata and loaders remain inside the paclet, not duplicated in the ZIP.
- xPlorer-<version>.paclet.
- xPlorer_Install.nb, xPlorer_Workflow.nb and xPlorer_API_Examples.nb.
- README.md (tester guide), LICENSE and CITATION.cff.

No tests, historical Quick Start, consolidated notebook, internal prompts, plans, progress reports, old examples or build scripts in the distribution. A separately attached .paclet asset is useful for users who already have the notebooks. GitHub automatic Source code archives will still contain repository development files if the tag points at develop; direct users to the curated distribution ZIP instead.

6. Verify the actual archive and curated ZIP, record SHA-256 and exact commit, write release notes listing known scope and tested versions. Publish as a GitHub pre-release only with maintainer approval. Do not claim desktop verification or archive availability until the actual artifact is inspected.

Status (2026-11-28): corrected scientific source blob 90cef340400e8fbcac7fb5b6a3d3514f97db8daa validated at 07090af; see PHASE2_VALIDATION.md. The standard Tools/BuildPaclet.wl run on 56de8d9 with all six required Paclet files returned Failure["PacletArchive",...] after Java::excptn (SecurityException) in the remote evaluator. No new archive exists from that run. Build the matching archive in Mathematica Desktop, verify installation/uninstallation and the eight-file distribution; the older public paclet does not match the corrected source. Desktop acceptance and publication remain pending. This file is preparation, not publication.

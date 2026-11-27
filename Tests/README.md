# Executable tests

The numbered .wl files cover the mathematical, lifecycle, native xAct integration and presentation cases. Start a fresh kernel for each runner, with xAct installed. The test scripts use the repository's Paclet source.

- RunTests.wl: historical core regression groups 01–12.
- RunGroup.wl: bounded regression groups; set Global`$XPlorerTestGroup to a supported group before loading the runner (see its source for names).
- ResearchWorkflowTests.wl: main public research notebook.
- WorkflowTests.wl: advanced API Examples notebook.
- ConsolidatedWorkflowTests.wl: supplemental integration test; its notebook is a fixture under Fixtures/, not a third public tutorial.
- ObjectLabelsTests.wl, BackgroundInspectionTests.wl, NotebookStartupTests.wl and PacletBuildTests.wl: targeted checks.

```wl
Global`$XPlorerTestGroup = "Geometry";
Get["/path/to/xPlorer/Tests/RunGroup.wl"];
```

The [validation summary](../VALIDATION.md) distinguishes actual execution evidence from pending checks. Archived JSON reports remain on [develop](https://github.com/physedu/xPlorer/tree/59030c6df0ad282b18b279ae620bf6ec215e8206/Development/ValidationHistory), outside the public source tree. No test assets are included in the seven-file release ZIP.

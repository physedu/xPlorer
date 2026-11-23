# xPlorer v14 validation

Worked tutorial verified: November 23, 2026.

## Current tutorial

The delivered xPlorer_Workflow.nb contains eight sections and 66 executable input cells. All 66 were parsed and executed sequentially from the notebook's native boxes in one fresh kernel. All 36 independent expected-result checks pass. All three ordering checks pass: registration precedes backgrounds, backgrounds precede charts, and charts precede metric matrices. No Wolfram warning messages were generated.

The checks cover individual/named/bulk registration; scalar variation; formal transport versus direct calculation; Riemann head identity; raising a gradient; comparison notation; scoped and cleared rules; scalar equations and curvature on three geometries; a plane-wave solution; vector variance/contraction; tensor axes and selection; geometry reuse; metric changes; first/second variations and Taylor coefficients; actual metric deregistration; fresh recreated field data; and retention of the other backgrounds and source theory.

The optional runner is Tests/WorkflowTests.wl; expected results are in Tests/TutorialChecks.wl. The visible notebook contains no test dashboard or mandatory test setup. Program cells are non-evaluatable alternative syntax, and three DisplayFormula cells are presentation only. Their source and the embedded stylesheet were parsed with the notebook. This environment has no Mathematica front end, so pixel-level front-end appearance was not captured.

The theme compatibility revision removes every explicit FontColor, Background, CellFrameColor, and color object from the notebook. Text and background colors are inherited from the default styles and user theme. Distinctions use typography, margins, and borders. The regenerated notebook parses successfully with 66 input cells, three display formulas, and eight sections; exact input/formula definitions and serialized input boxes match the preceding verified version. The computational checks above were not repeated for this appearance-only change. Light/dark front-end screenshots were not captured.

The original package regression baseline is separate: 75 distinct checks, executed previously as core+geometry (48/48), core+perturbations (47/47), and core+lifecycle (60/60). The package source is unchanged; that entire historical suite was not rerun for this notebook revision. No speedup factor is claimed.

## Environment and reproduction

Wolfram Language 15.0.1 for Linux x86-64; official xAct 1.3.0 distribution. The verification runner selects the portable Wolfram Language xPerm backend during its tests. The notebook and ScalarTheory.wl do not change the user's backend preference.

For normal use, keep xPlorer_Workflow.nb next to xPlorer.wl, start a fresh Mathematica kernel with xAct installed, and evaluate the input cells in order. The first call is:

```wl
Get[FileNameJoin[{NotebookDirectory[], "xPlorer.wl"}]];
```

Only the notebook and package are required for the visible walkthrough. The optional source recipe and Tests folder need not be loaded. To repeat the automatic complete-notebook check in a fresh kernel:

```wl
Get["/path/to/xPlorer_v14/Tests/WorkflowTests.wl"]
```

For the separate historical package suite:

```wl
Get["/path/to/xPlorer_v14/Tests/RunTests.wl"];
$XPlorerTestReport
```

All delivered text is English and ASCII-only. Tensor display uses native Wolfram boxes. Typography and layout styles are embedded; colors are inherited. Complete current results and cell timings are in Tests/validation.json.

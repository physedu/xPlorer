# Validation: 14.0.0-beta.7

Date: 2026-11-23. Environment: Wolfram Language 15.0.1, Linux x86-64; official xAct 1.3.0 (xTensor, xCoba, xPert). The test harness selects portable Wolfram Language permutations because the remote environment does not provide a working external xPerm executable. The package and principal notebook do not change the user's backend setting.

## Principal notebook

The actual xPlorer_Workflow.nb input boxes were parsed and executed sequentially in a fresh kernel: **88/88 inputs**, **45/45 expected-result checks**, **3/3 workflow-order checks**, **zero parse failures and zero warning cells**. The complete report is Development/ValidationHistory/validation.json.

Checks include scalar variation, abstract transport, tensor identity and raising, Minkowski/Schwarzschild/FLRW field equations and curvature, a plane wave, vector/tensor components, perturbative variations, an independent affine derivative and nonzero curvature component, optional notation identity, rule removal, saved snapshots and true deletion/recreation.

A separate cold-start check confirms the package was initially absent, the notebook's single Get returned Null, the version matched and the dependencies were available. Traditional application loading through Needs and development PacletDirectoryLoad followed by Needs were checked separately in fresh kernels. Metadata/loading was checked; no built binary paclet or submission to a paclet server is claimed.

## Package regression

Checks are executed in isolated fresh kernels and small groups to stay within remote evaluator limits. The suite contains 196 distinct assertions, including loops in the notation tests. Core assertions repeat across some groups:

| Group | Passed / total |
| --- | --- |
| Core + geometry | 49 / 49 |
| Core + perturbations | 48 / 48 |
| Core + lifecycle, including genuine partial-creation cleanup | 63 / 63 |
| Presentation + notation | 34 / 34 |
| Object lifecycle + connections/properties | 45 / 45 |
| Independent components + rules/results | 24 / 24 |
| Managed reconstruction recipes | 9 / 9 |
| Additional metric-connection curvature families | 6 / 6 |

See Development/ValidationHistory/Final-results.json for the execution record. Full combined remote submissions returned evaluator Internal error; those failed service calls are not counted as passing checks. The split groups above provide the reported evidence. Run Tests/RunTests.wl in an ordinary local kernel for the complete suite, or Tests/RunGroup.wl for bounded groups.

The baseline was first revalidated before changing code. During final review, two HoldAll restoration calls in the old lifecycle test were corrected to use With; otherwise a check intended to exercise failed creation was testing an incomplete theory instead. Invalid field specifications are now rejected before mutation, and a separate source-rank mismatch exercises real partial-creation cleanup. The test results reflect these corrected cases.

Additional metric-connection cases cover Einstein, Weyl, Ricci scalar, trace-free Ricci and Kretschmann, including a torsionful metric-compatible example. Scalar wrappers are traced independently so local contracted-index scopes are preserved. Additional-connection Kretschmann uses coordinate curvature coefficients and sparse metric contractions rather than expanding a product of abstract Riemann tensors.

## Presentation and scope limits

No Mathematica front end was available, so no pixel-level screenshots or light/dark visual verification are claimed. The notebook inherits Default.nb colors and has no explicit color rules or color objects. Native xAct boxes may use front-end-dependent font sizes and their own output conventions. Interpreted-view checks recover the original expressions, including covariant derivative views; they do not prove every possible front-end interaction.

Supported mathematical scope is documented in API_GUIDE.md. Complex conjugate transport is checked abstractly; a separate component-assignment API for conjugate heads is not provided. Density, projected/graded fields, extra bundles and extended connections are rejected. Arbitrary user definitions and variables are outside managed cleanup/invalidation. No timing comparison or speedup factor is claimed.

## Reproduction

With xAct installed, start a fresh kernel for each group:

```wl
Get["/path/to/xPlorer/Tests/RunTests.wl"];
$XPlorerTestSummary
```

For the sequential principal notebook:

```wl
Get["/path/to/xPlorer/Tests/WorkflowTests.wl"];
$XPlorerWorkflowReport
```

All delivered source/prose is English ASCII. Notebook mathematical notation uses native Wolfram boxes. The editable cell schema and box cache are under Tools; rebuild with Python 3 Tools/build_notebook.py, regenerating native boxes with Tools/MakeInputBoxes.wl when input source changes.

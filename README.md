# xPlorer

[![License: GPL-3.0-or-later](https://img.shields.io/badge/License-GPL--3.0--or--later-blue.svg)](LICENSE)

> **Development candidate: 14.0.0-beta.13-dev.32.** Selective consolidation of registration dev.30 and native-integration dev.16. This branch is not a public release. See [BETA13_CONSOLIDATION.md](BETA13_CONSOLIDATION.md) for scope and validation.

xPlorer is a Wolfram Language package for reusing an abstract xAct theory on independent metric backgrounds, inspecting formal tensors and calculating components without rebuilding the theory each time.

xPlorer keeps the existing native registration API and background snapshots. Dev.32 fixes native Print recursion in dev.31 without changing the mathematical API. Dev.31 retains dev.30's managed component engine and integrates native coordinate declarations, registered basis transformations, unary ToCTensor, independent rules and structured background inspection.

## Start here

Start with [xPlorer_Workflow.nb](xPlorer_Workflow.nb), the principal scientific tutorial, updated to the consolidated dev.31 API. Keep it beside the [Paclet](Paclet/) directory, install xAct, start a fresh Mathematica kernel and evaluate the notebook in order. [xPlorer_Consolidated.nb](xPlorer_Consolidated.nb) is a supplementary integration-test notebook, not a second principal guide. Choose one of its two startup cells. For source use:

```wl
Get[FileNameJoin[{NotebookDirectory[], "Paclet", "xPlorer.wl"}]];
```

The principal notebook develops a scalar theory on Minkowski, Schwarzschild and FLRW, then introduces vectors, tensors, an independent affine connection, perturbations and cleanup. It contains 381 executable input cells, including two alternative startup cells (choose only one), with explanatory prose beside the calculations. The stylesheet inherits light/dark theme colors. The updated notebook was executed end to end using both Get and Needs from a development paclet directory (380/380 inputs, 94/94 mathematical checks and 33/33 stages each). ScalarTheory.wl is an optional reusable source recipe; it is not required to run the notebook.

## Features

- Independent xAct manifolds, metrics, connections, indices and field copies from a registered theory snapshot.
- Formal expression transport before introducing coordinates, then xCoba component calculations with explicit tensor axes and component selection.
- Native PrintAs inheritance, optional local labels, readable internal heads and safe interpreted views via `expr // PrettyExp`.
- Optional named field profiles and native `CTensor` output with basis and slot variance; ordinary arrays remain the default.
- Native scalar-coordinate declarations, native chart-to-chart basis changes, and scoped primary-chart input capture. Arbitrary external native edits are not automatically synchronized.
- Automatic notebook-context aliases for background objects and indices, e.g. `gSchw`, `CDSchw`, `phiSchw` and `aSchw` after `CreateBackground["Schwarzschild", SymbolSuffix -> "Schw"]`. Occupied names are preserved; `BackgroundObject` remains available for explicit lookup.
- Named additional connections with their own curvature families and supplied coefficients or differences from the primary derivative.
- Scoped rules, selective removal, named particularizations and conservative invalidation of saved results.
- Separate value clearing, registration removal and true dependency-aware deletion of owned fields, charts, connections, metric families or whole backgrounds.

Current evidence is recorded in [BETA13_CONSOLIDATION.md](BETA13_CONSOLIDATION.md); historical checkpoints below refer to their respective versions. Desktop appearance, archive build and installation still require verification.

See [API_GUIDE.md](API_GUIDE.md), the [Proca example](Examples/Beta13_Proca.wl) and [native xCoba example](Examples/NativeXCoba.wl). [VALIDATION.md](VALIDATION.md) is a historical beta.7 record; current evidence and limitations are in [BETA13_PROGRESS.md](BETA13_PROGRESS.md) and [BETA13_PLAN.md](BETA13_PLAN.md).

## Installation and development

### Install as a Mathematica application

Download and extract the complete repository, with xAct already installed. In a fresh Mathematica kernel:

```wl
Get["/absolute/path/to/xPlorer/Install.wl"];
InstallXPlorer[]
```

The installer copies the package, loaders, license and citation metadata to `$UserBaseDirectory/Applications/xPlorer`. It refuses to overwrite an existing installation; move the old application to a backup outside Applications before replacing it. Restart the kernel, then in any notebook:

```wl
Needs["xPlorer`"];
$XPlorerVersion
```

The notebook still supports its standalone Get startup. For installed usage, evaluate the alternative Needs startup cell instead of Get.

### Paclet development and distribution

```wl
PacletDirectoryLoad["/absolute/path/to/xPlorer/Paclet"];
Needs["xPlorer`"];
```

Open [xPlorer_Install.nb](xPlorer_Install.nb) in Mathematica Desktop for the separate build, installation, verification and optional uninstallation steps. Evaluate only the required cells, not the whole notebook. The uninstall section requests confirmation. To build and install manually, evaluate:

```wl
build = Get[FileNameJoin[{NotebookDirectory[], "Tools", "BuildPaclet.wl"}]];
If[MatchQ[build, _Success], PacletInstall[build["PacletArchive"]]]
```

The builder calls the native `CreatePacletArchive[source, out]` directly on the prepared `Paclet/` directory, with `build/` as the output directory. This avoids PacletBuild's redundant staging copies, which failed on the author's Windows kernel. The author reports successful Desktop archive construction; the actual archive has not yet been inspected, installed or uninstalled as part of this verification. For future releases, distribute the verified archive as a GitHub Release asset so users do not need to build it themselves. No beta.13 release has been published. The remote kernel has a Java restriction on producing a real archive; Desktop verification remains necessary. Do not keep both a conflicting traditional installation and a paclet active.

### Inspect the registered theory

```wl
ShowTheory[]
ShowTheory["Lagrangians"]
ShowTheoryKeys[]
TheoryValue["Lagrangians", "Lagrangian"]
```

ShowTheory is a read-only native Grid/Column presentation. TheoryValue retrieves usable values. TheorySnapshot[] is the optional raw association for restoration; existing backgrounds capture their own theory automatically. BackgroundObject, automatic suffixed symbols and qualified expression lookup are unchanged. xAct is installed separately and is not bundled.

- [Current consolidation plan](BETA13_PLAN.md)
- [Historical development plan](DEVELOPMENT_PLAN.md)
- [Design decisions](DECISIONS.md)
- [Current beta.13 recovery checkpoint](BETA13_PROGRESS.md)
- [Implementation/resumption instruction](IMPLEMENTATION_PROMPT.md)
- [Tests](Tests/) and [historical notebook build sources](Tools/)

Each important validated stage is preserved in Git history. Read BETA13_PROGRESS.md before continuing work so completed stages are not repeated.

## Author and citation

Developed by **Eduardo Sanz-Romero** ([PhysEdu](https://github.com/physedu)) as a reusable research tool for moving from formal theories to concrete background calculations.

If you use xPlorer in your research, please cite the version used. GitHub's **Cite this repository** option reads [CITATION.cff](CITATION.cff).

```bibtex
@software{sanz_romero_xplorer_2026,
  author  = {Sanz-Romero, Eduardo},
  title   = {xPlorer},
  year    = {2026},
  version = {14.0.0-beta.13-dev.32},
  url     = {https://github.com/physedu/xPlorer}
}
```

Please also cite the relevant xAct packages independently. Their documentation and citation guidance are available through the [xAct project](https://www.xact.es/).

## Acknowledgements

I thank Gonzalo J. Olmo for motivating the research problem of particularizing abstract theories on different metric backgrounds, and acknowledge the research context of the [Grupo de Gravedad y Campos](http://uv-qg.es/).

I also acknowledge José M. Martín-García and the developers of xAct, including the authors of xTensor, xCoba and xPert, whose work makes xPlorer possible.

## License

Copyright (C) 2026 Eduardo Sanz-Romero (PhysEdu).

xPlorer is released under the GNU General Public License, version 3 or (at your option) any later version (**GPL-3.0-or-later**). See [LICENSE](LICENSE) for the full license text. xAct is a separately installed dependency with its own license and copyright notices.

xTensor supplies abstract tensor calculus, xPert supplies perturbative expansions, and xCoba supplies bases and components. Xplorer organizes and connects these operations; it does not replace their mathematics or solve boundary conditions automatically.

## References and help

- xAct project: https://www.xact.es/
- xAct documentation: https://josmar493.dreamhosters.com/
- xAct discussion group: https://groups.google.com/g/xAct
- Wolfram paclet layout: https://reference.wolfram.com/language/tutorial/Paclets.html

### Repository layout

- `Paclet/`: the single package implementation, paclet metadata, kernel loaders, license and citation information.
- `Tests/`: automated mathematical and API regressions, notebook runner and historical reports.
- `Examples/`: independent scientific examples, including Proca and native xCoba interoperability.
- `Tools/`: build script and historical notebook-generation utilities.
- `build/`: generated local archives (ignored by Git; created when building).
- `xPlorer_Workflow.nb` and `xPlorer_Install.nb`: scientific tutorial and installation guide.

The root `xPlorer.m` is a compatibility loader, not a second implementation. Root license and citation metadata are retained for GitHub; identical copies are included in the distributable folder.

### Inferred component evaluation and theory information

An owned expression has a unique background: `EabSchw // ToComponents // MatrixForm`. The explicit `ToComponents["Schwarzschild", Eab]` remains necessary for abstract expressions. Ambiguous or owner-free expressions require an explicit tag. Options work with either form, including `EabSchw // ToComponents[Output -> "CTensor"]`. Register optional Title, Description, Assumptions and Conditions individually; they document the theory, not automatic simplification assumptions. Sector overviews show both counts and registered keys.

The dev.14 lifecycle tutorial passed 363/363 selected input cells, 82/82 mathematical checks and 33/33 stages. Object/connection lifecycle tests passed 45/45 and reconstruction 9/9. Selective deletion restores surviving managed metric, field and connection inputs. ClearComputedValues propagates replay failures. See BETA13_PROGRESS.md for limitations.

### Extending an existing study (dev.15)

`AddField[tag, source]` copies a registered source field into an existing background without rebuilding its geometry. `SetFieldComponents[ownedTensorExpression, values]` infers the owner, variance and perturbation label, using the primary chart. `expr // PerturbOn[n] // ToComponents` selects the local xPert parameter and computes the nth variation. The explicit forms remain available. See `Examples/EinsteinScalar.wl` for optional xTras action variation (run in a fresh kernel). xTras is not a mandatory dependency. Dev.15: 365/365 selected tutorial inputs, 84/84 mathematical checks, 33/33 stages; 12/12 focused checks of field addition, inference and reconstruction, and 6/6 Einstein-scalar checks.

### Reconstruction and verification (dev.16)

Managed recipes now preserve customized abstract index labels and rebind recorded secondary-chart coordinates and chart identities. No new scientific API was introduced. Native edits remain outside managed replay unless explicitly recorded with existing setters.

The exact dev.16 source checkpoint passed the 365-cell workflow, 84 mathematical checks, 33 stages, all eight historical regression groups, the registration/inspection/native/profile groups, and the optional Einstein-scalar example. The additional FieldExtensions and SecondaryChartNative groups passed 16/16 and 3/3. See [Tests/dev16-results.json](Tests/dev16-results.json) for commit-specific evidence.

For targeted tests, start a fresh kernel per group:

```wl
$XPlorerTestGroup = "FieldExtensions";
Get["/path/to/xPlorer/Tests/RunGroup.wl"]
```

The runner supports the existing historical groups and the new standalone groups. The traditional application and development-directory Needs paths were verified; actual paclet archive compression still fails remotely due to Java security restrictions. The Desktop notebook appearance and archive installation/uninstallation must be verified locally. Primary-chart promotion remains a design task, not a supported operation.

### Integrated native xCoba syntax (dev.18)

```wl
MetricInBasis[gSchw, matrix];
ComponentValue[phiSchw[], profile];
AllComponentValues[ASchw[-aSchw], array];
scalarEqSchw // ToComponents
```

The extensions use native xCoba storage and transformations. Scalar and complete primary-chart field inputs are captured automatically within the documented scope. Requested variance configurations are prepared on demand and reused; ToValues can read them directly. The original native definitions are retained; one conditional ToValues rule covers compound reads. See the [API guide](API_GUIDE.md#integrated-native-xcoba-operations-dev18) for exact boundaries. Existing setters remain available. No change to archive construction or xTras dependency.

### Native geometry cache coherence (dev.19)

Native `MetricCompute[g, chart, target]` (and explicit zero torsion) on a managed primary chart retains native return values and records available geometry coverage. If a previously computed tensor rule group is deleted, the corresponding xCoba pointer-cache entry is invalidated so the next requested computation restores it without clearing unrelated geometry. The implementation uses xCoba 1.3.0's internal native cache-key helpers. Secondary charts and nonzero torsion remain native-only.

### On-demand native geometry reads (dev.20)

With a managed primary-chart metric, native ToValues, ComponentValue and AllComponentValues can prepare a requested standard xCoba geometry configuration, including a scalar, when its rules are absent or incomplete. Complete rules are reused; unrequested geometry is not computed beyond xCoba's native dependencies. Raw TensorValues remains introspection only. Native tensor algebra and abstract reads are unchanged. Alternative geometry variances and secondary charts are outside this checkpoint.

### Selective field invalidation (dev.21)

When a managed metric changes, complete recorded field source groups whose native fingerprints still match are retained without reinstalling them. Other native rule groups for those fields are invalidated and recomputed only when requested. Repeated identical managed field assignments skip replay if the source is unchanged. LI labels are included in source and derived variance fingerprints, preserving distinct perturbation orders. Missing/changed native sources still trigger the conservative managed replay. Exact repeat metric assignment and independent connection/derivative optimizations remain separate work.

### Metric component edits and exact-repeat metric inputs (dev.22)

Native `ComponentValue` can edit a component of a complete managed covariant or contravariant metric in its primary chart. A locally staged native assignment is validated before installation; invalid metric data are rejected without overwriting the original metric rules. An exact repeated managed metric assignment with matching native fingerprints retains existing geometry and revisions. The native inverse is prepared only when needed. Identically vanishing tensors retain their native zero behavior without component hooks.

### Lazy geometry variance and imploded derivatives (dev.23)

Native readers prepare nonstandard primary-chart geometry variances with xCoba ChangeComponents from an available standard native configuration. Repeated reads reuse matching fingerprints. Metric changes clear native imploded metric/curvature derivative rules as well as ordinary geometry rules, retaining their tensor definitions. Defined native imploded derivative heads are included in primary-chart lazy reads. This is not a general derivative or secondary-chart synchronization engine.

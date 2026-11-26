# xPlorer

[![License: GPL-3.0-or-later](https://img.shields.io/badge/License-GPL--3.0--or--later-blue.svg)](LICENSE)

> **Development branch: 14.0.0-beta.13-dev.6.** The new registration API is breaking. The original 115-input author notebook and historical regression suite have been migrated and tested in a real Wolfram Language kernel. See [BETA13_PROGRESS.md](BETA13_PROGRESS.md) for exact test evidence, [targeted tests](Tests/13_Registration.wl), and a [worked Proca example](Examples/Beta13_Proca.wl). Main remains beta.12. Do not treat this branch as a release.

xPlorer is a Wolfram Language package for reusing an abstract xAct theory on independent metric backgrounds, inspecting formal tensors and calculating components without rebuilding the theory each time.

The current experimental version is **14.0.0-beta.13-dev.6** (validated API consolidation, native interop, profiles and CTensor output). Dev.6 is the latest tested checkpoint. See [API_AUDIT.md](API_AUDIT.md). The preserved baseline on main is beta.12. The notebook can run with Get; an installed application is loaded using Needs. Theory registration and tagged background creation are unchanged. Personalization is optional.

## Start here

Keep [xPlorer_Workflow.nb](xPlorer_Workflow.nb) beside [xPlorer.wl](xPlorer.wl), install xAct, start a fresh Mathematica kernel and evaluate the notebook in order. Its startup is simply:

```wl
Get[FileNameJoin[{NotebookDirectory[], "xPlorer.wl"}]];
```

The principal notebook develops a scalar theory on Minkowski, Schwarzschild and FLRW, then introduces vectors, tensors, an independent affine connection, perturbations and cleanup. It contains 119 executable input cells, with explanatory prose beside the calculations. The stylesheet inherits light/dark theme colors. ScalarTheory.wl is an optional reusable source recipe; it is not required to run the notebook.

## Features

- Independent xAct manifolds, metrics, connections, indices and field copies from a registered theory snapshot.
- Formal expression transport before introducing coordinates, then xCoba component calculations with explicit tensor axes and component selection.
- Native PrintAs inheritance, optional local labels, readable internal heads and safe interpreted views via `expr // PrettyExp`.
- Optional named field profiles and native `CTensor` output with basis and slot variance; ordinary arrays remain the default.
- Native chart and basis interoperability verified without duplicating xCoba basis machinery. Native edits are not automatically synchronized with managed data.
- Automatic notebook-context aliases for background objects and indices, e.g. `gSchw`, `CDSchw`, `phiSchw` and `aSchw` after `CreateBackground["Schwarzschild", SymbolSuffix -> "Schw"]`. Occupied names are preserved; `BackgroundObject` remains available for explicit lookup.
- Named additional connections with their own curvature families and supplied coefficients or differences from the primary derivative.
- Scoped rules, selective removal, named particularizations and conservative invalidation of saved results.
- Separate value clearing, registration removal and true dependency-aware deletion of owned fields, charts, connections, metric families or whole backgrounds.

The principal notebook has passed 119/119 input executions, 66/66 expected-result checks and 7/7 workflow-order checks on dev.6. All eight historical groups passed (288 assertion executions including repeated core checks); registration 45/45, inspection 23/23, native interop 20/20, profiles and CTensor 33/33. The front-end appearance and actual .paclet archive/install remain unverified. The 88-input legacy build source is not the current notebook.

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

The notebook still supports its standalone Get startup. For installed usage, replace its first Get cell with Needs.

### Paclet development and distribution

```wl
PacletDirectoryLoad["/absolute/path/to/xPlorer"];
Needs["xPlorer`"];
```

For a distributable archive, run Tools/BuildPaclet.wl on Mathematica Desktop. Install the resulting .paclet using PacletInstall[path]. The dev.3 staging directory and Needs loading have been verified, including package source, license and citation assets. Actual archive creation was blocked by the remote kernel's Java security policy; Desktop archive installation has not yet been validated. Do not keep both a conflicting traditional installation and a paclet active.

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
  version = {14.0.0-beta.13-dev.6},
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

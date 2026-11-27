# xPlorer

[![License: GPL-3.0-or-later](https://img.shields.io/badge/License-GPL--3.0--or--later-blue.svg)](LICENSE)

**First public beta candidate: 1.0.0-beta.1.** The public beta release has not yet been published.

xPlorer is a Wolfram Language research package for theoretical physics and general relativity, built on xAct. It addresses a practical problem: after deriving tensor equations on an abstract manifold, how can the same theory be studied on different metrics, coordinate charts and field configurations without redefining all the tensors or restarting the Mathematica kernel?

With xPlorer, register the abstract theory once, create independent backgrounds, and assign concrete metric and field components. The same equations can then be transported and evaluated on Minkowski, Schwarzschild, FLRW or other user-defined geometries in the same session. Each study has its own native xAct objects and managed component inputs.

xPlorer is not a new tensor algebra engine. It uses xTensor, xCoba and xPert for the mathematics and provides the management layer connecting abstract derivations to concrete calculations. Native xAct operations remain available on the copied objects.

### What can you do with xPlorer?

- Reuse registered tensors, Lagrangians and equations on independent spacetimes.
- Calculate components of tensor equations, curvature and new observables using xCoba.
- Explore physical limits, change scalar/vector/tensor profiles, and evaluate in registered secondary coordinate charts.
- Compute metric perturbations using xPert, including inverse metric variations and their components.
- Modify or reconstruct a model without restarting the kernel; inspect declared inputs and customize mathematical notation.

The intended audience is researchers and students already using Mathematica and xAct, particularly those comparing geometric backgrounds or specializing abstract field equations. This is experimental research software; feedback and reproducible bug reports are welcome.

## Start here

| Notebook | Purpose |
| --- | --- |
| [xPlorer_Install.nb](xPlorer_Install.nb) | Install, verify and uninstall the supplied paclet. |
| [xPlorer_Workflow.nb](xPlorer_Workflow.nb) | Start here: a five-section tutorial: Einstein-scalar theory, registration and notation, scalar/vector/tensor components, metric perturbations on Minkowski and FLRW, and reusable profiles and charts. |
| [xPlorer_API_Examples.nb](xPlorer_API_Examples.nb) | Advanced executable reference: detailed API options, affine connections, lifecycle and special cases. |

Install [xAct](https://www.xact.es/) separately. Use a fresh Mathematica kernel for either notebook. Keep the notebook beside xPlorer.wl in the release ZIP, or beside the Paclet directory in a repository checkout. Use xPlorer_Install.nb for installation or removal; the scientific notebooks use Needs or Get.

```wl
Get[FileNameJoin[{NotebookDirectory[], "Paclet", "xPlorer.wl"}]];
$XPlorerVersion
```

The declared minimum Mathematica version is 13.0; current automated checks use Wolfram 15.0.1 and xAct 1.3.0. Earlier kernel versions have not all been tested. The notebooks ship without precomputed results.

## Main workflow

```wl
RegisterTheory["Metric", g];
RegisterTheory["CovD", CD];
RegisterTheory["Indices", {a,b,c,d,e,f,i,j}];
RegisterTheory["Field", phi];
RegisterTheory["Expression", "KG" -> kg];

CreateBackground["Schwarzschild", SymbolSuffix -> "Schw"];
DefineChart["Schwarzschild", {t[],r[],theta[],varphi[]}];

MetricInBasis[gSchw, matrix];
ComponentValue[phiSchw[], u[rSchw[]]];
kgSchw // ToComponents
```

Here the source metric, derivative, field and equation must already be defined with xAct; matrix and u must be supplied by the user. The main Workflow contains all these definitions. Owned fields and charts can use native xCoba assignments, with managed primary-chart capture and native basis transformations. Unknown components stay unknown. Named rules and profiles allow exploration without recreating the geometry.

## Inspect your models

```wl
ShowBackground[]
ShowBackground["Schwarzschild"]
ShowBackground["Schwarzschild", "Fields"]
```

The first call lists the studies in the current kernel; the others show the declared geometry, actual managed input values or a selected section. No new geometry is computed. Use BackgroundValue["Schwarzschild", "MetricMatrix"] for programmatic data access, or BackgroundObject for native xAct heads. 

## Optional presentation

```wl
SetXPlorerPreferences[ShowObjectLabels -> True, PartialStyle -> "Fraction"];
SetNotation["Schwarzschild", BackgroundLabel -> "S"];
SetPresentation["Schwarzschild", phi, ShowObjectLabels -> False];
kgSchw // PrettyExp[ShowObjectLabels -> True]
```

Visual labels are separate from typed names. Labels are off by default; session, background, chart, object and one-expression settings do not change the mathematics. Registration remains independent of object-label visibility. For detailed syntax, see the [API guide](API_GUIDE.md).

## Installation

The public release will supply a matching .paclet and a compact distribution ZIP with the three notebooks, source, README, license and citation. The release ZIP contains xPlorer.wl at its root; the repository source remains in Paclet/xPlorer.wl. To use a supplied local paclet, run PacletInstall with its path, restart the kernel, then:

```wl
Needs["xPlorer`"];
$XPlorerVersion
```

Do not mix conflicting traditional applications and paclets. If you tested the internal 14.0.0-beta.* series, uninstall those higher-numbered versions before installing public beta 1. The traditional installer [Install.wl](Install.wl) is available for development/source use. It refuses to overwrite an existing application. See [xPlorer_Install.nb](xPlorer_Install.nb) for installation and removal; use Tools/BuildPaclet.wl for archive construction. xAct is a separate dependency; optional xTras is not required.

## Feedback and scope

Report reproducible problems in [GitHub Issues](https://github.com/physedu/xPlorer/issues), including xPlorer, Mathematica and xAct versions, OS, smallest input and expected versus actual output. Presentation issues benefit from a screenshot.

The managed scope includes abstract tangent-bundle tensors, perturbations and named connections, native primary-chart inputs and registered secondary maps. Arbitrary external native edits, general spinors and arbitrary bundles, primary chart promotion and general foreign-basis replay are not part of this beta. Mathematical assumptions and chart domains remain the user's responsibility.

## Development

The public distribution is intentionally different from this repository's development tree. [Release/README.md](Release/README.md) is the tester-facing README; [Tools/PrepareRelease.wl](Tools/PrepareRelease.wl) stages a whitelist of source, local source-matching archive, notebooks, license and citation. It does not publish to GitHub. See [Release preparation](Development/RELEASE_CHECKLIST.md).

- [API guide](API_GUIDE.md) and [design decisions](Development/DECISIONS.md).
- [Consolidation and validation](Development/BETA13_CONSOLIDATION.md), [development progress](Development/BETA13_PROGRESS.md), [plan](Development/BETA13_PLAN.md), [implementation instructions](Development/IMPLEMENTATION_PROMPT.md).
- Tests/, Tools/, Examples/, and the internal xPlorer_Consolidated.nb and historical xPlorer_QuickStart.nb are development material, not public distribution contents. Historical checkpoints are preserved in Git history. See [development history and version transition](Development/DEVELOPMENT_HISTORY.md) for the mapping from internal versions to public beta 1.

## Author, citation and license

Developed by **Eduardo Sanz-Romero** ([PhysEdu](https://github.com/physedu)). Cite the exact version using [CITATION.cff](CITATION.cff) and cite the relevant xAct packages separately.

I thank Gonzalo J. Olmo for motivating the research problem of particularizing abstract theories on different metric backgrounds, and acknowledge the research context of the [Grupo de Gravedad y Campos](http://uv-qg.es/). I also acknowledge Jose M. Martin-Garcia and the developers of xTensor, xCoba and xPert.

Copyright (C) 2026 Eduardo Sanz-Romero. Distributed under GPL-3.0-or-later; see [LICENSE](LICENSE). No warranty. xAct is a separately installed dependency with its own license.

Further help: [xAct project](https://www.xact.es/), [xAct documentation](https://josmar493.dreamhosters.com/), [xAct discussion group](https://groups.google.com/g/xAct).

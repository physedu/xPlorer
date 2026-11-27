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
| [xPlorer_Workflow.nb](xPlorer_Workflow.nb) | Start here: a practical seven-section research tutorial, from abstract equations to components, profiles, tensors and metric perturbations. |
| [xPlorer_API_Examples.nb](xPlorer_API_Examples.nb) | Advanced executable reference: detailed API options, affine connections, lifecycle and special cases. |

Install [xAct](https://www.xact.es/) separately. Use a fresh Mathematica kernel for either notebook. Keep the notebook beside xPlorer.wl in the release ZIP, or beside the Paclet directory in a repository checkout. Choose exactly one startup cell: A installs the matching released paclet if needed and loads it with Needs; B loads the source directly using Get. The distribution ZIP places the versioned paclet and plain xPlorer.wl beside both notebooks.

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

The public release will supply a matching .paclet and a compact distribution ZIP with the two notebooks, source, README, license and citation. The release ZIP contains xPlorer.wl at its root; the repository source remains in Paclet/xPlorer.wl. To use a supplied local paclet, run PacletInstall with its path, restart the kernel, then:

```wl
Needs["xPlorer`"];
$XPlorerVersion
```

Do not mix conflicting traditional applications and paclets. If you tested the internal 14.0.0-beta.* series, uninstall those higher-numbered versions before installing public beta 1. The traditional installer [Install.wl](Install.wl) is available for development/source use. It refuses to overwrite an existing application. See [xPlorer_Install.nb](xPlorer_Install.nb) for local archive construction and installation. xAct is a separate dependency; optional xTras is not required.

## Feedback and scope

Report reproducible problems in [GitHub Issues](https://github.com/physedu/xPlorer/issues), including xPlorer, Mathematica and xAct versions, OS, smallest input and expected versus actual output. Presentation issues benefit from a screenshot.

The managed scope includes abstract tangent-bundle tensors, perturbations and named connections, native primary-chart inputs and registered secondary maps. Arbitrary external native edits, general spinors and arbitrary bundles, primary chart promotion and general foreign-basis replay are not part of this beta. Mathematical assumptions and chart domains remain the user's responsibility.

## Validation and source development

See [VALIDATION.md](VALIDATION.md) for the exact tested revision, environment and remaining acceptance checks. The [Tests/](Tests/) directory contains executable regression and notebook tests. [Tools/](Tools/) contains the paclet and curated ZIP build helpers; the user-facing distribution contains only the two notebooks, source, paclet, README, license and citation.

The complete internal development record is preserved on the [develop branch](https://github.com/physedu/xPlorer/tree/59030c6df0ad282b18b279ae620bf6ec215e8206/Development). See [CHANGELOG.md](CHANGELOG.md) for public version history. The first public beta is pending local archive and Desktop acceptance.

## Author, citation and license

Developed by **Eduardo Sanz-Romero** ([PhysEdu](https://github.com/physedu)). Cite the exact version using [CITATION.cff](CITATION.cff) and cite the relevant xAct packages separately.

I thank Gonzalo J. Olmo for motivating the research problem of particularizing abstract theories on different metric backgrounds, and acknowledge the research context of the [Grupo de Gravedad y Campos](http://uv-qg.es/). I also acknowledge Jose M. Martin-Garcia and the developers of xTensor, xCoba and xPert.

Copyright (C) 2026 Eduardo Sanz-Romero. Distributed under GPL-3.0-or-later; see [LICENSE](LICENSE). No warranty. xAct is a separately installed dependency with its own license.

Further help: [xAct project](https://www.xact.es/), [xAct documentation](https://josmar493.dreamhosters.com/), [xAct discussion group](https://groups.google.com/g/xAct).

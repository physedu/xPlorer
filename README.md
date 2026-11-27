# xPlorer

[![License: GPL-3.0-or-later](https://img.shields.io/badge/License-GPL--3.0--or--later-blue.svg)](LICENSE)

**Development candidate: 14.0.0-beta.13-dev.36.** The public beta release has not yet been published.

xPlorer is a Wolfram Language research package that reuses an abstract xAct theory on independent geometric backgrounds, transports equations and calculates components. It connects xTensor, xCoba and xPert rather than replacing their mathematics.

## Start here

| Notebook | Purpose |
| --- | --- |
| [xPlorer_QuickStart.nb](xPlorer_QuickStart.nb) | First scientific calculation: massive scalar theory, Minkowski, Schwarzschild and FLRW. |
| [xPlorer_Workflow.nb](xPlorer_Workflow.nb) | Full scientific reference: registration, abstract formulas, notation, specialization, charts, vector/tensor fields, affine connections, perturbations and lifecycle. |

Install [xAct](https://www.xact.es/) separately. Use a fresh Mathematica kernel for either notebook. Keep the notebook beside the Paclet directory. Choose exactly one startup cell: A installs the matching released paclet if needed and loads it with Needs; B loads the source directly using Get. The distribution ZIP places the versioned paclet beside both notebooks.

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

Here the source metric, derivative, field and equation must already be defined with xAct; matrix and u must be supplied by the user. The Quick Start contains all these definitions. Owned fields and charts can use native xCoba assignments, with managed primary-chart capture and native basis transformations. Unknown components stay unknown. Named rules and profiles allow exploration without recreating the geometry.

## Inspect your models

```wl
ShowBackground[]
ShowBackground["Schwarzschild"]
ShowBackground["Schwarzschild", "Fields"]
```

The first call lists the studies in the current kernel; the others show the declared geometry, actual managed input values or a selected section. No new geometry is computed. Use BackgroundValue["Schwarzschild", "MetricMatrix"] for programmatic data access, or BackgroundObject for native xAct heads. In dev.35, use BackgroundValue instead of the former raw ShowBackground association.

## Optional presentation

```wl
SetXPlorerPreferences[ShowObjectLabels -> True, PartialStyle -> "Fraction"];
SetNotation["Schwarzschild", BackgroundLabel -> "S"];
SetPresentation["Schwarzschild", phi, ShowObjectLabels -> False];
kgSchw // PrettyExp[ShowObjectLabels -> True]
```

Visual labels are separate from typed names. Labels are off by default; session, background, chart, object and one-expression settings do not change the mathematics. Registration remains independent of object-label visibility. For detailed syntax, see the [API guide](API_GUIDE.md).

## Installation

The public release will supply a matching .paclet and a compact distribution ZIP with the two notebooks, source, README, license and citation. The package source remains available in Paclet/xPlorer.wl. To use a supplied local paclet, run PacletInstall with its path, restart the kernel, then:

```wl
Needs["xPlorer`"];
$XPlorerVersion
```

Do not mix conflicting traditional applications and paclets. The traditional installer [Install.wl](Install.wl) is available for development/source use. It refuses to overwrite an existing application. See [xPlorer_Install.nb](xPlorer_Install.nb) for local archive construction and installation. xAct is a separate dependency; optional xTras is not required.

## Feedback and scope

Report reproducible problems in [GitHub Issues](https://github.com/physedu/xPlorer/issues), including xPlorer, Mathematica and xAct versions, OS, smallest input and expected versus actual output. Presentation issues benefit from a screenshot.

The managed scope includes abstract tangent-bundle tensors, perturbations and named connections, native primary-chart inputs and registered secondary maps. Arbitrary external native edits, general spinors and arbitrary bundles, primary chart promotion and general foreign-basis replay are not part of this beta. Mathematical assumptions and chart domains remain the user's responsibility.

## Development

The public distribution is intentionally different from this repository's development tree. [Release/README.md](Release/README.md) is the tester-facing README; [Tools/PrepareRelease.wl](Tools/PrepareRelease.wl) stages a whitelist of source, local source-matching archive, notebooks, license and citation. It does not publish to GitHub. See [Release preparation](RELEASE_CHECKLIST.md).

- [API guide](API_GUIDE.md) and [design decisions](DECISIONS.md).
- [Consolidation and validation](BETA13_CONSOLIDATION.md), [development progress](BETA13_PROGRESS.md), [plan](BETA13_PLAN.md), [implementation instructions](IMPLEMENTATION_PROMPT.md).
- Tests/, Tools/, Examples/, and the internal xPlorer_Consolidated.nb are development material, not public distribution contents. Historical checkpoints are preserved in Git history.

## Author, citation and license

Developed by **Eduardo Sanz-Romero** ([PhysEdu](https://github.com/physedu)). Cite the exact version using [CITATION.cff](CITATION.cff) and cite the relevant xAct packages separately.

I thank Gonzalo J. Olmo for motivating the research problem of particularizing abstract theories on different metric backgrounds, and acknowledge the research context of the [Grupo de Gravedad y Campos](http://uv-qg.es/). I also acknowledge Jose M. Martin-Garcia and the developers of xTensor, xCoba and xPert.

Copyright (C) 2026 Eduardo Sanz-Romero. Distributed under GPL-3.0-or-later; see [LICENSE](LICENSE). No warranty. xAct is a separately installed dependency with its own license.

Further help: [xAct project](https://www.xact.es/), [xAct documentation](https://josmar493.dreamhosters.com/), [xAct discussion group](https://groups.google.com/g/xAct).

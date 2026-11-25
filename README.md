# xPlorer

> **Development branch: 14.0.0-beta.13-dev.2.** The new registration API is breaking; the beta.12 notebook and most legacy documentation below have not yet been migrated. See [BETA13_PROGRESS.md](BETA13_PROGRESS.md) for exact test evidence, [targeted tests](Tests/13_Registration.wl), and a [worked Proca example](Examples/Beta13_Proca.wl). Main remains beta.12. Do not treat this branch as a release.

xPlorer is a Wolfram Language package for reusing an abstract xAct theory on independent metric backgrounds, inspecting formal tensors and calculating components without rebuilding the theory each time.

The stable baseline described below is **14.0.0-beta.12**. The default workflow remains a normal Get, theory registration and tagged background creation. Personalization is optional.

## Start here

Keep [xPlorer_Workflow.nb](xPlorer_Workflow.nb) beside [xPlorer.wl](xPlorer.wl), install xAct, start a fresh Mathematica kernel and evaluate the notebook in order. Its startup is simply:

```wl
Get[FileNameJoin[{NotebookDirectory[], "xPlorer.wl"}]];
```

The principal notebook develops a scalar theory on Minkowski, Schwarzschild and FLRW, then introduces vectors, tensors, an independent affine connection, perturbations and cleanup. It contains 115 executable input cells, with explanatory prose beside the calculations. The stylesheet inherits light/dark theme colors. ScalarTheory.wl is an optional reusable source recipe; it is not required to run the notebook.

## Features

- Independent xAct manifolds, metrics, connections, indices and field copies from a registered theory snapshot.
- Formal expression transport before introducing coordinates, then xCoba component calculations with explicit tensor axes and component selection.
- Native PrintAs inheritance, optional local labels, readable internal heads and reversible derivative views.
- Automatic notebook-context aliases for background objects and indices, e.g. `gSchw`, `CDSchw`, `phiSchw` and `aSchw` after `CreateBackground["Schwarzschild", SymbolSuffix -> "Schw"]`. Occupied names are preserved; `BackgroundObject` remains available for explicit lookup.
- Named additional connections with their own curvature families and supplied coefficients or differences from the primary derivative.
- Scoped rules, selective removal, named particularizations and conservative invalidation of saved results.
- Separate value clearing, registration removal and true dependency-aware deletion of owned fields, charts, connections, metric families or whole backgrounds.

The package and principal notebook were updated from the beta.12 author-supplied files on 25 November 2026. The remaining development documentation, optional loaders and test/build sources have not been revalidated against this snapshot.

See [API_GUIDE.md](API_GUIDE.md) for examples and supported configurations. This beta does not implement every xAct option. See [VALIDATION.md](VALIDATION.md) for actual execution evidence and limitations; mathematical checks do not imply front-end screenshot verification or measured speedups.

## Installation and development

Direct Get needs no installation. The repository also contains a traditional application loader and PacletInfo.wl. See the installation section in API_GUIDE.md for Needs and development paclet loading. xAct is installed separately and is not bundled.

- [Development plan](DEVELOPMENT_PLAN.md)
- [Design decisions](DECISIONS.md)
- [Current recovery checkpoint](PROGRESS.md)
- [Implementation/resumption instruction](IMPLEMENTATION_PROMPT.md)
- [Tests](Tests/) and [notebook build sources](Tools/)

Each important validated stage is preserved in Git history. Read PROGRESS.md before continuing work so completed stages are not repeated.

## Background and author

Developed by **Eduardo Sanz Romero**, in the context of research with Gonzalo J. Olmo and the Grupo de Gravedad y Campos: http://uv-qg.es/ . The goal is a reusable research tool for moving from formal theories to concrete background calculations.

xTensor supplies abstract tensor calculus, xPert supplies perturbative expansions, and xCoba supplies bases and components. Xplorer organizes and connects these operations; it does not replace their mathematics or solve boundary conditions automatically.

## References and help

- xAct project: https://www.xact.es/
- xAct documentation: https://josmar493.dreamhosters.com/
- xAct discussion group: https://groups.google.com/g/xAct
- Wolfram paclet layout: https://reference.wolfram.com/language/tutorial/Paclets.html

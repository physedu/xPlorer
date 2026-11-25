# xPlorer

> **Development branch: 14.0.0-beta.13-dev.2.** The new registration API is breaking. The original 115-input author notebook and historical regression suite have been migrated and tested in a real Wolfram Language kernel. See [BETA13_PROGRESS.md](BETA13_PROGRESS.md) for exact test evidence, [targeted tests](Tests/13_Registration.wl), and a [worked Proca example](Examples/Beta13_Proca.wl). Main remains beta.12. Do not treat this branch as a release.

xPlorer is a Wolfram Language package for reusing an abstract xAct theory on independent metric backgrounds, inspecting formal tensors and calculating components without rebuilding the theory each time.

The current experimental version is **14.0.0-beta.13-dev.2**. The preserved baseline on main is beta.12. The default workflow remains a normal Get, theory registration and tagged background creation. Personalization is optional.

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

The principal notebook has passed 115/115 input executions, 65/65 expected-result checks and 6/6 workflow-order checks. The eight historical regression groups also passed (279 assertion executions including repeated core tests). The optional scalar recipe has been checked independently. See BETA13_PROGRESS.md for exact commits and evidence. The front-end appearance, older API guide and loader metadata have not been revalidated. The 88-input legacy build source is not the current notebook.

For the current registration syntax, use the principal notebook and the [Proca example](Examples/Beta13_Proca.wl). [API_GUIDE.md](API_GUIDE.md) and [VALIDATION.md](VALIDATION.md) are historical beta.7-era documentation; do not use their old positional registration forms with beta.13. Current evidence and limitations are in [BETA13_PROGRESS.md](BETA13_PROGRESS.md).

## Installation and development

Direct Get needs no installation. The repository also contains a traditional application loader and PacletInfo.wl. See the installation section in API_GUIDE.md for Needs and development paclet loading. xAct is installed separately and is not bundled.

- [Development plan](DEVELOPMENT_PLAN.md)
- [Design decisions](DECISIONS.md)
- [Current beta.13 recovery checkpoint](BETA13_PROGRESS.md)
- [Implementation/resumption instruction](IMPLEMENTATION_PROMPT.md)
- [Tests](Tests/) and [historical notebook build sources](Tools/)

Each important validated stage is preserved in Git history. Read BETA13_PROGRESS.md before continuing work so completed stages are not repeated.

## Background and author

Developed by **Eduardo Sanz Romero**, in the context of research with Gonzalo J. Olmo and the Grupo de Gravedad y Campos: http://uv-qg.es/ . The goal is a reusable research tool for moving from formal theories to concrete background calculations.

xTensor supplies abstract tensor calculus, xPert supplies perturbative expansions, and xCoba supplies bases and components. Xplorer organizes and connects these operations; it does not replace their mathematics or solve boundary conditions automatically.

## References and help

- xAct project: https://www.xact.es/
- xAct documentation: https://josmar493.dreamhosters.com/
- xAct discussion group: https://groups.google.com/g/xAct
- Wolfram paclet layout: https://reference.wolfram.com/language/tutorial/Paclets.html

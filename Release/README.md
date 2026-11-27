# xPlorer - Beta tester guide

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

**Version:** 1.0.0-beta.1 (beta candidate). Install xAct separately: https://www.xact.es/. Mathematica 13.0+ is the declared minimum; the current automated validation uses Wolfram Language 15.0.1 and xAct 1.3.0. Earlier kernel versions have not all been tested.

## Getting started

Extract the complete ZIP and install xAct separately. Open **xPlorer_Install.nb** to install, verify or uninstall the supplied paclet. Then open **xPlorer_Workflow.nb** in a fresh kernel and choose Needs (installed) or Get (direct source). No installation is required for Get. Follow the six numbered sections; the main groups are folded and their subsections are open. **xPlorer_API_Examples.nb** is the advanced reference.

## Installation options

Use the installation notebook, or install a downloaded paclet manually with PacletInstall. Restart the kernel and load it with Needs["xPlorer`"]. The expected version is 1.0.0-beta.1. Remove conflicting higher-numbered internal paclets or traditional Applications copies first. For direct source loading, keep xPlorer.wl beside the scientific notebooks. Never load two copies in the same kernel.

## Inspect your models

```wl
ShowBackground[]
ShowBackground["Schwarzschild"]
ShowBackground["Schwarzschild", "Fields"]
```

The first call lists the studies in the current kernel; the others show the declared geometry, actual managed input values or a selected section. No new geometry is computed. Use BackgroundValue["Schwarzschild", "MetricMatrix"] for programmatic data access, or BackgroundObject for native xAct heads. 

## Presentation

```wl
SetXPlorerPreferences[ShowObjectLabels -> True, PartialStyle -> "Fraction"];
CreateBackground["Schwarzschild", SymbolSuffix -> "Schw", BackgroundLabel -> "S"];
DefineChart["Schwarzschild", {t[], r[], theta[], varphi[]}];
SetNotation["Schwarzschild", ShowObjectLabels -> False];
SetNotation["Schwarzschild", ShowObjectLabels -> Automatic];
```

The printed label never renames a symbol. It can be changed per background, chart, owned object or single PrettyExp view. Labels are off by default; the notebooks enable them as a demonstration.

## Current scope and limitations

- Native abstract and primary-chart component workflows, scalar/vector/tensor fields, perturbations and independent affine connections within the documented scope.
- Additional charts and registered basis changes; not arbitrary external basis synchronization or primary chart promotion.
- Arbitrary direct native cache edits, general spinors and bundles beyond the supported tangent-bundle scope are not supported. xAct itself may support additional operations.
- Unknown components are not assumed to be zero. xPlorer does not solve boundary-value problems automatically.
- If a displayed expression no longer contains any owned symbols (for example a pure number), its origin cannot be inferred. Use a background caption explicitly if needed.

## Feedback

Please report issues at https://github.com/physedu/xPlorer/issues with the xPlorer, Mathematica and xAct versions, OS, the smallest reproducible input, expected and actual output, and a screenshot if it is a presentation problem. A fresh kernel makes reproductions much easier. Do not send private research files unnecessarily.

For detailed API reference and development history, see https://github.com/physedu/xPlorer. The distribution contains no development tests or internal progress files.

## Citation and license

Developed by Eduardo Sanz-Romero (PhysEdu). Cite the exact version using CITATION.cff. Please cite xAct independently: https://www.xact.es/. xAct is a separately installed dependency.

Copyright (C) 2026 Eduardo Sanz-Romero. GPL-3.0-or-later; see LICENSE. This software comes without warranty.

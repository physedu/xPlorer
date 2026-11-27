# xPlorer - Beta tester guide

xPlorer lets you reuse one abstract xAct theory on independent geometric backgrounds, then calculate its components using xCoba. It is a research tool built on xTensor, xCoba and xPert, not a replacement for them.

**Version:** 14.0.0-beta.13-dev.35 (beta candidate). Install xAct separately: https://www.xact.es/. Mathematica 13.0+ is the declared minimum; the current automated validation uses Wolfram Language 15.0.1 and xAct 1.3.0. Earlier kernel versions have not all been tested.

## Start here

1. Extract the distribution ZIP. Keep the two notebooks beside the Paclet directory.
2. Open **xPlorer_QuickStart.nb** in a fresh Mathematica kernel.
3. Choose the source loading cell (A) or installed-paclet cell (B), not both. Evaluate the remaining inputs in order.
4. The quick start derives the massive scalar equation and evaluates it on Minkowski, Schwarzschild and FLRW, including curvature and a plane-wave check.
5. For the extended API and more advanced examples, open **xPlorer_Workflow.nb** in a fresh kernel.

## Installation options

### No installation: load the included source

The notebooks already contain the following cell:

```wl
Get[FileNameJoin[{NotebookDirectory[], "Paclet", "xPlorer.wl"}]];
$XPlorerVersion
```

### Install the supplied paclet

In a fresh kernel, select the supplied .paclet with Mathematica's file browser:

```wl
archive = SystemDialogInput["FileOpen"];
If[StringQ[archive], PacletInstall[archive]];
```

Choose the local xPlorer .paclet file. Restart the kernel, then evaluate:

```wl
Needs["xPlorer`"];
$XPlorerVersion
```

The version should be "14.0.0-beta.13-dev.35". Do not load a second copy of xPlorer in the same kernel; remove or move conflicting older traditional installations out of the Applications path before using a paclet. To uninstall, inspect PacletFind["xPlorer"] and use PacletUninstall on the specific installed PacletObject. Restart before testing a different version.

## Inspect your models

```wl
ShowBackground[]
ShowBackground["Schwarzschild"]
ShowBackground["Schwarzschild", "Fields"]
```

The first call lists the studies in the current kernel; the others show the declared geometry, actual managed input values or a selected section. No new geometry is computed. Use BackgroundValue["Schwarzschild", "MetricMatrix"] for programmatic data access, or BackgroundObject for native xAct heads. In dev.35, use BackgroundValue instead of the former raw ShowBackground association.

## Presentation

```wl
SetXPlorerPreferences[ShowObjectLabels -> True, PartialStyle -> "Fraction"];
CreateBackground["Schwarzschild", SymbolSuffix -> "Schw", BackgroundLabel -> "S"];
DefineChart["Schwarzschild", {t[], r[], theta[], varphi[]}];
SetNotation["Schwarzschild", ShowObjectLabels -> False];
SetNotation["Schwarzschild", ShowObjectLabels -> Automatic];
```

The printed label never renames a symbol. It can be changed per background, chart, owned object or single PrettyExp view. Labels are off by default; the Quick Start enables them as a demonstration.

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

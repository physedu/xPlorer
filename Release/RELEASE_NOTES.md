# xPlorer - Beta 14 - first public beta (draft)

**Candidate:** 14.0.0-beta.14

xPlorer connects abstract xAct calculations with concrete geometric studies. Define and register your theory once, then explore different spacetimes, metric and field configurations, coordinate charts and physical limits in the same Mathematica kernel. The underlying tensor algebra remains xAct's.

## Included in the intended distribution

- A matching installable xPlorer paclet, to be attached only after archive verification.
- Wolfram Language source and paclet metadata/loaders.
- xPlorer_Workflow.nb: the main research tutorial, covering scalar equations in Minkowski, Schwarzschild and FLRW, profiles, coordinate transformations, vector/tensor fields, perturbations and reconstruction.
- xPlorer_API_Examples.nb: the exhaustive executable reference with advanced presentation, affine connections, lifecycle and other API examples.
- README, GPL-3.0-or-later license and citation information.

Install xAct separately. Extract the curated ZIP and open xPlorer_Workflow.nb in a fresh Mathematica kernel. Choose A to install/load the included paclet, or B to load the source. Start the reference notebook in a separate fresh kernel.

## Tested and known limitations

The current source and both public notebooks have been exercised with Wolfram Language 15.0.1 on Linux and xAct 1.3.0 using the portable permutation backend. The main notebook passes 131 selected input cells and 26 independent checks; the advanced reference passes 419 cells and 109 checks across 33 stages. This does not certify every Mathematica version or front-end layout. Mathematica 13.0 is the declared minimum; earlier versions have not all been tested. Full historical regression rerun and final Desktop archive acceptance are still pending.

The supported managed scope is tangent-bundle tensors, perturbations, named independent affine connections, primary-chart inputs and registered secondary maps. General spinors, arbitrary bundles, arbitrary external native cache edits and primary-chart promotion are outside this beta. Unknown components are not assumed to be zero. xPlorer does not solve boundary-value problems automatically.

Please report reproducible issues at https://github.com/physedu/xPlorer/issues. Include Mathematica, xAct and xPlorer versions, OS, smallest input and expected versus actual output.

**Maintainer gate:** this text is a draft, not an announcement of publication. Before posting it, verify the actual beta.14 paclet against source, test installation/uninstallation and both notebooks in Desktop, verify the curated ZIP, and update the tested-platform and asset statements to reflect observed results. Publish as a GitHub pre-release only after approval.

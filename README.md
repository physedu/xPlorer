
# xPlorer

`xPlorer` is a symbolic Mathematica package for organizing tensorial calculations on different metric backgrounds in a systematic and reusable way.

The project was developed in the context of research work in theoretical physics, with the goal of making it easier to move from an abstract formulation of a theory to concrete background realizations and, when needed, to a component description.

## Motivation

When working with the `xAct` ecosystem in Mathematica, it is natural to formulate a theory in abstract tensorial language: a metric, a covariant derivative, fields, parameters, and tensor equations. The difficulty appears when the same theory has to be explored on several different backgrounds.

Changing the metric is not enough. Each background carries its own associated geometric structure: manifold, indices, covariant derivative, curvature tensors, fields specialized to that background, and eventually a coordinate chart and component representation. Managing several such backgrounds in a clean way quickly becomes cumbersome if everything is handled manually.

`xPlorer` was created to address this problem.

## Main idea

The package allows the user to:

- register an abstract theory once,
- generate different backgrounds from that theory using tags,
- create for each background its own manifold, metric, covariant derivative, indices, and fields,
- port abstract expressions to a chosen background,
- prepare the background for coordinate and component work.

In this way, the abstract level of the theory is kept separate from its concrete realizations.

## Current status

`xPlorer` is still in an early stage of development, but the main structure is already in place. In particular, the package is designed around:

- abstract theory registration,
- tagged background creation,
- background-specific tensor objects,
- transport of expressions from the abstract theory to a concrete background,
- compatibility with coordinate-based work through the `xAct` ecosystem.

The current implementation has been tested on simple control cases such as Minkowski space, where the metric components are recovered correctly and the expected vanishing of Christoffel symbols and Ricci tensor can be verified.

## Package structure

The repository will contain:

- the Mathematica package file for `xPlorer`,
- notebook files used for development, testing, and examples.

## Ecosystem

`xPlorer` is built to work with the `xAct` ecosystem in Mathematica, especially with:

- `xTensor` for abstract tensor calculus,
- `xPert` in the broader background/perturbative setting,
- `xCoba` for coordinate and component calculations,
- `xTras` as the working environment that bundles and complements these tools.

## Long-term goal

The long-term aim of the project is to consolidate `xPlorer` into a stable and useful tool for research-oriented tensor calculations in theoretical physics, especially in contexts where the same theory must be explored on multiple metric backgrounds without rebuilding the full geometric setup every time.

## Author

Eduardo Sanz Romero

## Acknowledgments

This project was developed in the context of research work with Gonzalo J. Olmo and the Grupo de Gravedad y Campos:

http://uv-qg.es/
```

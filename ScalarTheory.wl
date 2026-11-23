(* Optional source recipe for the initial scalar theory, corresponding to section 1.
   Run once in a fresh kernel instead of the notebook's opening scalar definitions.
   No background or coordinates are created. Later vector and perturbation lessons
   in the notebook deliberately extend this initial theory. *)
Get[FileNameJoin[{DirectoryName[$InputFileName], "xPlorer.wl"}]];

DefManifold[M, 4, {a,b,c,d,e,f,i,j}];
DefMetric[-1, g[-a,-b], CD];
DefTensor[phi[], M];
DefConstantSymbol[m];

lagrangian = -1/2 CD[-a][phi[]] CD[a][phi[]] - 1/2 m^2 phi[]^2;
lagrangian;

theoryAssumptions = Element[m, Reals] && m >= 0;

scalarEquation = ToCanonical[ContractMetric[VarD[phi[], CD][lagrangian]]];
scalarEquation == 0;

ClearTheory[];
RegisterTheory["Metric", g];
RegisterTheory["CovD", CD];
RegisterTheory["Indices", {a,b,c,d,e,f,i,j}];

RegisterTheory["Field", "Scalar", phi];
RegisterTheory["Parameter", "Mass", m];

RegisterTheory["Lagrangian", lagrangian];
RegisterTheory["Expr", "Lagrangian", lagrangian];
RegisterTheory["Expr", "EulerLagrange", scalarEquation];
RegisterTheory["Expr", "Metric", g[-a,-b]];

RegisterTheory["Expr", {
 {"Gradient", CD[-a][phi[]]},
 {"Hessian", CD[-a][CD[-b][phi[]]]}
}];

waveOperator = CD[a][CD[-a][phi[]]];
RegisterTheory["Expr", waveOperator];

RegisterTheory[<|
 "Assumptions" -> theoryAssumptions,
 "Conditions" -> "Fixed metric; compactly supported scalar variations"
|>];
scalarTheory = ShowTheory[];

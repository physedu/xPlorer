(* Optional source recipe for section 1 of the beta.13 principal notebook.
   Start in a fresh kernel. No background or chart is created.
   The standalone naming demonstration is omitted. *)
Get[FileNameJoin[{DirectoryName[$InputFileName],"Paclet","xPlorer.wl"}]];

DefManifold[M,4,{a,b,c,d,e,f,i,j}];
DefMetric[-1,g[-a,-b],CD];
DefTensor[phi[],M,PrintAs->"\[Phi]"];
DefConstantSymbol[m];

Lkin=-1/2 CD[-a][phi[]] CD[a][phi[]];
Lmass=-1/2 m^2 phi[]^2;
lagrangian=Lkin+Lmass;
assumptions=Element[m,Reals]&&m>=0;
scalarEq=ToCanonical[ContractMetric[VarD[phi[],CD][lagrangian]]];
Eab=CD[-a][CD[-b][phi[]]]+m^2 g[-a,-b] phi[];
boxPhi=CD[a][CD[-a][phi[]]];

ClearTheory[];
RegisterTheory["Metric",g];
RegisterTheory["CovD",CD];
RegisterTheory["Indices",{a,b,c,d,e,f,i,j}];
RegisterTheory["Field",phi,Sector->"Matter"];
RegisterTheory["Parameters",m,Name->"Mass",Sector->"Matter"];
RegisterTheory["Lagrangians",{
 {"Kinetic"->Lkin,Sector->"Matter"},
 {"MassTerm"->Lmass,Sector->"Matter"},
 {"Lagrangian"->lagrangian,Sector->"Matter"}}];
RegisterTheory["Expressions",{
 {"ScalarEq"->scalarEq,Sector->"Matter"},
 {"Metric"->g[-a,-b],Head->"metricExpr"},
 {"Gradient"->CD[-a][phi[]],Head->"gradient",Sector->"Matter"},
 {"Hessian"->CD[-a][CD[-b][phi[]]],Head->"hessian",Sector->"Matter"},
 {"Eab"->Eab,Sector->"Matter"},
 {"boxPhi"->boxPhi,Sector->"Matter"}}];
RegisterTheory[<|"Assumptions"->assumptions,
 "Conditions"->"Fixed metric; compactly supported scalar variations"|>];
scalarTheory=TheorySnapshot[];

(* xPlorer beta.13 development example: Einstein-Proca on Schwarzschild.
   Load xPlorer.wl first in a fresh kernel, with xAct installed. *)
ClearTheory[];
DefManifold[Msrc,4,{a,b,c,d,e,f,i,j}];
DefMetric[-1,metric[-a,-b],CD,PrintAs->"g"];
DefTensor[A[-a],Msrc,PrintAs->"A"];
DefConstantSymbol[mass];
DefConstantSymbol[Mbh];
DefConstantSymbol[kappa];

(* Define mathematics once, in native xAct notation. *)
Fexpr=CD[-a][A[-b]]-CD[-b][A[-a]];
Lgrav=RicciScalar[CD][]/(2 kappa);
Lproca=(-1/4 (CD[-a][A[-b]]-CD[-b][A[-a]]) (CD[a][A[b]]-CD[b][A[a]])
 -mass^2 A[-a] A[a]/2);
Ltotal=Lgrav+Lproca;
Eproca=ToCanonical@ContractMetric@VarD[A[-a],CD][Lproca];

(* The derived field strength is an expression, not a second independent field. *)
RegisterTheory["Metric",metric];
RegisterTheory["CovD",CD];
RegisterTheory["Indices",{a,b,c,d,e,f,i,j}];
RegisterTheory["Fields",{{A,Sector->"Proca"}}];
RegisterTheory["Parameters",{mass,Mbh,kappa}];
RegisterTheory["Lagrangians",{
 {"Gravity"->Lgrav,Sector->"Gravity"},
 {"Vector"->Lproca,Sector->"Proca"},
 "Total"->Ltotal}];
RegisterTheory["Expressions",{
 {"FieldStrength"->Fexpr,Sector->"Proca"},
 {"VectorEOM"->Eproca,Sector->"Proca"}}];

(* Source notation survives; actual copied objects have independent identities. *)
CreateBackground["Schwarzschild",SymbolSuffix->"Schw"];
DefineChart["Schwarzschild",{"t","r","theta","varphi"}];
SetCMetricSystem["Schwarzschild",
 Function[{t,r,th,p},DiagonalMatrix[{-(1-2 Mbh/r),1/(1-2 Mbh/r),r^2,r^2 Sin[th]^2}]],
 Assumptions->Function[{t,r,th,p},Mbh>0&&r>2 Mbh&&0<th<Pi]];
fieldData=SetFieldComponents["Schwarzschild",ASchw,Function[{t,r,th,p},{r^2,0,0,0}]];
radius=CoordinatesOf["Schwarzschild"][[2]][];
procaComponents=ToComponents["Schwarzschild",{"Expressions","VectorEOM"},StrictComponents->True];
expected={-6+mass^2 radius^2/(1-2 Mbh/radius),0,0,0};
<|"Version"->$XPlorerVersion,
 "VectorEOM"->Eproca,
 "CopiedLagrangian"->LprocaSchw,
 "Components"->procaComponents,
 "FieldAssignment"->If[FailureQ[fieldData],fieldData,"OK"],
 "ExpectedResidual"->If[FailureQ[procaComponents],procaComponents,Simplify[procaComponents-expected]],
 "SectorKeys"->Keys[TheorySector["Proca"]["Expressions"]]|>

(* Load xPlorer.wl first in a fresh kernel with xAct installed.
   xPlorer organizes the theory; native xCoba objects remain accessible. *)
ClearTheory[];
DefManifold[Msrc,4,{a,b,c,d,e,f}];
DefMetric[-1,g[-a,-b],CD];
DefTensor[phi[],Msrc];
DefTensor[A[-a],Msrc];
RegisterTheory["Metric",g];
RegisterTheory["CovD",CD];
RegisterTheory["Indices",{a,b,c,d,e,f}];
RegisterTheory["Fields",{phi,A}];
CreateBackground["Native",SymbolSuffix->"Nat"];
(* No xPlorer chart, metric or field setter in this first study. *)
With[{mm=BackgroundObject["Native","Manifold"]},
 DefChart[cart,mm,{0,1,2,3},{t[],x[],y[],z[]}]];
With[{gg=BackgroundObject["Native","Metric"]},
 MetricInBasis[gg,-cart,DiagonalMatrix[{-1,1,1,1}]];
 MetricCompute[gg,cart,All]];
ComponentValue[phiNat[],x[]^2];
AllComponentValues[ANat[{-aNat,-cart}],{1,2,3,4}];
native={ToValues[gNat[{0,-cart},{0,-cart}]],ToValues[phiNat[]],ToValues[ANat[{1,-cart}]]};

(* A managed primary chart plus a native non-coordinate basis. *)
CreateBackground["Mixed",SymbolSuffix->"Mix"];
DefineChart["Mixed",{"t","x","y","z"}];
SetCMetricSystem["Mixed",DiagonalMatrix[{-1,1,1,1}]];
SetFieldComponents["Mixed",A,{1,2,3,4},IndexPositions->{-1}];
primary=ChartOf["Mixed"];
With[{vb=VBundleOfMetric[BackgroundObject["Mixed","Metric"]],ch=primary},
 DefBasis[frame,vb,{0,1,2,3},BasisColor->Blue];
 SetBasisChange[CTensor[DiagonalMatrix[{1,2,3,4}],{-frame,ch}]]];
ct=ToComponents["Mixed",A[-a],Output->"CTensor"];
ctNew=ToCTensor[ct,{-frame}];
(* Native transformation, then return to the managed primary basis. *)
<|"NativeValues"->native,
 "CovectorInExternalBasis"->ctNew,
 "NativeColor"->BasisColor[frame],
 "ManagedRaisedVector"->ToComponents["Mixed",A[a]],
 "ExternalBasisProtected"->!DeletionPlan["Mixed"]["CanDelete"],
 "NativeOnlyRegistryNotManaged"->FailureQ[ToComponents["Native",phi[]]]|>

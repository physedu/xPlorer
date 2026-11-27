(* Primary-chart native geometry reads; fresh kernel. *)
DefManifold[MN,4,{a,b,c,d,e,f}];DefMetric[-1,g[-a,-b],CD];DefTensor[A[-a],MN];
RegisterTheory["Metric",g];RegisterTheory["CovD",CD];RegisterTheory["Indices",{a,b,c,d,e,f}];RegisterTheory["Fields",{A}];
CreateBackground["N"];CreateBackground["O"];DefineChart["N",{"t","x","y","z"}];DefineChart["O",{"t","x","y","z"}];
ch=ChartOf["N"];co=ChartOf["O"];x=CoordinatesOf["N"][[2]][];
MetricInBasis[gN,{-Exp[2 x],1,1,1}];MetricInBasis[gO,{-1,1,1,1}];AllComponentValues[AN[-aN],{1,2,3,4}];
ri=Ricci[ConnectionOf["N"]];rs=RicciScalar[ConnectionOf["N"]];ro=Ricci[ConnectionOf["O"]];ei=Einstein[ConnectionOf["N"]];we=Weyl[ConnectionOf["N"]];
r0=ToValues[ri[{0,-ch},{0,-ch}]];n=BackgroundValue["N"]["GeometryRuns"];
r1=ToValues[ri[{0,-ch},{0,-ch}]];n1=BackgroundValue["N"]["GeometryRuns"];
checks=<|"First native read computes Ricci"->(r0===Exp[2 x]&&MemberQ[BackgroundValue["N"]["ComputedGeometry"],"Ricci"]),
"Repeated native read reuses results"->(r1===r0&&n===n1),
"Unrequested Weyl and Einstein absent"->(TensorValIDs[we]==={}&&TensorValIDs[ei]==={}),
"Independent background untouched"->(TensorValIDs[ro]==={})|>;
rc=ComponentValue[rs[]];checks["Scalar geometry component query"]=MatchQ[rc,_Rule]&&Last[rc]===-2;
DeleteTensorValues[ri];rr=AllComponentValues[ri[{-aN,-ch},{-bN,-ch}]];checks["Full native rule query restores Ricci"]=Head[rr]===FoldedRule&&ToValues[ri[{0,-ch},{0,-ch}]]===Exp[2 x];
DeleteTensorValues[ri];Block[{xPlorer`Private`$insideManagedCalculation=True},ComponentValue[ri[{0,-ch},{0,-ch}]]];
checks["Placeholder not mistaken for completed geometry"]=ToValues[ri[{0,-ch},{0,-ch}]]===Exp[2 x];
checks["Native sum across backgrounds"]=ToValues[rs[]+ro[{0,-co},{0,-co}]]===-2;
checks["Field component read prepares requested variance"]=Last[ComponentValue[AN[{0,ch}]]]===-Exp[-2 x];
checks["Native selection honored"]=ToValues[ei[{0,-ch},{0,-ch}],{ri}]===ei[{0,-ch},{0,-ch}]&&TensorValIDs[ei]==={};
checks["Raw TensorValues does not compute"]=Head[TensorValues[we]]===FoldedRule&&TensorValIDs[we]==={};
checks["Abstract geometry left abstract"]=ToValues[ri[-aN,-bN]]===ri[-aN,-bN];
checks["Cleanup"]=And@@(SameQ[DeleteBackground[#],Null]& /@ {"N","O"});
<|"Total"->Length[checks],"Passed"->Count[Values[checks],True],"Failures"->Keys@Select[checks,#=!=True&]|>

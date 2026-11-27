(* Identical metric inputs and native metric-component edits. *)
DefManifold[MN,4,{a,b,c,d,e,f}];DefMetric[-1,g[-a,-b],CD];DefTensor[A[-a],MN];
RegisterTheory["Metric",g];RegisterTheory["CovD",CD];RegisterTheory["Indices",{a,b,c,d,e,f}];RegisterTheory["Fields",{A}];
CreateBackground["N"];CreateBackground["O"];DefineChart["N",{"t","x","y","z"}];DefineChart["O",{"t","x","y","z"}];
ch=ChartOf["N"];x=CoordinatesOf["N"][[2]][];MetricInBasis[gN,{-Exp[2 x],1,1,1}];MetricInBasis[gO,{-1,1,1,1}];
AllComponentValues[AN[-aN],{1,2,3,4}];ri=Ricci[ConnectionOf["N"]];r0=ToValues[ri[{0,-ch},{0,-ch}]];a0=ToValues[AN[{0,ch}]];
before=KeyTake[BackgroundValue["N"],{"MetricRevision","DataRevision","GeometryRuns","ComputedGeometry"}];raw=TensorValues[ri];vraw=TensorValues[AN];
repeat=MetricInBasis[gN,{-Exp[2 x],1,1,1}];
checks=<|"Identical metric leaves revisions and geometry unchanged"->(AssociationQ[repeat]&&KeyTake[BackgroundValue["N"],Keys[before]]===before&&TensorValues[ri]===raw&&TensorValues[AN]===vraw)|>;
sourceA=TensorValues[AN,{{-ch}}];rr=ComponentValue[gN[{0,-ch},{0,-ch}],-4 Exp[2 x]];
checks["Native lower component returns rule and updates registry"]=MatchQ[rr,_Rule]&&MetricMatrixOf["N"][[1,1]]===-4 Exp[2 x];
checks["Old curvature and raised field invalidated"]=TensorValIDs[ri]==={}&&Length[TensorValIDs[AN]]===1;
checks["New metric used by native readers"]=ToValues[gN[{0,ch},{0,ch}]]===-Exp[-2 x]/4&&ToValues[ri[{0,-ch},{0,-ch}]]===4 Exp[2 x]&&ToValues[AN[{0,ch}]]===-Exp[-2 x]/4;
checks["Original field retained"]=TensorValues[AN,{{-ch}}]===sourceA;
rr2=ComponentValue[gN[{0,ch},{0,ch}],-Exp[-2 x]/8];
checks["Native upper component updates covariant record"]=MatchQ[rr2,_Rule]&&MetricMatrixOf["N"][[1,1]]===-8 Exp[2 x]&&ToValues[gN[{0,ch},{0,ch}]]===-Exp[-2 x]/8;
rr3=ToValues[ri[{0,-ch},{0,-ch}]];raw3=TensorValues[ri];rev=BackgroundValue["N"]["MetricRevision"];
bad=ComponentValue[gN[{0,-ch},{0,-ch}],0];
checks["Invalid staged metric rejected without mutation"]=FailureQ[bad]&&MetricMatrixOf["N"][[1,1]]===-8 Exp[2 x]&&ToValues[gN[{0,-ch},{0,-ch}]]===-8 Exp[2 x]&&TensorValues[ri]===raw3&&BackgroundValue["N"]["MetricRevision"]===rev;
Block[{$CVReplace=False},ComponentValue[gN[{0,-ch},{0,-ch}],-9 Exp[2 x]]];
checks["Native CVReplace respected"]=MetricMatrixOf["N"][[1,1]]===-8 Exp[2 x]&&BackgroundValue["N"]["MetricRevision"]===rev;
rr4=ComponentValue[gN[{0,-ch},{1,-ch}],1];
checks["Symmetric off-diagonal edit"]=MatchQ[rr4,_Rule]&&MetricMatrixOf["N"][[1,2]]===1&&MetricMatrixOf["N"][[2,1]]===1;
mat=MetricMatrixOf["N"];ToValues[gN[{0,ch},{0,ch}]];rev=BackgroundValue["N"]["MetricRevision"];MetricInBasis[gN,mat,ComputeOnSet->None];
checks["Lazy inverse updates metric fingerprint"]=BackgroundValue["N"]["MetricRevision"]===rev;
(* An unsupported raw edit must not be blessed by an identical managed assignment. *)
Block[{xPlorer`Private`$insideManagedCalculation=True},ComponentValue[gN[{0,-ch},{0,-ch}],-99]];
MetricInBasis[gN,mat,ComputeOnSet->None];checks["Exact repeat repairs externally changed native source"]=MetricMatrixOf["N"]===mat&&ToValues[gN[{0,-ch},{0,-ch}]]===mat[[1,1]];
checks["Other background isolated"]=MetricMatrixOf["O"]===DiagonalMatrix[{-1,1,1,1}];
checks["Cleanup"]=And@@(SameQ[DeleteBackground[#],Null]& /@ {"N","O"});
<|"Total"->Length[checks],"Passed"->Count[Values[checks],True],"Failures"->Keys@Select[checks,#=!=True&]|>

(* Fresh kernel; no changes to native xCoba definitions. *)
ClearTheory[];
DefManifold[MN,4,{a,b,c,d,e,f}];
DefMetric[-1,g[-a,-b],CD];
DefTensor[phi[],MN];
DefTensor[A[-a],MN];
DefTensor[B[-a,-b],MN,Antisymmetric[{-a,-b}]];
DefMetricPerturbation[g,h,ep];
nativeBefore=DownValues /@ {MetricInBasis,MetricCompute,ComponentValue,AllComponentValues,DeleteTensorValues};
RegisterTheory["Metric",g];RegisterTheory["CovD",CD];RegisterTheory["Indices",{a,b,c,d,e,f}];
RegisterTheory["Fields",{phi,A,h}];
CreateBackground["N",SymbolSuffix->"N"];
CreateBackground["Other",SymbolSuffix->"O"];
DefineChart["N",{"t","x","y","z"}];DefineChart["Other",{"t","x","y","z"}];
metricResult=MetricInBasis[gN,{-1,1,1,1}];
SetCMetricSystem["Other",DiagonalMatrix[{-1,1,1,1}]];
scalarResult=ComponentValue[phiN[],2,Managed->True];
vectorResult=AllComponentValues[AN[-aN],{1,2,3,4}];
pertResult=AllComponentValues[hN[LI[2],-aN,-bN],DiagonalMatrix[{1,2,3,4}]];
geometryResult=MetricCompute[gN,{"Ricci"}];
SaveResult["N","prior",1];
newMetric=MetricInBasis[gN,DiagonalMatrix[{-2,1,1,1}]];
checks=<|
 "Native function definitions unchanged"->(nativeBefore===(DownValues /@ {MetricInBasis,MetricCompute,ComponentValue,AllComponentValues,DeleteTensorValues})),
 "Managed metric"->(AssociationQ[metricResult]&&AssociationQ[newMetric]&&MetricMatrixOf["N"]===DiagonalMatrix[{-2,1,1,1}]),
 "Scalar input"->(AssociationQ[scalarResult]&&ToComponents["N",phi[]]===2),
 "Vector input and changed metric"->(AssociationQ[vectorResult]&&ToComponents["N",A[a]]==={-1/2,2,3,4}),
 "Perturbation LI"->(AssociationQ[pertResult]&&ToComponents["N",h[LI[2],-a,-b]]===DiagonalMatrix[{1,2,3,4}]),
 "Managed compute"->(AssociationQ[geometryResult]&&MemberQ[Join[geometryResult["Computed"],geometryResult["Cached"]],"Ricci"]),
 "Result invalidation"->FailureQ[ResultOf["N","prior"]],
 "Independent background"->(MetricMatrixOf["Other"]===DiagonalMatrix[{-1,1,1,1}]&&ShowBackground["Other"]["FieldComponents"]===<||>)
|>;
recipe=ReconstructionData["N"];
r=RecreateBackground["Copy",recipe];
checks["Reconstruction"] = AssociationQ[r]&&ToComponents["Copy",phi[]]===2&&ToComponents["Copy",A[a]]==={-1/2,2,3,4};
DeleteTensorValues[AN,Managed->True];
checks["Managed deletion"]=!AnyTrue[Values[ShowBackground["N"]["FieldComponents"]],#["Head"]===AN&]&&ToComponents["N",phi[]]===2;
RegisterTheory["Field",B];AddField["N",B];
bad=AllComponentValues[BN[-aN,-bN],IdentityMatrix[4]];
good=AllComponentValues[BN[-aN,-bN],{{0,1,0,0},{-1,0,0,0},{0,0,0,0},{0,0,0,0}}];
checks["Added field and symmetry validation"]=FailureQ[bad]&&AssociationQ[good]&&ToComponents["N",B[-a,-b]][[1,2]]===1;
(* Original fully specified native assignment deliberately remains native, not a managed input. *)
DeleteTensorValues[phiN];ComponentValue[phiN[],9];
checks["Native scalar unchanged"]=ToValues[phiN[]]===9&&ClearComputedValues["N"]=!=$Failed&&ToValues[phiN[]]===2;
checks["Cleanup"]=And@@(SameQ[DeleteBackground[#],Null]& /@ {"Copy","N","Other"});
<|"Total"->Length[checks],"Passed"->Count[Values[checks],True],"Failures"->Keys@Select[checks,#=!=True&]|>

(* Native cache and scalar capture; fresh kernel. *)
DefManifold[MN,4,{a,b,c,d,e,f}];DefMetric[-1,g[-a,-b],CD];
DefTensor[phi[],MN];DefTensor[A[-a],MN];DefTensor[S[-a,-b],MN,Symmetric[{-a,-b}]];DefTensor[T[-a,-b,-c],MN];DefMetricPerturbation[g,h,ep];
RegisterTheory["Metric",g];RegisterTheory["CovD",CD];RegisterTheory["Indices",{a,b,c,d,e,f}];RegisterTheory["Fields",{phi,A,S,T,h}];
nativeBefore=DownValues /@ {ComponentValue,AllComponentValues,ChangeComponents,MetricCompute,MetricInBasis,DeleteTensorValues};
CreateBackground["N"];CreateBackground["O"];DefineChart["N",{"t","x","y","z"}];DefineChart["O",{"t","x","y","z"}];
MetricInBasis[gN,{-1,1,1,1}];MetricInBasis[gO,{-1,1,1,1}];
ch=ChartOf["N"];x=CoordinatesOf["N"][[2]][];head=BackgroundObject["N","phi"];
cv[e_]:=FixedPoint[ToValues,e,12];
record[]:=First[Select[Values[BackgroundValue["N"]["FieldComponents"]],#["Head"]===head&]]["Values"];
ComponentValue[phiN[]];q=BackgroundValue["N"]["FieldComponents"]===<||>;
ret=ComponentValue[phiN[],x^2];v1=record[];
AllComponentValues[AN[-aN],{1,2,3,4}];au=AN[{aN,ch}];aBefore=TensorValIDs[AN];firstA=ToComponents["N",A[a]];aIDs=TensorValIDs[AN];aRules=TensorValues[AN];secondA=ToComponents["N",A[a]];aUnchanged=TensorValues[AN]===aRules;
AllComponentValues[SN[-aN,-bN],DiagonalMatrix[{1,2,3,4}]];sBefore=Length[TensorValIDs[SN]];sMixed=ToComponents["N",S[a,-b]];
AllComponentValues[hN[LI[1],-aN,-bN],DiagonalMatrix[{1,2,3,4}]];
AllComponentValues[hN[LI[2],-aN,-bN],DiagonalMatrix[{5,6,7,8}]];
h1=ToComponents["N",h[LI[1],a,-b]];h2=ToComponents["N",h[LI[2],a,-b]];
high=AllComponentValues[TN[-aN,-bN,-cN],ConstantArray[1,{4,4,4}]];
checks=<|"Read does not register"->q,"Scalar assignment returns native rule"->(MatchQ[ret,_Rule]&&v1===x^2),
"Vector requested variance stored lazily"->(Length[aBefore]===1&&firstA==={-1,2,3,4}&&Length[aIDs]===2&&cv[ComponentArray[au]]===firstA),
"Repeated vector uses native cache"->(secondA===firstA&&aUnchanged),
"Rank two requested mixed variance"->(sBefore===1&&sMixed===DiagonalMatrix[{-1,2,3,4}]&&cv[ComponentArray[SN[{aN,ch},{-bN,-ch}]]]===sMixed),
"Two LI orders"->(cv[ComponentArray[hN[LI[1],{aN,ch},{-bN,-ch}]]]===DiagonalMatrix[{-1,2,3,4}]&&cv[ComponentArray[hN[LI[2],{aN,ch},{-bN,-ch}]]]===DiagonalMatrix[{-5,6,7,8}]),
"High rank skips unrequested calculation"->(AssociationQ[high]&&Length[TensorValIDs[TN]]===1),
"High rank still calculable"->(ToComponents["N",T[a,-b,-c]][[1,1,1]]===-1)|>;
nativeVectorRules=TensorValues[AN];rev=BackgroundValue["N"]["DataRevision"];kin=ToComponents["N",CD[-a][CD[a][phi[]]]];
checks["Calculation does not register"]=kin===2&&BackgroundValue["N"]["DataRevision"]===rev;
derivative=PDOfBasis[ch][{1,-ch}][phiN[]];ComponentValue[derivative,100];d1=ToValues[derivative];SaveResult["N","prior",1];ret2=ComponentValue[phiN[],x^3];
checks["Scalar update clears derivative"]=d1===100&&ToValues[derivative]===3 x^2&&ToComponents["N",CD[-a][CD[a][phi[]]]]===6 x;
checks["Unrelated vector cache retained"]=TensorValues[AN]===nativeVectorRules;
checks["Managed results invalidated"]=FailureQ[ResultOf["N","prior"]];
rev=BackgroundValue["N"]["DataRevision"];Block[{$CVReplace=False},ComponentValue[phiN[],99]];
checks["Native CVReplace respected"]=record[]===x^3&&BackgroundValue["N"]["DataRevision"]===rev;
ComponentValue[phiN[],Function[s,99]];checks["Existing native Function semantics"]=record[]===x^3;
ComponentValue[phiO[],Function[s,12]];checks["New native Function semantics"]=ToComponents["O",phi[]]===12;
MetricInBasis[gN,{-2,1,1,1}];checks["Metric update invalidates then lazily rebuilds vector cache"]=Length[TensorValIDs[AN]]===1&&ToComponents["N",A[a]]==={-1/2,2,3,4}&&cv[ComponentArray[au]]==={-1/2,2,3,4};
checks["Other background isolated"]=ToComponents["O",phi[]]===12&&MetricMatrixOf["O"]===DiagonalMatrix[{-1,1,1,1}];
recipe=ReconstructionData["N"];RecreateBackground["Copy",recipe];copyX=CoordinatesOf["Copy"][[2]][];checks["Recipe keeps scalar"]=ToComponents["Copy",phi[]]===copyX^3;
ClearComputedValues["N"];checks["Clear replay keeps scalar"]=ToValues[phiN[]]===x^3&&record[]===x^3;
checks["No global native mutation"]=nativeBefore===(DownValues /@ {ComponentValue,AllComponentValues,ChangeComponents,MetricCompute,MetricInBasis,DeleteTensorValues});
(* Change the native source without the managed setter; the cached variance must not be stale. *)
ComponentValue[AN[{0,-ch}],7];checks["Native source edit detected"]=ToComponents["N",A[a]]==={-7/2,2,3,4};
DeleteTensorValues[AN,{{ch}}];checks["Native derived deletion detected"]=ToComponents["N",A[a]]==={-7/2,2,3,4};
checks["Cleanup"]=And@@(SameQ[DeleteBackground[#],Null]& /@ {"Copy","N","O"});
<|"Total"->Length[checks],"Passed"->Count[Values[checks],True],"Failures"->Keys@Select[checks,#=!=True&]|>

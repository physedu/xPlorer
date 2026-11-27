(* Selective metric invalidation and exact repeat input assignments. *)
DefManifold[MN,4,{a,b,c,d,e,f}];DefMetric[-1,g[-a,-b],CD];DefTensor[A[-a],MN];DefTensor[phi[],MN];DefMetricPerturbation[g,h,ep];
RegisterTheory["Metric",g];RegisterTheory["CovD",CD];RegisterTheory["Indices",{a,b,c,d,e,f}];RegisterTheory["Fields",{A,phi,h}];
CreateBackground["N"];DefineChart["N",{"t","x","y","z"}];ch=ChartOf["N"];x=CoordinatesOf["N"][[2]][];
MetricInBasis[gN,{-1,1,1,1}];AllComponentValues[AN[-aN],{1,2,3,4}];ComponentValue[phiN[],x^2];
AllComponentValues[hN[LI[1],-aN,-bN],DiagonalMatrix[{1,2,3,4}]];
AllComponentValues[hN[LI[2],-aN,-bN],DiagonalMatrix[{5,6,7,8}]];
v=ToComponents["N",A[a]];hv=ToComponents["N",h[LI[2],a,-b]];
bb=BackgroundValue["N"];stamps=bb["NativeInputStamps"];idsA=TensorValIDs[AN];allRules=TensorValues[AN];rev=bb["DataRevision"];
repeat=AllComponentValues[AN[-aN],{1,2,3,4}];
checks=<|"Repeat complete assignment unchanged"->(AssociationQ[repeat]&&BackgroundValue["N"]["DataRevision"]===rev&&TensorValues[AN]===allRules&&TensorValIDs[AN]===idsA),
"Scalar stamp recorded"->(IntegerQ[stamps["phiN:None"]]),"Input stamps stored"->(Length[stamps]===4&&AllTrue[Values[stamps],IntegerQ])|>;
sourceA=TensorValues[AN,{{-ch}}];sourceH=TensorValues[hN,{{LI[1],-ch,-ch}}];sourceH2=TensorValues[hN,{{LI[2],-ch,-ch}}];sourcePhi=TensorValues[phiN,{{}}];
(* Count actual storeField calls in a dynamically localized test definition. *)
storeCalls=0;
Internal`InheritedBlock[{xPlorer`Private`storeField},
 xPlorer`Private`storeField[bg_,rr_] /; !TrueQ[countingStore] := Block[{countingStore=True},storeCalls++;xPlorer`Private`storeField[bg,rr]];
 MetricInBasis[gN,{-2,1,1,1}]];
checks["No field input replay on metric change"]=storeCalls===0;
checks["Native source rules retained"]=TensorValues[AN,{{-ch}}]===sourceA&&TensorValues[hN,{{LI[1],-ch,-ch}}]===sourceH&&TensorValues[hN,{{LI[2],-ch,-ch}}]===sourceH2&&TensorValues[phiN,{{}}]===sourcePhi;
checks["Derived groups removed lazily"]=Length[TensorValIDs[AN]]===1&&Length[TensorValIDs[hN]]===2;
checks["New metric used"]=ToComponents["N",A[a]]==={-1/2,2,3,4}&&ToComponents["N",h[LI[2],a,-b]]===DiagonalMatrix[{-5/2,6,7,8}];
checks["Metric independent scalar retained"]=ToComponents["N",phi[]]===x^2;
(* Remove a native source group; an exact re-assignment must restore it. *)
DeleteTensorValues[AN,{{-ch}}];storeCalls=0;
Internal`InheritedBlock[{xPlorer`Private`storeField},
 xPlorer`Private`storeField[bg_,rr_] /; !TrueQ[countingStore] := Block[{countingStore=True},storeCalls++;xPlorer`Private`storeField[bg,rr]];
 AllComponentValues[AN[-aN],{1,2,3,4}]];
checks["Missing source restored on identical reassignment"]=storeCalls===1&&ToComponents["N",A[-a]]==={1,2,3,4};
(* Distinct LI orders have distinct native groups even with different variances. *)
AllComponentValues[hN[LI[2],aN,bN],DiagonalMatrix[{5,6,7,8}]];
ToComponents["N",h[LI[1],a,b]];ToComponents["N",h[LI[2],-a,-b]];
storeCalls=0;
Internal`InheritedBlock[{xPlorer`Private`storeField},
 xPlorer`Private`storeField[bg_,rr_] /; !TrueQ[countingStore] := Block[{countingStore=True},storeCalls++;xPlorer`Private`storeField[bg,rr]];
 MetricInBasis[gN,{-3,1,1,1}]];
checks["Mixed LI source groups retained without replay"]=storeCalls===0&&Length[TensorValIDs[hN]]===2;
checks["Mixed LI variance correct"]=ToComponents["N",h[LI[1],a,b]]===DiagonalMatrix[{1/9,2,3,4}]&&ToComponents["N",h[LI[2],-a,-b]]===DiagonalMatrix[{45,6,7,8}];
(* The LI fingerprint must detect deletion of a requested derived order. *)
ids=Select[TensorValIDs[hN],MemberQ[Last[List@@#],{LI[2],-ch,-ch}]&];Scan[DeleteTensorValues,ids];
checks["Deleted LI variance is rebuilt"]=ToComponents["N",h[LI[2],-a,-b]]===DiagonalMatrix[{45,6,7,8}];
checks["Cleanup"]=DeleteBackground["N"]===Null;
<|"Total"->Length[checks],"Passed"->Count[Values[checks],True],"Failures"->Keys@Select[checks,#=!=True&]|>

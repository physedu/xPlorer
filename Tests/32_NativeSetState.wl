(* Native read-only Set-state transitions and explicit managed preflight. *)
DefManifold[MN,4,{a,b,c,d,e,f}];DefMetric[-1,g[-a,-b],CD];DefTensor[A[-a],MN];DefTensor[B[-a],MN];DefTensor[phi[],MN];RegisterTheory["Metric",g];RegisterTheory["CovD",CD];RegisterTheory["Indices",{a,b,c,d,e,f}];RegisterTheory["Fields",{A,B,phi}];
CreateBackground["N"];CreateBackground["O"];DefineChart["N",{"t","x","y","z"}];DefineChart["O",{"t","x","y","z"}];ch=ChartOf["N"];co=ChartOf["O"];MetricInBasis[gN,{-1,1,1,1}];MetricInBasis[gO,{-2,1,1,1}];AllComponentValues[AN[-aN],{1,2,3,4}];AllComponentValues[AO[-aO],{8,9,10,11}];ComponentValue[phiN[],5];
id=First[TensorValIDs[AN]];rev=BackgroundValue["N"]["DataRevision"];mr=BackgroundValue["N"]["MetricRevision"];records=BackgroundValue["N"]["FieldComponents"];nativeBefore=DownValues /@ {RuleToSet,SetToRule,WithSetValues};state[v_]:=xAct`xCoba`Private`StateOfValID[v];blockedQ[r_]:=MatchQ[r,Failure["NativeSetState",_Association]];
RuleToSet[id];checks=<|"Native source state recognized"->(state[id]===Set&&xPlorer`Private`nativeSetActiveQ[AN]),"Direct native Set reads unchanged"->(AN[{0,-ch}]+AN[{1,-ch}]===3)|>;
checks["Held literal Set write explicitly rejected"]=blockedQ[With[{head=AN,chart=ch},HeldComponentValue[head[{0,-chart}],7]]];
checks["Held literal Set read explicitly rejected"]=blockedQ[With[{head=AN,chart=ch},HeldComponentValue[head[{0,-chart}]]]];
checks["Managed field setter rejected"]=blockedQ[SetFieldComponents["N",AN,{8,9,10,11}]];
checks["Exact source deletion rejected"]=blockedQ[DeleteTensorValues[id]];
checks["Full field deletion rejected"]=blockedQ[DeleteTensorValues[AN]];
checks["Clear rejects before changing metric or fields"]=blockedQ[ClearComputedValues["N"]];
checks["Metric replacement rejected"]=blockedQ[SetCMetricSystem["N",DiagonalMatrix[{-2,1,1,1}]]];
checks["Managed geometry rejected"]=blockedQ[ComputeGeometry["N",{"Ricci"}]];
checks["Native managed geometry entry rejected"]=blockedQ[MetricCompute[gN,ch,"Ricci"[-1,-1]]];
checks["Managed component calculation rejected"]=blockedQ[ToComponents["N",A[-a]]];
checks["Managed lazy native read rejected"]=blockedQ[ToValues[AN[{0,ch}]]];
checks["Recipe export rejected"]=blockedQ[ReconstructionData["N"]];
checks["Rejected operations leave input and state unchanged"]=state[id]===Set&&AN[{0,-ch}]===1&&BackgroundValue["N"]["DataRevision"]===rev&&BackgroundValue["N"]["MetricRevision"]===mr&&BackgroundValue["N"]["FieldComponents"]===records;
checks["Other background unaffected"]=ToValues[AO[{0,co}]]===-4&&AssociationQ[SetCMetricSystem["O",DiagonalMatrix[{-4,1,1,1}]]];
SetToRule[id];checks["Round trip returns original native source and stamp"]=state[id]===Rule&&ToValues[AN[{0,-ch}]]===1&&xPlorer`Private`nativeInputCurrentQ[BackgroundValue["N"],First@Select[Values[records],#["Head"]===AN&]];
w=WithSetValues[AN[{0,-ch}]+AN[{1,-ch}],AN];checks["Native read-only WithSetValues returns result and restores Rule"]=w===3&&state[id]===Rule&&BackgroundValue["N"]["DataRevision"]===rev;
checks["Managed operations resume after Rule restoration"]=ToValues[AN[{0,ch}]]===-1&&ClearComputedValues["N"]===Null&&ToValues[AN[{0,-ch}]]===1;
checks["Native transition downvalues unchanged"]=nativeBefore===(DownValues /@ {RuleToSet,SetToRule,WithSetValues});
checks["Cleanup"]=And@@(SameQ[DeleteBackground[#],Null]& /@ {"N","O"});
<|"Total"->Length[checks],"Passed"->Count[Values[checks],True],"Failures"->Keys@Select[checks,#=!=True&]|>

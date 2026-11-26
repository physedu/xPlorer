(* Native read integration; fresh kernel. *)
DefManifold[MN,4,{a,b,c,d,e,f}];DefMetric[-1,g[-a,-b],CD];DefTensor[A[-a],MN];DefTensor[phi[],MN];DefTensor[B[-a],MN];
RegisterTheory["Metric",g];RegisterTheory["CovD",CD];RegisterTheory["Indices",{a,b,c,d,e,f}];RegisterTheory["Fields",{A,phi}];
CreateBackground["N"];CreateBackground["O"];DefineChart["N",{"t","x","y","z"}];DefineChart["O",{"t","x","y","z"}];MetricInBasis[gN,{-1,1,1,1}];MetricInBasis[gO,{-1,1,1,1}];
AllComponentValues[AN[-aN],{1,2,3,4}];AllComponentValues[AO[-aO],{2,3,4,5}];ch=ChartOf["N"];co=ChartOf["O"];
r1=ToValues[AN[{0,ch}]];r2=ToValues[2 AN[{0,ch}]+AN[{1,ch}]];r3=ToValues[ComponentArray[AN[{aN,ch}]]];r4=ToValues[AN[{0,ch}],AN];r5=ToValues[AN[{0,ch}],{AN},Identity];r6=ToValues[AN[{0,ch}]+AO[{0,co}]];
checks=<|"Native single read"->(r1===-1),"Native sum"->(r2===0),"Native array"->(r3==={-1,2,3,4}),"Native head selection"->(r4===-1&&r5===-1),"Multiple independent backgrounds"->(r6===-3),"Unowned tensor unchanged"->(ToValues[B[-a]]===B[-a]),"Abstract input unchanged"->(ToValues[AN[aN]]===AN[aN])|>;
rules=TensorValues[AN];ComponentValue[phiN[],2];checks["Independent scalar retains vector rules"]=TensorValues[AN]===rules;
ComponentValue[AN[{0,-ch}],7];checks["Native change detected by ToValues"]=ToValues[AN[{0,ch}]]===-7;
DeleteTensorValues[AN,{{ch}}];checks["Deleted derived group recreated"]=ToValues[AN[{0,ch}]]===-7;
MetricInBasis[gN,{-2,1,1,1}];checks["Metric update retains native edited input"]=ToValues[AN[{0,ch}]]===-7/2;
checks["Native selector respected"]=ToValues[AN[{0,ch}],{AO}]===AN[{0,ch}];
nativeReturn=AllComponentValues[AN[{-aN,-ch}],{8,9,10,11}];checks["Explicit native complete assignment captured"]=ToComponents["N",A[a]]==={-4,9,10,11};
ChangeComponents[AN[{aN,ch}],AN[{-aN,-ch}]];checks["Native transformation not captured as source"]=First[Select[Values[ShowBackground["N"]["FieldComponents"]],#["Head"]===AN&]]["IndexPositions"]==={-1};
recipe=ReconstructionData["N"];RecreateBackground["Copy",recipe];checks["Explicit native input reconstructs"]=ToComponents["Copy",A[a]]==={-4,9,10,11};
DeleteTensorValues[AN];checks["Full native deletion clears managed source"]=!AnyTrue[Values[ShowBackground["N"]["FieldComponents"]],#["Head"]===AN&]&&ToValues[AN[{0,ch}]]===AN[{0,ch}];
ClearComputedValues["N"];checks["Deleted source not resurrected"]=ToValues[AN[{0,ch}]]===AN[{0,ch}];
checks["Cleanup"]=And@@(SameQ[DeleteBackground[#],Null]& /@ {"N","O","Copy"});
<|"Total"->Length[checks],"Passed"->Count[Values[checks],True],"Failures"->Keys@Select[checks,#=!=True&]|>

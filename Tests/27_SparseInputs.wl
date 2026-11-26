(* Sparse native component inputs; no zero filling or dense storage. *)
DefManifold[MN,4,{a,b,c,d,e,f}];DefMetric[-1,g[-a,-b],CD];DefTensor[A[-a],MN];DefTensor[S[-a,-b],MN,Antisymmetric[{-a,-b}]];DefMetricPerturbation[g,h,ep];DefTensor[T[-a,-b,-c,-d],MN];
RegisterTheory["Metric",g];RegisterTheory["CovD",CD];RegisterTheory["Indices",{a,b,c,d,e,f}];RegisterTheory["Fields",{A,S,h,T}];
CreateBackground["N"];DefineChart["N",{"t","x","y","z"}];ch=ChartOf["N"];x=CoordinatesOf["N"][[2]][];
MetricInBasis[gN,{-1,1,1,1}];r=ComponentValue[AN[{0,-ch}],x];rec=First[Values[ShowBackground["N"]["FieldComponents"]]];
checks=<|"Native first sparse assignment recorded"->(MatchQ[r,_Rule]&&rec["Partial"]===True&&rec["Values"]==={{0}->x}),
"Unspecified component remains symbolic"->(ToValues[AN[{1,-ch}]]===AN[{1,-ch}]),
"Known raised component"->(ToValues[AN[{0,ch}]]===-x)|>;
r=ComponentValue[AN[{1,-ch}],2];checks["Second sparse component updates source and derived"]=ToValues[AN[{1,ch}]]===2&&ToValues[AN[{0,ch}]]===-x;
rev=ShowBackground["N"]["DataRevision"];Block[{$CVReplace=False},ComponentValue[AN[{0,-ch}],9]];
checks["Native CVReplace respected"]=ToValues[AN[{0,-ch}]]===x&&ShowBackground["N"]["DataRevision"]===rev;
bad=ComponentValue[AN[{0,ch}],8];checks["Conflicting input variance rejected"]=FailureQ[bad]&&ToValues[AN[{0,ch}]]===-x;
ComponentValue[SN[{1,-ch},{0,-ch}],3];checks["Antisymmetric sparse counterpart"]=ToValues[SN[{0,-ch},{1,-ch}]]===-3;
ComponentValue[SN[{0,-ch},{1,-ch}],4];checks["Canonical counterpart edit replaces input"]=ToValues[SN[{1,-ch},{0,-ch}]]===-4&&Length[Select[Values[ShowBackground["N"]["FieldComponents"]],#["Head"]===SN&][[1]]["Values"]]===1;
ComponentValue[hN[LI[2],{0,-ch},{1,-ch}],5];ComponentValue[hN[LI[1],{0,-ch},{0,-ch}],6];
checks["Perturbative sparse orders independent"]=ToValues[hN[LI[2],{1,-ch},{0,-ch}]]===5&&ToValues[hN[LI[1],{0,-ch},{0,-ch}]]===6;
ComponentValue[TN[{0,-ch},{1,-ch},{2,-ch},{3,-ch}],7];trec=First[Select[Values[ShowBackground["N"]["FieldComponents"]],#["Head"]===TN&]];
checks["Rank four source remains sparse"]=trec["Values"]==={{0,1,2,3}->7};
MetricInBasis[gN,{-2,1,1,1}];checks["Metric update preserves sparse original"]=ToValues[AN[{0,-ch}]]===x&&ToValues[AN[{0,ch}]]===-x/2;
recipe=ReconstructionData["N"];recreated=RecreateBackground["Copy",recipe];cc=ChartOf["Copy"];xc=CoordinatesOf["Copy"][[2]][];
checks["Sparse reconstruction remaps coordinate values"]=AssociationQ[recreated]&&ToValues[ACopy[{0,-cc}]]===xc&&ToValues[ACopy[{1,-cc}]]===2&&ToValues[ACopy[{2,-cc}]]===ACopy[{2,-cc}];
ClearComputedValues["N"];checks["Clear replay preserves sparse inputs"]=ToValues[AN[{0,-ch}]]===x&&ToValues[SN[{0,-ch},{1,-ch}]]===4;
checks["AssignedFields does not treat sparse as complete"]=CheckBackground["N",Checks->{"AssignedFields"}]["AssignedFields"]["Status"]==="Inconclusive";
AllComponentValues[AN[-aN],{9,8,7,6}];checks["Full array replaces partial record"]=ToComponents["N",A[a]]==={-9/2,8,7,6}&&!TrueQ[Lookup[First[Select[Values[ShowBackground["N"]["FieldComponents"]],#["Head"]===AN&]],"Partial",False]];
DeleteTensorValues[SN];checks["Full deletion removes sparse record"]=!AnyTrue[Values[ShowBackground["N"]["FieldComponents"]],#["Head"]===SN&];
checks["Cleanup"]=And@@(SameQ[DeleteBackground[#],Null]& /@ {"Copy","N"});
<|"Total"->Length[checks],"Passed"->Count[Values[checks],True],"Failures"->Keys@Select[checks,#=!=True&]|>

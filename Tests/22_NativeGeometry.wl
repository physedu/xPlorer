(* Native geometry cache coherence; fresh kernel. *)
DefManifold[MN,4,{a,b,c,d,e,f}];DefMetric[-1,g[-a,-b],CD];DefTensor[A[-a],MN];
RegisterTheory["Metric",g];RegisterTheory["CovD",CD];RegisterTheory["Indices",{a,b,c,d,e,f}];RegisterTheory["Fields",{A}];
CreateBackground["N"];CreateBackground["O"];DefineChart["N",{"t","x","y","z"}];DefineChart["O",{"t","x","y","z"}];
ch=ChartOf["N"];co=ChartOf["O"];x=CoordinatesOf["N"][[2]][];
MetricInBasis[gN,{-Exp[2 x],1,1,1}];MetricInBasis[gO,{-1,1,1,1}];
AllComponentValues[AN[-aN],{1,2,3,4}];AllComponentValues[AO[-aO],{2,3,4,5}];
ri=Ricci[ConnectionOf["N"]];rs=RicciScalar[ConnectionOf["N"]];ro=Ricci[ConnectionOf["O"]];
nativeReturn=MetricCompute[gN,ch,{"Ricci"[-1,-1],"RicciScalar"[]}];
otherReturn=MetricCompute[gO,co,"Ricci"];
checks=<|"Native return preserved"->(nativeReturn===Null&&otherReturn===Null),
 "Native coverage recorded"->(MemberQ[ShowBackground["N"]["ComputedGeometry"],"Ricci"]&&MemberQ[ShowBackground["N"]["ComputedGeometry"],"RicciScalar"]),
 "Curved native values"->(ToValues[ri[{0,-ch},{0,-ch}]]===Exp[2 x]&&ToValues[rs[]]===-2)|>;
cacheBefore=First/@DownValues[xCobaCacheTable];rulesBefore=TensorValues[AN];otherRules=TensorValues[ro];
n0=ShowBackground["N"]["GeometryRuns"];cached=MetricCompute[gN,{"Ricci","RicciScalar"}];n1=ShowBackground["N"]["GeometryRuns"];
checks["Managed compute reuses native results"]=cached["Computed"]==={}&&n0===n1;
DeleteTensorValues[ri];checks["Deleted output absent"]=TensorValIDs[ri]==={};
rep=MetricCompute[gN,ch,{"Ricci"[-1,-1]}];checks["Native compute restores missing output"]=rep===Null&&ToValues[ri[{0,-ch},{0,-ch}]]===Exp[2 x];
checks["Other cache keys retained"]=Complement[cacheBefore,First/@DownValues[xCobaCacheTable]]==={};
checks["Independent field and background intact"]=TensorValues[AN]===rulesBefore&&TensorValues[ro]===otherRules;
DeleteTensorValues[ri];rep2=MetricCompute[gN,{"Ricci"}];
checks["Managed compute restores missing output"]=rep2["Computed"]==={"Ricci"}&&ToValues[ri[{0,-ch},{0,-ch}]]===Exp[2 x];
DeleteTensorValues[rs];rep3=MetricCompute[gN,Zero,ch,"RicciScalar"[]];checks["Explicit Zero torsion native path"]=rep3===Null&&ToValues[rs[]]===-2;
checks["Repeated native call does not increment geometry runs"]=With[{n=ShowBackground["N"]["GeometryRuns"]},MetricCompute[gN,ch,"Ricci"];ShowBackground["N"]["GeometryRuns"]===n];
checks["Cleanup"]=And@@(SameQ[DeleteBackground[#],Null]& /@ {"N","O"});
<|"Total"->Length[checks],"Passed"->Count[Values[checks],True],"Failures"->Keys@Select[checks,#=!=True&]|>

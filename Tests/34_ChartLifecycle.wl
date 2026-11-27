(* Managed chart family lifecycle and native relative geometry ownership. *)
DefManifold[MN,4,{a,b,c,d,e,f}];DefMetric[-1,g[-a,-b],CD];DefTensor[A[-a],MN];RegisterTheory["Metric",g];RegisterTheory["CovD",CD];RegisterTheory["Indices",{a,b,c,d,e,f}];RegisterTheory["Fields",{A}];
makeCase[tag_]:=(CreateBackground[tag];DefineChart[tag,{"t","x","y","z"}];SetCMetricSystem[tag,DiagonalMatrix[{-1,1,1,1}]];DefineChart[tag,"Cyl",{"t","r","theta","z"},Function[{tt,rr,th,zz},{tt,rr Cos[th],rr Sin[th],zz}]];);
makeCase["N"];makeCase["O"];ch=ChartOf["N"];sec=ChartOf["N","Cyl"];co=ChartOf["O","Cyl"];rad=CoordinatesOf["N","Cyl"][[2]][];
mat=ToComponents["N",g[-a,-b],OutputChart->"Cyl"];MetricInBasis[gN,-sec,mat];MetricCompute[gN,sec,All];
pd=PDOfBasis[sec];gamma=GiveSymbol[Christoffel,Sequence@@Sort[{ConnectionOf["N"],pd}]];
checks=<|"Native secondary chart geometry correct"->(ToValues[gamma[{1,sec},{2,-sec},{2,-sec}]]===-rad)|>;
bg=ShowBackground["N"];
checks["Secondary derivative recognized as owned relative geometry"]=MemberQ[xPlorer`Private`relativeHeads[bg],gamma]&&MemberQ[xPlorer`Private`ownedObjects[bg],gamma]&&!MemberQ[xPlorer`Private`externalRelativeHeads[bg],gamma];
checks["Native primary and secondary chart undefinition guarded"]=And@@(MatchQ[UndefChart[#],Failure["ChartLifecycle",_Association]]& /@ {ch,sec})&&ChartQ[ch]&&ChartQ[sec];
checks["Native basis-only deletion of chart guarded"]=And@@(MatchQ[UndefBasis[#],Failure["ChartLifecycle",_Association]]& /@ {ch,sec})&&BasisQ[ch]&&BasisQ[sec];
checks["Guarded deletions leave recipe and metric intact"]=KeyExistsQ[ReconstructionData["N"]["ChartMaps"],"Cyl"]&&ToComponents["N",g[-a,-b],OutputChart->"Cyl"]===mat;
checks["Managed background deletion plan recognizes secondary relative geometry"]=TrueQ[DeletionPlan["N","Background"]["CanDelete"]];
(* An actually external covariant derivative relative to secondary chart is still a blocker. *)
ix=First[BackgroundIndices["N"]];With[{i=ix},DefCovD[outsideD[-i],{}]];ii=BackgroundIndices["N",3];
rel=Christoffel[outsideD,pd][ii[[1]],-ii[[2]],-ii[[3]]];ext=Head[If[Head[rel]===Times,-rel,rel]];
checks["External secondary relative head remains a blocker"]=MemberQ[xPlorer`Private`externalRelativeHeads[ShowBackground["N"]],ext]&&FailureQ[DeleteBackground["N"]]&&ChartQ[sec];
UndefCovD[outsideD];
checks["Full deletion succeeds after native secondary geometry"]=DeleteBackground["N"]===Null&&FailureQ[ShowBackground["N"]];
checks["Other background charts and metric remain"]=ChartQ[co]&&ToComponents["O",g[-a,-b]]===DiagonalMatrix[{-1,1,1,1}];
makeCase["P"];cp=ChartOf["P"];sp=ChartOf["P","Cyl"];mp=ToComponents["P",g[-a,-b],OutputChart->"Cyl"];MetricInBasis[gP,-sp,mp];MetricCompute[gP,sp,All];
pl=DeletionPlan["P","Chart",Cascade->True];checks["Chart-family deletion plan has no false external blocker"]=AssociationQ[pl]&&TrueQ[pl["CanDelete"]];
res=DeleteBackgroundObject["P","Chart",Cascade->True];
checks["Chart-family deletion works with native secondary geometry"]=AssociationQ[res]&&!KeyExistsQ[ShowBackground["P"],"Chart"]&&!KeyExistsQ[ShowBackground["P"],"AdditionalCharts"]&&CovDQ[ConnectionOf["P"]];
DefineChart["P",{"t","x","y","z"}];SetCMetricSystem["P",DiagonalMatrix[{-1,1,1,1}]];
checks["Chart family can be recreated after deletion"]=ChartQ[ChartOf["P"]]&&ToComponents["P",g[-a,-b]]===DiagonalMatrix[{-1,1,1,1}];
checks["Cleanup"]=And@@(SameQ[DeleteBackground[#],Null]& /@ {"O","P"});
<|"Total"->Length[checks],"Passed"->Count[Values[checks],True],"Failures"->Keys@Select[checks,#=!=True&]|>

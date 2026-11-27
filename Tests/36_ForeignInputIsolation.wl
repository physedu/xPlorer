(* Phase 1 regression: every managed input path rejects live references owned by another background.
   Run in a fresh kernel with xAct installed, through RunGroup["ForeignInputIsolation"]. *)
$DefInfoQ=False;$CVVerbose=False;xAct`xPerm`$xpermQ=False;
DefManifold[ForeignM,4,{aa,bb,cc,dd,ee,ff,ii,jj}];
DefMetric[-1,gg[-aa,-bb],CDa];
DefTensor[phia[],ForeignM];
DefTensor[psia[],ForeignM];
DefTensor[Va[-aa],ForeignM];
RegisterTheory["Metric",gg];
RegisterTheory["CovD",CDa];
RegisterTheory["Indices",{aa,bb,cc,dd,ee,ff,ii,jj}];
RegisterTheory["Fields",{phia,psia,Va}];

CreateBackground["One",SymbolSuffix->"O"];
CreateBackground["Two",SymbolSuffix->"T"];
DefineChart["One",{tt[],xx[],yy[],zz[]}];
DefineChart["Two",{tt[],xx[],yy[],zz[]}];
SetCMetricSystem["One",DiagonalMatrix[{-1,1,1,1}],ComputeOnSet->None];
SetCMetricSystem["Two",DiagonalMatrix[{-1,1,1,1}],ComputeOnSet->None];
DefCovD[DAa[-aa],{},FromMetric->gg,Torsion->True];
AddConnection["One","Affine",DAa];
AddConnection["Two","Affine",DAa];
SetFieldComponents["One",phia,2];
SetFieldComponents["Two",phia,7];
recipe=ReconstructionData["One"];

checks=<||>;
SetAttributes[check,HoldRest];
check[id_,actual_,expected_]:=Module[{x=actual,y=expected},
  checks[id]=<|"Passed"->SameQ[x,y],"Actual"->ToString[x,InputForm],"Expected"->ToString[y,InputForm]|>];

foreignSet=SetFieldComponents["Two",phia,phiaO[]];
check["SetFieldComponents rejects foreign field",MatchQ[foreignSet,Failure["ForeignBackground",_Association]],True];
check["Rejected field assignment preserves target",ToComponents["Two",phiaT[]],7];
check["Rejected field assignment preserves source",ToComponents["One",phiaO[]],2];

foreignProfile=RegisterProfile["Two","Foreign",phia,phiaO[]];
check["RegisterProfile rejects foreign field",MatchQ[foreignProfile,Failure["ForeignBackground",_Association]],True];
foreignFunctionProfile=RegisterProfile["Two","ForeignFunction",phia,Function[{tt,xx,yy,zz},phiaO[]]];
check["RegisterProfile rejects foreign function body",MatchQ[foreignFunctionProfile,Failure["ForeignBackground",_Association]],True];
check["Rejected profiles are not stored",!KeyExistsQ[ShowProfiles["Two"],"Foreign"]&&!KeyExistsQ[ShowProfiles["Two"],"ForeignFunction"],True];

foreignNativeScalar=ComponentValue[phiaT[],phiaO[]];
check["Managed ComponentValue rejects foreign scalar",MatchQ[foreignNativeScalar,Failure["ForeignBackground",_Association]],True];
check["Native scalar rejection preserves target",ToComponents["Two",phiaT[]],7];

foreignHeldScalar=With[{head=psiaT},HeldComponentValue[head[],psiaO[]]];
check["HeldComponentValue rejects unevaluated foreign scalar",MatchQ[foreignHeldScalar,Failure["ForeignBackground",_Association]],True];

foreignPartial=ComponentValue[VaT[{0,-chartT}],psiaO[]];
check["Managed partial component rejects foreign scalar",MatchQ[foreignPartial,Failure["ForeignBackground",_Association]],True];
foreignArray=AllComponentValues[VaT[{-aaT,-chartT}],{1,psiaO[],3,4}];
check["Managed complete array rejects foreign scalar",MatchQ[foreignArray,Failure["ForeignBackground",_Association]],True];

foreignMetric=SetCMetricSystem["Two",DiagonalMatrix[{-1,1+xxO[]^2,1,1}],ComputeOnSet->None];
check["SetCMetricSystem rejects foreign coordinate",MatchQ[foreignMetric,Failure["ForeignBackground",_Association]],True];
check["Rejected metric preserves target",MetricMatrixOf["Two"],DiagonalMatrix[{-1,1,1,1}]];
foreignMetricFunction=SetCMetricSystem["Two",Function[{tt,xx,yy,zz},DiagonalMatrix[{-1,1+xxO[]^2,1,1}]],ComputeOnSet->None];
check["Metric profile rejects foreign function body",MatchQ[foreignMetricFunction,Failure["ForeignBackground",_Association]],True];
foreignMetricNative=MetricInBasis[ggT,DiagonalMatrix[{-1,1+xxO[]^2,1,1}]];
check["Native managed MetricInBasis rejects foreign coordinate",MatchQ[foreignMetricNative,Failure["ForeignBackground",_Association]],True];

foreignConnection=SetConnectionComponents["Two","Affine",ReplacePart[ConstantArray[0,{4,4,4}],{2,1,3}->xxO[]]];
check["SetConnectionComponents rejects foreign coordinate",MatchQ[foreignConnection,Failure["ForeignBackground",_Association]],True];
check["Rejected connection is not stored",FailureQ[ConnectionMatrixOf["Two","Affine"]],True];

foreignChart=DefineChart["Two","Foreign",{"T","u","v","w"},Function[{t1,u1,v1,w1},{t1,u1+xxO[],v1,w1}]];
check["Secondary chart map rejects foreign coordinate",MatchQ[foreignChart,Failure["ForeignBackground",_Association]],True];
check["Rejected chart is not stored",!KeyExistsQ[BackgroundValue["Two"]["AdditionalCharts"],"Foreign"],True];

badRecipe=Append[recipe,"ForeignProbe"->psiaT[]];
foreignRecreation=RecreateBackground["Copy",badRecipe];
check["RecreateBackground rejects a second active owner",MatchQ[foreignRecreation,Failure["ForeignBackground",_Association]],True];
check["Rejected recipe creates no background",FailureQ[BackgroundValue["Copy"]],True];
validRecreation=RecreateBackground["Copy",recipe];
check["Reconstruction permits its declared source owner",AssociationQ[validRecreation],True];
check["Reconstructed field snapshot",ToComponents["Copy",phiaCopy[]],2];

(* Explicitly evaluated numbers are snapshots, not live foreign references. *)
numericSnapshot=ToComponents["One",phiaO[]];
snapshotWrite=With[{head=phiaT,value=numericSnapshot},HeldComponentValue[head[],value]];
check["Held scalar accepts an already evaluated numeric snapshot",MatchQ[snapshotWrite,_Rule],True];
check["Held numeric snapshot is stored as a value",ToComponents["Two",phiaT[]],2];

check["Cleanup",And@@(SameQ[DeleteBackground[#],Null]&/@{"Copy","Two","One"}),True];
<|"Total"->Length[checks],"Passed"->Count[Lookup[Values[checks],"Passed"],True],
  "Failed"->Count[Lookup[Values[checks],"Passed"],False],
  "Failures"->Select[checks,!TrueQ[#["Passed"]]&]|>

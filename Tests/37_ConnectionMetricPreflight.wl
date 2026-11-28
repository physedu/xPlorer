(* Phase 2 regression: metric edits must be rejected before they invalidate
   an independently stored connection declared metric-compatible.
   Run in a fresh kernel through RunGroup["ConnectionMetricPreflight"]. *)
$DefInfoQ=False;$CVVerbose=False;xAct`xPerm`$xpermQ=False;
DefManifold[ConnectionPreflightM,4,{aa,bb,cc,dd,ee,ff,ii,jj}];
DefMetric[-1,gg[-aa,-bb],CDa];
DefCovD[DAa[-aa],{},FromMetric->gg,Torsion->True];
RegisterTheory["Metric",gg];
RegisterTheory["CovD",CDa];
RegisterTheory["Indices",{aa,bb,cc,dd,ee,ff,ii,jj}];
RegisterTheory["Connection","Affine",DAa];

CreateBackground["One",SymbolSuffix->"O"];
DefineChart["One",{tt[],xx[],yy[],zz[]}];
SetCMetricSystem["One",DiagonalMatrix[{-1,1,1,1}],ComputeOnSet->None];

(* A nonzero connection difference which is metric-compatible with Minkowski. *)
gamma=ConstantArray[0,{4,4,4}];
gamma[[2,1,3]]=1;
gamma[[3,1,2]]=-1;
SetConnectionComponents["One","Affine",gamma,ReferenceConnection->"Primary"];

oldMetric=MetricMatrixOf["One"];
oldConnection=ConnectionMatrixOf["One","Affine"];
oldRevision=BackgroundValue["One","MetricRevision"];
oldNativeMetricState=BackgroundValue["One","NativeMetricState"];
oldConnectionRecord=BackgroundValue["One","ConnectionComponents"];

checks=<||>;
SetAttributes[check,HoldRest];
check[id_,actual_,expected_]:=Module[{x=actual,y=expected},
  checks[id]=<|"Passed"->SameQ[x,y],
    "Actual"->ToString[x,InputForm],"Expected"->ToString[y,InputForm]|>];

check["Initial metric compatibility passes",
  CheckConnection["One","Affine"]["MetricCompatible"]["Status"],"Passed"];

badMetric=SetCMetricSystem["One",DiagonalMatrix[{-1,4,1,1}],ComputeOnSet->None];
check["Incompatible metric edit is rejected",
  MatchQ[badMetric,Failure["ConnectionMetricCompatibility",_Association]],True];
check["Metric input is unchanged after rejection",MetricMatrixOf["One"],oldMetric];
check["Connection coefficients are unchanged after rejection",
  ConnectionMatrixOf["One","Affine"],oldConnection];
check["Metric revision is unchanged after rejection",
  BackgroundValue["One","MetricRevision"],oldRevision];
check["Native metric fingerprint is unchanged after rejection",
  BackgroundValue["One","NativeMetricState"],oldNativeMetricState];
check["Managed connection record is unchanged after rejection",
  BackgroundValue["One","ConnectionComponents"],oldConnectionRecord];
check["Connection remains compatible after rejected edit",
  CheckConnection["One","Affine"]["MetricCompatible"]["Status"],"Passed"];

check["Same-metric assignment remains a valid no-op",
  FailureQ[SetCMetricSystem["One",oldMetric,ComputeOnSet->None]],False];

check["Cleanup",DeleteBackground["One"],Null];
<|"Total"->Length[checks],
  "Passed"->Count[Lookup[Values[checks],"Passed"],True],
  "Failed"->Count[Lookup[Values[checks],"Passed"],False],
  "Failures"->Select[checks,!TrueQ[#[ "Passed"]]&]|>

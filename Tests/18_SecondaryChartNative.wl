(* Feasibility study: native secondary-chart geometry, not primary-chart promotion. *)
Get[FileNameJoin[{DirectoryName[$InputFileName],"Fixture.wl"}]];
makeBackground["ChartStudy",{"t","x","y","z"},DiagonalMatrix[{-1,1,1,1}]];
DefineChart["ChartStudy","Cylindrical",{"t","r","theta","z"},Function[{tt,rr,th,zz},{tt,rr Cos[th],rr Sin[th],zz}]];
studyChart=ChartOf["ChartStudy","Cylindrical"];
studyRadius=CoordinatesOf["ChartStudy","Cylindrical"][[2]][];
studyMetric=BackgroundObject["ChartStudy","Metric"];
studyCD=ConnectionOf["ChartStudy"];
studyMatrix=ToComponents["ChartStudy",g[-a,-b],OutputChart->"Cylindrical"];
assert["chart-metric-pullback",studyMatrix,DiagonalMatrix[{-1,1,studyRadius^2,1}]];
With[{gg=studyMetric,ch=studyChart,mat=studyMatrix},MetricInBasis[gg,-ch,mat];MetricCompute[gg,ch,All]];
gammaNative=With[{cd=studyCD,ch=studyChart},ToValues[Christoffel[cd,PDOfBasis[ch]][{1,ch},{2,-ch},{2,-ch}]]];
assert["native-secondary-christoffel",Simplify[gammaNative],-studyRadius];
assert["managed-primary-unchanged",ToComponents["ChartStudy",g[-a,-b]],DiagonalMatrix[{-1,1,1,1}]];
<|"Version"->$XPlorerVersion,"Total"->Length[testResults],"Passed"->Count[Lookup[testResults,"Passed"],True],"Failures"->Select[testResults,!TrueQ[#["Passed"]]&]|>

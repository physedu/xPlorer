(* Run with Get[.../Tests/RunTests.wl]. No Quit[] and no global ClearAll[]. *)
Global`$XPlorerTestsDirectory = DirectoryName[$InputFileName];
If[!MemberQ[$Packages,"xPlorer`"],
  Get[FileNameJoin[{DirectoryName[Global`$XPlorerTestsDirectory],"Paclet","xPlorer.wl"}]]];
Global`$XPlorerTestsPreviousContextPath = $ContextPath;
$ContextPath = DeleteCases[$ContextPath,"Global`"];
Begin["XPlorerTestRun" <> StringReplace[CreateUUID[],"-"->""] <> "`"];
testStart = AbsoluteTime[];
Block[{Print = (Null &), xAct`xCoba`$CVVerbose = False, xAct`xPerm`$xpermQ = False},
  Get[FileNameJoin[{Global`$XPlorerTestsDirectory,"Fixture.wl"}]];
  Scan[Get[FileNameJoin[{Global`$XPlorerTestsDirectory,#}]] &,
    {"01_Core.wl","02_Geometry.wl","03_Perturbations.wl","04_Lifecycle.wl","05_Presentation.wl","06_Notation.wl","07_LifecycleObjects.wl","08_Connections.wl","09_ConnectionComponents.wl","10_Rules.wl","11_Reconstruction.wl","12_MetricConnectionCurvature.wl"}];
  ClearTheory[]; With[{theoryToRestore = savedTheory},RegisterTheory[theoryToRestore]];
  Scan[If[KeyExistsQ[$BG,#],DeleteBackground[#]] &,DeleteDuplicates[testTags]];
  Scan[If[xTensorQ[#],UndefTensor[#]] &, {h,F,S,A,phi}];
  UndefMetric[g]; UndefManifold[sourceM];
  UndefMetric[sphereG]; UndefManifold[sphereSourceM];
  If[ParameterQ[epsSource],UndefParameter[epsSource]];
  Scan[If[ConstantSymbolQ[#],UndefConstantSymbol[#]] &, {mass,Mbh,amplitude}];
  If[ScalarFunctionQ[scale],UndefScalarFunction[scale]];
];
Global`$XPlorerTestSummary = <|
  "Version" -> $XPlorerVersion,
  "Kernel" -> System`$Version,
  "xTensor" -> xAct`xTensor`$Version,
  "xCoba" -> xAct`xCoba`$Version,
  "xPert" -> xAct`xPert`$Version,
  "Backend" -> "Wolfram Language permutations (MathLink disabled for reproducible tests)",
  "Total" -> Length[testResults],
  "Passed" -> Count[Lookup[testResults,"Passed"],True],
  "Failed" -> Count[Lookup[testResults,"Passed"],False],
  "Seconds" -> N[AbsoluteTime[]-testStart],
  "Results" -> testResults|>;
End[];
Needs["MUnit`"];
Global`$XPlorerTestReport = TestReport[
  (With[{passed=#["Passed"],id=#["Test"]},VerificationTest[passed,True,TestID->id]] & /@ Global`$XPlorerTestSummary["Results"])];
$ContextPath = Global`$XPlorerTestsPreviousContextPath;
Global`$XPlorerTestSummary

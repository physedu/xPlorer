(* Loaded in a fresh context by RunTests.wl. Uses xAct already installed. *)
DefManifold[sourceM, 4, {a,b,c,d,e,f,i,j}];
DefMetric[-1, g[-a,-b], CD];
DefTensor[phi[], sourceM];
DefTensor[A[-a], sourceM];
DefTensor[S[-a,-b], sourceM, Symmetric[{-a,-b}]];
DefTensor[F[-a,-b], sourceM, Antisymmetric[{-a,-b}]];
DefMetricPerturbation[g,h,epsSource];
DefConstantSymbol[mass];
DefConstantSymbol[Mbh];
savedTheory = TheorySnapshot[];
ClearTheory[];
RegisterTheory["Metric", g];
RegisterTheory["CovD", CD];
RegisterTheory["Indices", {a,b,c,d,e,f,i,j}];
RegisterTheory["Fields", {phi,A,S,F,h}];
RegisterTheory["Lagrangians", "Scalar" -> -CD[-a][phi[]] CD[a][phi[]]/2-mass^2 phi[]^2/2, Head -> "Lscalar"];
RegisterTheory["Parameters", mass, Name -> "Mass"];
RegisterTheory["Expressions", "metric" -> g[-a,-b], Head -> "metricExpr"];
RegisterTheory["Expressions", "KG" -> CD[a][CD[-a][phi[]]]-mass^2 phi[] , Head -> "KG"];
testResults = {};
SetAttributes[assert, HoldAll];
assert[id_, expression_, expected_] := Module[{actual = expression, target = expected},
  AppendTo[testResults, <|"Test" -> id, "Passed" -> SameQ[actual,target], "Actual" -> ToString[actual,InputForm], "Expected" -> ToString[target,InputForm]|>]];
testTags = {};
makeBackground[tag_, names_, matrix_, opts___Rule] := Module[{result},
  AppendTo[testTags,tag]; result = CreateBackground[tag];
  If[FailureQ[result], Return[result]];
  result = DefineChart[tag,names]; If[FailureQ[result], Return[result]];
  SetCMetricSystem[tag,matrix,opts]
];

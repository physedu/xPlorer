(* Optional full-notebook check. Run in a fresh kernel with xAct installed.
   The notebook itself needs only xPlorer.wl. This runner selects a portable
   backend only while checking the examples. *)
Global`$XPlorerWorkflowDirectory = DirectoryName[DirectoryName[$InputFileName]];
Global`$XPlorerWorkflowReport = Module[
 {directory = Global`$XPlorerWorkflowDirectory, notebook, inputs, stages = <||>,
  checks, parseFailures, warnings = {}, timings = {}, started = AbsoluteTime[], run},
 notebook = Get[FileNameJoin[{directory,"xPlorer_Workflow.nb"}]];
 inputs = Cases[notebook,Cell[BoxData[b_],"Input",CellTags -> id_String] :> {id,b},Infinity];
 run[cell_] := Module[{seconds,value},
  {seconds,value} = AbsoluteTiming[Check[
   Block[{NotebookDirectory = Function[directory],Print = (Null &)},
    ToExpression[cell[[2]],StandardForm]],AppendTo[warnings,cell[[1]]];$Failed]];
  AppendTo[timings,<|"Cell" -> cell[[1]],"Seconds" -> seconds|>];
 ];
 run[First[inputs]];
 parseFailures = Count[Quiet[ToExpression[#,StandardForm,HoldComplete] & /@ inputs[[All,2]]],$Failed];
 Block[{xAct`xPerm`$xpermQ = False},
  Scan[Function[cell,
   run[cell];
   Switch[cell[[1]],
    "register_metadata",stages["Theory registered before backgrounds"] = (Keys[xPlorer`$BG] === {}),
    "create_manifolds",stages["Backgrounds created before charts"] = AllTrue[Values[xPlorer`$BG],!KeyExistsQ[#,"Chart"] &],
    "charts",stages["Charts chosen before metric matrices"] = AllTrue[Values[xPlorer`$BG],!KeyExistsQ[#,"MetricMatrix"] &]
   ]
  ],Rest[inputs]];
  checks = Get[FileNameJoin[{directory,"Tests","TutorialChecks.wl"}]];
 ];
 <|"Version" -> xPlorer`$XPlorerVersion,"Kernel" -> System`$Version,
   "InputCells" -> Length[inputs],"ExecutedInputs" -> Length[timings],
   "ParseFailures" -> parseFailures,"WarningCells" -> warnings,
   "Stages" -> stages,"Checks" -> checks,
   "Passed" -> Count[Values[checks],True],"Failed" -> Count[Values[checks],Except[True]],
   "Seconds" -> N[AbsoluteTime[]-started],"CellTimes" -> timings|>
];
Global`$XPlorerWorkflowReport

(* Evaluate the actual notebook inputs, not a second hand-written workflow. *)
Global`$XPlorerConsolidatedDirectory=DirectoryName[DirectoryName[$InputFileName]];
Global`$XPlorerConsolidatedReport=Module[{dir=Global`$XPlorerConsolidatedDirectory,nb,inputs,parsed,results=<||>,warnings={},parseFailures={},checks,failures,unexpected},
 nb=Get[FileNameJoin[{dir,"Tests","Fixtures","xPlorer_Consolidated.nb"}]];
 inputs=Cases[nb,Cell[BoxData[boxes_],"Input",CellTags->id_String]:>{id,boxes},Infinity];
 Block[{Print=(Null&)},Needs["xAct`xPert`"];Needs["xAct`xCoba`"]];
 Block[{Print=(Null&),NotebookDirectory=Function[dir],xAct`xPerm`$xpermQ=False,xAct`xCoba`$CVVerbose=False},
  Do[parsed=Quiet[ToExpression[cell[[2]],StandardForm,HoldComplete]];
   If[parsed===$Failed,AppendTo[parseFailures,cell[[1]]];Continue[]];
   results[cell[[1]]]=Check[ReleaseHold[parsed],AppendTo[warnings,cell[[1]]];$Failed],
   {cell,inputs}]];
 checks=KeySelect[results,StringStartsQ[#,"check_"]&];
 failures=Keys@Select[checks,!TrueQ[#]&];
 unexpected=Keys@Select[results,!FreeQ[#,_Failure|$Failed]&];
 <|"InputCells"->Length[inputs],"ExecutedInputs"->Length[results],"Checks"->Length[checks],"Passed"->Count[Values[checks],True],"FailedChecks"->failures,"ParseFailures"->parseFailures,"WarningCells"->warnings,"UnexpectedFailureCells"->unexpected|>
];
Global`$XPlorerConsolidatedReport

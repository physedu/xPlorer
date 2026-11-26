(* Execute the actual author notebook boxes sequentially in a fresh kernel.
   xAct is required; use the portable backend only in this runner. *)
Global`$XPlorerWorkflowDirectory=DirectoryName[DirectoryName[$InputFileName]];
Global`$XPlorerWorkflowOutputs=<||>;
Global`$XPlorerWorkflowReport=Module[
 {directory=Global`$XPlorerWorkflowDirectory,notebook,inputs,stages=<||>,checks,
  parseFailures={},compoundFailures={},warnings={},timings={},started=AbsoluteTime[],run,failed,oldFieldName,initiallyAbsent,styleOf,printedStyle},
 initiallyAbsent=!MemberQ[$Packages,"xPlorer`"];
 notebook=Get[FileNameJoin[{directory,"xPlorer_Workflow.nb"}]];
 inputs=Cases[notebook,Cell[BoxData[b_],"Input",CellTags->id_String]:>{id,b},Infinity];
 Block[{Print=(Null&)},Needs["xAct`xPert`"];Needs["xAct`xCoba`"]];
 styleOf[view_,key_]:=If[Head[view]===xPlorer`Private`expressionView,view[[2]][key],Missing["Native"]];
 printedStyle[expr_,key_]:=styleOf[xPlorer`Private`notebookPrint[expr],key];
 run[cell_]:=Module[{id=First[cell],b=Last[cell],seconds,value,parsed},
  If[id==="delete_single_field",oldFieldName=ToString[xPlorer`BackgroundObject["MinkowskiFields","S"],InputForm]];
  parsed=Quiet[ToExpression[b,StandardForm,HoldComplete]];
  If[parsed===$Failed,AppendTo[parseFailures,id]];
  If[MatchQ[parsed,HoldComplete[_Times]]&&!FreeQ[parsed,_CompoundExpression],AppendTo[compoundFailures,id]];
  {seconds,value}=AbsoluteTiming[Check[
    Block[{NotebookDirectory=Function[directory],Print=(Null&)},ToExpression[b,StandardForm]],
    AppendTo[warnings,id];$Failed]];
  AssociateTo[Global`$XPlorerWorkflowOutputs,id->value];
  AppendTo[timings,<|"Cell"->id,"Seconds"->seconds|>];
  Switch[id,
   "load",stages["Notebook Get loads xPlorer"]=initiallyAbsent&&value===Null&&MemberQ[$Packages,"xPlorer`"],
   "naming_result",stages["Native copied head and independent printed label"]=With[{head=xPlorer`BackgroundObject["NamingExample","Materia"]},
     SameQ[First[value],head]&&xAct`xTensor`xTensorQ[head]&&SameQ[SymbolName[head],"matterDemo"]&&SameQ[xAct`xTensor`PrintAs[head],"P"]],
   "naming_setup",stages["Greek index labels on naming example"]=With[{ii=xPlorer`BackgroundIndices["NamingExample",2]},SameQ[Map[Function[ix,With[{s=ix},xAct`xTensor`PrintAs[s]]],ii],{"\[Mu]","\[Nu]"}]],
   "naming_index_aliases",stages["Latin aliases preserve Greek indices"]=SameQ[value,Rest[Global`$XPlorerWorkflowOutputs["naming_result"]][[{2,3}]]],
   "session_prefix",stages["Session prefix applies to both backgrounds"]=SameQ[printedStyle[#,"CovariantStyle"]& /@ value,{"Prefix","Prefix"}],
   "local_postfix",stages["Background notation overrides only its own output"]=SameQ[printedStyle[#,"CovariantStyle"]& /@ value,{"Prefix","Postfix"}]&&TrueQ[printedStyle[Last[value],"ShowBackgroundLabel"]],
   "pretty_default",stages["Postfix PrettyExp inherits background settings"]=SameQ[styleOf[value,"CovariantStyle"],"Postfix"]&&TrueQ[styleOf[value,"ShowBackgroundLabel"]],
   "pretty_gradient",stages["Explicit view options override local defaults"]=SameQ[styleOf[#,"CovariantStyle"]& /@ value,{"Prefix","Postfix"}]&&SameQ[Normal /@ value,ConstantArray[Global`$XPlorerWorkflowOutputs["transport_gradient"],2]],
   "restore_local",stages["Automatic restores inherited notation"]=SameQ[printedStyle[#,"CovariantStyle"]& /@ value,{"Prefix","Prefix"}],
   "session_reset",stages["Reset restores native session notation"]=SameQ[xPlorer`Private`notationSettings[None],xPlorer`Private`$notationDefaults],
   "partial_view",stages["Partial views preserve equation and select styles"]=SameQ[styleOf[#,"PartialStyle"]& /@ value,{"Native","Fraction","Partial"}]&&SameQ[Normal /@ value,ConstantArray[Global`$XPlorerWorkflowOutputs["minkowski_equation"],3]],
   "automatic_comma",stages["Automatic comma notation for Minkowski"]=SameQ[printedStyle[value,"PartialStyle"],"Comma"],
   "automatic_fraction",stages["Minkowski inherits session fraction again"]=SameQ[printedStyle[value,"PartialStyle"],"Fraction"],
   "radial_prime",stages["Radial equation uses prime notation"]=SameQ[printedStyle[value,"PartialStyle"],"Prime"],
   "radial_restore",stages["Radial equation inherits fraction again"]=SameQ[printedStyle[value,"PartialStyle"],"Fraction"],
   "register_metadata",stages["Theory registered before backgrounds"]=Keys[xPlorer`$BG]==={},
   "create_manifolds",stages["Three independent manifolds before charts"]=Length[xPlorer`$BG]===3&&
     Length[DeleteDuplicates[Lookup[Values[xPlorer`$BG],"Manifold"]]]===3&&AllTrue[Values[xPlorer`$BG],!KeyExistsQ[#,"Chart"]&],
   "charts",stages["Charts chosen before metric matrices"]=AllTrue[Values[xPlorer`$BG],KeyExistsQ[#,"Chart"]&&!KeyExistsQ[#,"MetricMatrix"]&],
   "ctensor_output",stages["CTensor retains native basis and variance"]=With[{ch=xPlorer`ChartOf["MinkowskiFields"]},SameQ[value,xAct`xCoba`CTensor[{-1,2,3,4},{ch}]]],
   "delete_single_field",stages["Owned field actually undefined"]=!ToExpression[oldFieldName,InputForm,xAct`xTensor`xTensorQ],
   _,Null
  ]
 ];
 Block[{xAct`xPerm`$xpermQ=False},Scan[run,inputs];
  checks=Get[FileNameJoin[{directory,"Tests","TutorialChecks.wl"}]]];
 failed=Keys@Select[Global`$XPlorerWorkflowOutputs,!FreeQ[#,_Failure|$Failed]&];
 <|"Version"->xPlorer`$XPlorerVersion,"Kernel"->System`$Version,
   "InputCells"->Length[inputs],"ExecutedInputs"->Length[timings],"ParseFailures"->parseFailures,"MalformedCompoundCells"->compoundFailures,
   "WarningCells"->warnings,"ExpectedFailureCells"->Intersection[failed,{"invalidated_result"}],
   "UnexpectedFailureCells"->DeleteCases[failed,"invalidated_result"],
   "Stages"->stages,"Checks"->checks,"Passed"->Count[Values[checks],True],
   "Failed"->Count[Values[checks],Except[True]],"Seconds"->N[AbsoluteTime[]-started],"CellTimes"->timings|>
];
Global`$XPlorerWorkflowReport

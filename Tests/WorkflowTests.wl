(* Execute the actual author notebook boxes sequentially in a fresh kernel.
   xAct is required; use the portable backend only in this runner. *)
Global`$XPlorerWorkflowDirectory=DirectoryName[DirectoryName[$InputFileName]];
Global`$XPlorerWorkflowOutputs=<||>;
Global`$XPlorerWorkflowReport=Module[
 {directory=Global`$XPlorerWorkflowDirectory,notebook,inputs,stages=<||>,checks,
  parseFailures={},compoundFailures={},warnings={},timings={},started=AbsoluteTime[],run,failed,oldFieldName,initiallyAbsent,styleOf,printedStyle,profileRuns,parts,baseID,partNumber,partCounts},
 (* Reassemble comparison groups only inside the test runner; the notebook shows separate outputs. *)
 partCounts=<|"naming_result"->4,"naming_index_aliases"->2,"inspect_registration"->2,"scalar_alias"->2,"inspect_short_names"->4,"automatic_formulas"->5,"formal_equations"->3,"riemann_tensor"->3,"custom_presentation"->3,"reset_presentation"->3,"session_prefix"->2,"local_postfix"->2,"pretty_gradient"->2,"restore_local"->2,"schwarzschild_curvature"->2,"flrw_geometry"->2,"cylindrical_connection"->2,"two_hessian_charts"->2,"trace_both"->2,"field_snapshots"->2,"vector_values"->3,"tensor_selection"->2,"formal_affine"->2,"compare_derivatives"->3,"geometry_reuse"->2,"delete_background"->2,"flat_rules"->2,"compare_affine_component"->2|>;
 initiallyAbsent=!MemberQ[$Packages,"xPlorer`"];
 notebook=Get[FileNameJoin[{directory,"xPlorer_API_Examples.nb"}]];
 (* The three startup cells are alternatives. Test the direct-source path here. *)
 inputs=DeleteCases[Cases[notebook,Cell[BoxData[b_],"Input",CellTags->id_String]:>{id,b},Infinity],{("load_installed"|"load_existing"),_}];
 Block[{Print=(Null&)},Needs["xAct`xPert`"];Needs["xAct`xCoba`"]];
 styleOf[view_,key_]:=If[Head[view]===xPlorer`Private`expressionView,view[[2]][key],Missing["Native"]];
 printedStyle[expr_,key_]:=styleOf[xPlorer`Private`notebookPrint[expr],key];
 run[cell_]:=Module[{id=First[cell],b=Last[cell],seconds,value,parsed},
  If[id==="delete_single_field_step_1",oldFieldName=ToString[xPlorer`BackgroundObject["MinkowskiFields","S"],InputForm]];
  parsed=Quiet[ToExpression[b,StandardForm,HoldComplete]];
  If[parsed===$Failed,AppendTo[parseFailures,id]];
  If[MatchQ[parsed,HoldComplete[_Times]]&&!FreeQ[parsed,_CompoundExpression],AppendTo[compoundFailures,id]];
  {seconds,value}=AbsoluteTiming[Check[
    Block[{NotebookDirectory=Function[directory]},If[TrueQ[Global`$XPlorerWorkflowSilent],Block[{Print=(Null&)},ToExpression[b,StandardForm]],ToExpression[b,StandardForm]]],
    AppendTo[warnings,id];$Failed]];
  AssociateTo[Global`$XPlorerWorkflowOutputs,id->value];
  AppendTo[timings,<|"Cell"->id,"Seconds"->seconds|>];
  If[StringContainsQ[id,"_part_"],
   baseID=First[StringSplit[id,"_part_"]];partNumber=ToExpression[Last[StringSplit[id,"_part_"]]];
   If[partNumber===Lookup[partCounts,baseID,0],
    value=Lookup[Global`$XPlorerWorkflowOutputs,Table[baseID<>"_part_"<>ToString[k],{k,partNumber}]];
    If[baseID==="tensor_selection",value[[1]]=First[value[[1]]]];
    AssociateTo[Global`$XPlorerWorkflowOutputs,baseID->value];id=baseID
   ]
  ];
  Switch[id,
   "load",stages["Notebook Get loads xPlorer"]=initiallyAbsent&&value===Null&&MemberQ[$Packages,"xPlorer`"],
   "naming_result",stages["Native copied head and independent printed label"]=With[{head=xPlorer`BackgroundObject["NamingExample","ScalarField"]},
     SameQ[First[value],head]&&xAct`xTensor`xTensorQ[head]&&SameQ[SymbolName[head],"phiDemo"]&&SameQ[xAct`xTensor`PrintAs[head],"P"]],
   "naming_setup",stages["Greek index labels on naming example"]=With[{ii=xPlorer`BackgroundIndices["NamingExample",2]},SameQ[Map[Function[ix,With[{s=ix},xAct`xTensor`PrintAs[s]]],ii],{"\[Mu]","\[Nu]"}]],
   "naming_index_aliases",stages["Latin aliases preserve Greek indices"]=SameQ[value,Rest[Global`$XPlorerWorkflowOutputs["naming_result"]][[{2,3}]]],
   "custom_presentation",stages["Multiple labels applied together"]=SameQ[KeyTake[xPlorer`PresentationOf["Schwarzschild"]["Effective"],{"phi","Metric","CovD"}],<|"phi"->"\[Psi]","Metric"->"q","CovD"->{"|","D"}|>],
   "named_profiles",profileRuns=xPlorer`BackgroundValue["Minkowski"]["GeometryRuns"],
   "profile_cached_geometry",stages["Profile switching retains geometry run count"]=SameQ[xPlorer`BackgroundValue["Minkowski"]["GeometryRuns"],profileRuns],
   "eab_postfix",stages["Rank two notation preserves expression"]=SameQ[Normal[value],Global`EabSchw]&&SameQ[styleOf[value,"CovariantStyle"],"Postfix"];
    stages["Eab display has no internal context labels"]=With[{v=value},StringFreeQ[ToString[MakeBoxes[v,StandardForm]//.InterpretationBox[display_,___]:>display,InputForm],"Backgrounds`"]],
   "partial_comma",stages["All five multivariate partial styles preserve equation"]=AllTrue[{"partial_view","partial_multiindex","partial_fraction","partial_partial","partial_comma"},SameQ[Normal[Global`$XPlorerWorkflowOutputs[#]],Global`$XPlorerWorkflowOutputs["minkowski_equation"]]&],
   "native_metric_basis",stages["Native CTensor bases are both covariant"]=With[{bb=xPlorer`BasisOf["Minkowski"]},SameQ[value,{-bb,-bb}]];
    stages["Chart has clean display without changing identity"]=With[{v=value},StringFreeQ[ToString[MakeBoxes[v,StandardForm]//.InterpretationBox[display_,___]:>display,InputForm],"Backgrounds`"] && !FreeQ[MakeBoxes[v,StandardForm],"chartM"]],
   "inferred_eab",stages["Inferred Eab agrees with explicit components"]=SameQ[First[value],xPlorer`ToComponents["Schwarzschild",Global`EabSchw]];
    stages["Inferred CTensor options"]=With[{v=xPlorer`ToComponents[Global`EabSchw,xPlorer`Output->"CTensor"]},MatchQ[v,_xAct`xCoba`CTensor]&&SameQ[Part[v,1],First[value]]];
    stages["Ambiguous and abstract inputs require tag"]=And[FailureQ[xPlorer`ToComponents[Global`Eab]],FailureQ[xPlorer`ToComponents[{Global`phiM[],Global`phiSchw[]}]],FailureQ[xPlorer`ToComponents[1]]],
   "custom_postfix_marker",stages["Custom postfix marker is rendered"]=With[{v=value},AnyTrue[Cases[MakeBoxes[v,StandardForm],_String,Infinity],#==="|"||StringStartsQ[#,"|("]&]],
   "session_prefix",stages["Session prefix applies to both backgrounds"]=SameQ[printedStyle[#,"CovariantStyle"]& /@ value,{"Prefix","Prefix"}],
   "local_postfix",stages["Background notation overrides only its own output"]=SameQ[printedStyle[#,"CovariantStyle"]& /@ value,{"Prefix","Postfix"}]&&TrueQ[printedStyle[Last[value],"ShowBackgroundLabel"]],
   "pretty_default",stages["Postfix PrettyExp inherits background settings"]=SameQ[styleOf[value,"CovariantStyle"],"Postfix"]&&TrueQ[styleOf[value,"ShowBackgroundLabel"]],
   "pretty_gradient",stages["Explicit view options override local defaults"]=SameQ[styleOf[#,"CovariantStyle"]& /@ value,{"Prefix","Postfix"}]&&SameQ[Normal /@ value,ConstantArray[Global`$XPlorerWorkflowOutputs["transport_gradient"],2]],
   "restore_local",stages["Automatic restores inherited notation"]=SameQ[printedStyle[#,"CovariantStyle"]& /@ value,{"Prefix","Prefix"}],
   "session_reset",stages["Reset restores native session notation"]=SameQ[xPlorer`Private`notationSettings[None],xPlorer`Private`$notationDefaults],
   "partial_view",stages["Partial views preserve equation and select styles"]=SameQ[styleOf[value,"PartialStyle"],"Native"]&&SameQ[Normal[value],Global`$XPlorerWorkflowOutputs["minkowski_equation"]],
   "automatic_comma",stages["Automatic comma notation for Minkowski"]=SameQ[printedStyle[value,"PartialStyle"],"Comma"],
   "automatic_fraction",stages["Minkowski inherits session fraction again"]=SameQ[printedStyle[value,"PartialStyle"],"Fraction"],
   "radial_prime",stages["Radial equation uses prime notation"]=SameQ[printedStyle[value,"PartialStyle"],"Prime"],
   "radial_restore",stages["Radial equation inherits fraction again"]=SameQ[printedStyle[value,"PartialStyle"],"Fraction"],
   "register_metadata",stages["Theory registered before backgrounds"]=Keys[xPlorer`$BG]==={};
    stages["Title and description at top"]=With[{v=xPlorer`ShowTheory[]},!FreeQ[First[v][[1]],"Massive scalar field"]&&SameQ[First[v][[2]],"A real massive scalar field minimally coupled to gravity."]];
    stages["Sector keys visible"]=And@@(!FreeQ[xPlorer`ShowTheory["Sectors"],#]& /@ {"phi","Mass","Kinetic","MassTerm","Lagrangian","Eab","Gradient","Hessian"}),
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

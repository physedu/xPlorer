(* Execute the main public research tutorial in a fresh kernel. Native Print is not intercepted. *)
root=DirectoryName[DirectoryName[$InputFileName]];
Needs["xAct`xPert`"]; Needs["xAct`xCoba`"];
nb=Get[FileNameJoin[{root,"xPlorer_Workflow.nb"}]];
inputs=DeleteCases[Cases[nb,Cell[BoxData[b_],"Input",CellTags->id_String]:>{id,b},Infinity],{"load_installed",_}];
warnings={}; outputs=<||>;
(* Load the package before parsing checks that refer to its public symbols. *)
loadCell=First@Select[inputs,First[#]==="load"&];
AssociateTo[outputs,"load"->Check[Block[{NotebookDirectory=Function[root]},ToExpression[Last[loadCell],StandardForm]],AppendTo[warnings,"load"];$Failed]];
Block[{xAct`xPerm`$xpermQ=False,NotebookDirectory=Function[root]},
 Scan[Function[cell,AssociateTo[outputs,First[cell]->Check[ToExpression[Last[cell],StandardForm],AppendTo[warnings,First[cell]];$Failed]]],DeleteCases[inputs,{"load",_}]]];
 checks=<|
 "version"->SameQ[$XPlorerVersion,"14.0.0-beta.13-dev.36"],
 "wave solution"->SameQ[outputs["wave_solution"],0],
 "Schwarzschild radial equation"->TrueQ[Simplify[eqS-((1-2 Mbh/rSchw[])u''[rSchw[]]+(2/rSchw[]-2 Mbh/rSchw[]^2)u'[rSchw[]]-m^2 u[rSchw[]])]==0],
 "Schwarzschild Ricci scalar"->SameQ[outputs["ricci_s"],0],
 "Schwarzschild Kretschmann"->TrueQ[Simplify[outputs["kretschmann_s"]-48 Mbh^2/rSchw[]^6]==0],
 "FLRW equation"->TrueQ[Simplify[eqF+q''[tFLRW[]]+3 s'[tFLRW[]]q'[tFLRW[]]/s[tFLRW[]]+m^2 q[tFLRW[]]]==0],
 "FLRW energy density"->TrueQ[Simplify[rhoFLRW-(q'[tFLRW[]]^2+m^2 q[tFLRW[]]^2)/2]==0],
 "independent rules"->SameQ[outputs["other_unchanged"],0]&&SameQ[outputs["mass_restored"],0],
 "massless equation"->FreeQ[outputs["eq_massless"],m],
 "cylindrical scalar"->SameQ[outputs["profile_c"],rCylindricalM[]^2],
 "cylindrical metric"->TrueQ[Simplify[First[outputs["metric_c"]]-DiagonalMatrix[{-1,1,rCylindricalM[]^2,1}]]===ConstantArray[0,{4,4}]],
 "profile restoration"->SameQ[outputs["wave_again"],0],
 "vector norm"->SameQ[outputs["norm"],28],
 "raised vector"->SameQ[outputs["raised"],{-1,2,3,4}],
 "native CTensor"->MatchQ[outputs["ctensor"],_CTensor],
 "antisymmetry"->SameQ[outputs["opposite"],-3],
 "unassigned remains symbolic"->!NumericQ[outputs["unknown"]],
 "selected components"->SameQ[outputs["selected_f"],{2,-2}],
 "two-form norm"->SameQ[outputs["invariant_f"],-8],
 "first variation"->SameQ[deltaG,DiagonalMatrix[{0,tM[]^2,0,0}]],
 "second inverse variation"->SameQ[delta2G,DiagonalMatrix[{0,2tM[]^4,0,0}]],
 "metric edit"->SameQ[outputs["raised_changed"],{-1/4,2,3,4}]&&SameQ[outputs["norm_changed"],115/4],
 "restoration"->SameQ[outputs["norm_restored"],28]&&SameQ[outputs["raised_recovered"],{-1,2,3,4}],
 "four independent studies"->Length[BackgroundValue[]]===4,
 "labels preserve math"->SameQ[Normal[outputs["postfix_view"]],outputs["prefix_view"]],
 "visual inspection"->MatchQ[outputs["inspect_s"],_Column]&&MatchQ[outputs["models_final"],_Grid]
 |>;
<|"Inputs"->Length[inputs],"Executed"->Length[outputs],"Warnings"->warnings,"UnexpectedFailures"->Keys@Select[outputs,!FreeQ[#,_Failure|$Failed|$Aborted]&],"Passed"->Count[Values[checks],True],"Total"->Length[checks],"FailedChecks"->Keys@Select[checks,!TrueQ[#]&]|>

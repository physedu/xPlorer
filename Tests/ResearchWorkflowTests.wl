(* Execute the public research tutorial and inspect actual StandardForm boxes at the point of evaluation. *)
root=DirectoryName[DirectoryName[$InputFileName]];
Needs["xAct`xPert`"]; Needs["xAct`xCoba`"];
nb=Get[FileNameJoin[{root,"xPlorer_Workflow.nb"}]];
inputs=DeleteCases[Cases[nb,Cell[BoxData[b_],"Input",CellTags->id_String]:>{id,b},Infinity],{("load_installed"|"load_existing"),_}];
warnings={}; outputs=<||>; rendered=<||>;
loadCell=First@Select[inputs,First[#]==="load"&];
AssociateTo[outputs,"load"->Check[Block[{NotebookDirectory=Function[root]},ToExpression[Last[loadCell],StandardForm]],AppendTo[warnings,"load"];$Failed]];
renderTags={"kg_m_abstract","abstract_copies","rank_two_s","postfix_view","caption","rename_view","eq_m_view","partial_compare","eq_s_view","prime","profile_c","density_caption","wave_abstract_m","wave_abstract_f","wave_pretty"};
Block[{xAct`xPerm`$xpermQ=False,NotebookDirectory=Function[root]},
 Scan[Function[cell,Module[{id=First[cell],value,display},value=Catch[Check[ToExpression[Last[cell],StandardForm],AppendTo[warnings,id];$Failed],_,Function[{v,tag},AppendTo[warnings,id<>" threw"]; $Failed]];AssociateTo[outputs,id->value];If[MemberQ[renderTags,id],Catch[Check[display=If[ValueQ[$PrePrint],$PrePrint[value],value];AssociateTo[rendered,id->With[{v=display},MakeBoxes[v,StandardForm]]],AppendTo[warnings,id<>" render warning"];AssociateTo[rendered,id->$Failed]],_,Function[{v,tag},AppendTo[warnings,id<>" render threw"];AssociateTo[rendered,id->$Failed]]]]]],DeleteCases[inputs,{"load",_}]]];
hasText[b_,str_]:=MemberQ[Cases[b,_String,Infinity],str];
(* Native xTensor uses CurrentValue[FontSize] for indexed tensors. A headless kernel has no font size. Ignore only that exact native style rule, never other failed boxes. *)
headlessFont=(CurrentValue[FontSize]===$Failed);
validRender[b_]:=FreeQ[If[headlessFont,b/.HoldPattern[FontSize->(3 $Failed)/4]:>(FontSize->12),b],$Failed|_Failure|_ErrorBox|_StringJoin|_Table];
checks=<|
 "version"->SameQ[$XPlorerVersion,"1.0.0-beta.1"],
 "registered Lagrangian"->SameQ[outputs["registry_formula"],L],
 "abstract label M"->hasText[rendered["kg_m_abstract"],"M"],
 "abstract label S"->hasText[rendered["abstract_copies"],"S"],
 "rank-two object label"->hasText[rendered["rank_two_s"],"S"],
 "postfix view changes boxes"->(rendered["rank_two_s"]=!=rendered["postfix_view"]),
 "caption without object label"->hasText[rendered["caption"],"Schwarzschild"]&&!hasText[rendered["caption"],"S"],
 "custom metric and derivative"->hasText[rendered["rename_view"],"q"]&&hasText[rendered["rename_view"],"D"],
 "massless abstract equation"->FreeQ[outputs["massless_abstract"],m]&&!FreeQ[outputs["other_abstract"],m],
 "massless rank two"->FreeQ[outputs["rule_eab"],m],
 "wave solution"->SameQ[outputs["wave_solution"],0],
 "comma is a different rendering"->Count[rendered["eq_m_view"],_FractionBox,Infinity]>Count[rendered["partial_compare"],_FractionBox,Infinity],
 "Schwarzschild radial equation"->TrueQ[Simplify[eqS-((1-2 Mbh/rSchw[])u''[rSchw[]]+(2/rSchw[]-2 Mbh/rSchw[]^2)u'[rSchw[]]-m^2 u[rSchw[]])]==0],
 "prime is a different rendering"->Count[rendered["eq_s_view"],_FractionBox,Infinity]>Count[rendered["prime"],_FractionBox,Infinity],
 "Schwarzschild Ricci scalar"->SameQ[outputs["ricci_s"],0],
 "Schwarzschild Kretschmann"->TrueQ[Simplify[outputs["kretschmann_s"]-48 Mbh^2/rSchw[]^6]==0],
 "massless components"->FreeQ[outputs["eq_massless"],m]&&SameQ[outputs["mass_restored"],0],
 "FLRW equation"->TrueQ[Simplify[eqF+q''[tFLRW[]]+3 s'[tFLRW[]]q'[tFLRW[]]/s[tFLRW[]]+m^2 q[tFLRW[]]]==0],
 "FLRW energy density"->TrueQ[Simplify[rhoFLRW-(q'[tFLRW[]]^2+m^2 q[tFLRW[]]^2)/2]==0],
 "caption for density"->hasText[rendered["density_caption"],"FLRW"]&&SameQ[Normal[outputs["density_caption"]],rhoFLRW],
 "second inverse variation"->TrueQ[Simplify[delta2G-DiagonalMatrix[{0,2 gam[tM[],zM[]]^2,2 gam[tM[],zM[]]^2,0}]]===ConstantArray[0,{4,4}]],
 "Taylor coefficient"->TrueQ[Simplify[First[outputs["taylor"]]-delta2G/2]===ConstantArray[0,{4,4}]],
 "Minkowski tensor wave"->TrueQ[Simplify[gwM-(Derivative[2,0][gam][tM[],zM[]]-Derivative[0,2][gam][tM[],zM[]])]==0],
 "FLRW tensor wave"->TrueQ[Simplify[gwF-(Derivative[2,0][gam][tFLRW[],zFLRW[]]+3 Derivative[1][s][tFLRW[]]/s[tFLRW[]] Derivative[1,0][gam][tFLRW[],zFLRW[]]-Derivative[0,2][gam][tFLRW[],zFLRW[]]/s[tFLRW[]]^2)]==0],
 "quadratic wave energy"->TrueQ[Simplify[gwEnergy-Derivative[1,0][gam][tM[],zM[]]^2/(2 kap)]==0],
 "phase average"->TrueQ[Simplify[outputs["gw_average"]-amp^2 w^2/(4 kap)]==0],
 "native perturbation boxes"->AllTrue[Lookup[rendered,{"wave_abstract_m","wave_abstract_f"}],validRender],
 "wave notation"->hasText[rendered["wave_pretty"],"FLRW"]&&SameQ[Normal[outputs["wave_pretty"]],dGF],
 "quadratic field equation"->TrueQ[Simplify[outputs["profile_equation"]-(4-m^2(xM[]^2+yM[]^2))]==0],
 "cylindrical scalar"->SameQ[outputs["profile_c"],rCylindricalM[]^2],
 "cylindrical label"->hasText[rendered["profile_c"],"C"],
 "cylindrical metric"->TrueQ[Simplify[First[outputs["metric_c"]]-DiagonalMatrix[{-1,1,rCylindricalM[]^2,1}]]===ConstantArray[0,{4,4}]],
 "profile restoration"->SameQ[outputs["wave_again"],0],
 "vector norm"->TrueQ[Simplify[outputs["norm"]-(xM[]^2-tM[]^2)]==0],
 "native CTensor"->MatchQ[outputs["ctensor"],_CTensor],
 "two-form norm"->TrueQ[Simplify[outputs["invariant_f"]-2(bf^2-ef^2)]==0],
 "three independent studies"->Length[BackgroundValue[]]===3
 |>;
<|"HeadlessNativeFontSize"->headlessFont,"Inputs"->Length[inputs],"Executed"->Length[outputs],"Warnings"->warnings,"UnexpectedFailures"->Keys@Select[outputs,!FreeQ[#,_Failure|$Failed|$Aborted]&],"Passed"->Count[Values[checks],True],"Total"->Length[checks],"FailedChecks"->Keys@Select[checks,!TrueQ[#]&]|>

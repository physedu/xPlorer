CreateBackground["ViewCase"];
DefScalarFunction[psi];
viewEx=Derivative[1,2][psi][u,v]+Derivative[2][Sin][u];
(* Sin evaluates; the multivariable derivative still exercises the formatter. *)
viewEx=Derivative[1,2][psi][u,v];
Do[
 view=PrettyExp["ViewCase",viewEx,PartialStyle->style];
 assert["view-original-"<>style,Normal[view],viewEx];
 assert["view-copy-"<>style,With[{vv=view},ToExpression[MakeBoxes[vv,StandardForm],StandardForm,HoldComplete]],With[{ee=viewEx},HoldComplete[ee]]];
,{style,{"Native","MultiIndex","Fraction","Partial","Prime"}}];
viewCD=PortExpression["ViewCase",CD[-a][A[-b]]];
Do[
 view=PrettyExp["ViewCase",viewCD,CovariantStyle->style];
 assert["covariant-view-"<>style,Normal[view],viewCD];
 assert["covariant-copy-"<>style,With[{vv=view},ToExpression[MakeBoxes[vv,StandardForm],StandardForm,HoldComplete]],With[{ee=viewCD},HoldComplete[ee]]];
 assert["covariant-boxes-"<>style,With[{vv=view},MatchQ[MakeBoxes[vv,StandardForm],_InterpretationBox]],True];
,{style,{"Prefix","Postfix"}}];
assert["notation-invalid",FailureQ[SetNotation["ViewCase",<|"PartialStyle"->"bad"|>]],True];
SetNotation["ViewCase",<|"PartialStyle"->"Fraction"|>];
assert["notation-call-override",Normal[PrettyExp["ViewCase",viewEx,PartialStyle->"Native"]],viewEx];
assert["pretty-postfix",Normal[viewCD // PrettyExp],viewCD];
assert["pretty-tag-postfix",Normal[viewCD // PrettyExp["ViewCase"]],viewCD];
assert["pretty-options-postfix",Normal[viewEx // PrettyExp[PartialStyle->"Comma"]],viewEx];
assert["pretty-options-direct",Normal[PrettyExp[viewEx,PartialStyle->"Fraction"]],viewEx];
assert["pretty-invalid-tag",FailureQ[viewCD // PrettyExp["UnknownViewCase"]],True];
assert["pretty-invalid-option",FailureQ[viewCD // PrettyExp[PartialStyle->"Bad"]],True];
assert["pretty-auto-owner",With[{vv=viewCD // PrettyExp[ShowBackgroundLabel->True]},!FreeQ[MakeBoxes[vv,StandardForm],"ViewCase"]],True];
assert["pretty-no-owner-label",With[{vv=viewEx // PrettyExp[ShowBackgroundLabel->True]},FreeQ[MakeBoxes[vv,StandardForm],"None"]],True];
assert["basis-missing-guard",FailureQ[ToBasisOf["ViewCase",viewCD]],True];
viewMath=-3 Derivative[1,0][psi][u,v]^2/(u (u-2 v))+2 Derivative[0,1][psi][u,v]-v^2 psi[u,v];
Do[
 view=viewMath // PrettyExp[PartialStyle->style];
 assert["arithmetic-normal-"<>style,Normal[view],viewMath];
 assert["arithmetic-copy-"<>style,With[{vv=view},ToExpression[MakeBoxes[vv,StandardForm],StandardForm,HoldComplete]],With[{ee=viewMath},HoldComplete[ee]]];
 ,{style,{"Fraction","Partial","Comma","MultiIndex","Prime"}}];
viewTeX=ExpressionText[viewMath==0 // PrettyExp[PartialStyle->"Fraction"],"TeX"];
assert["arithmetic-tex-clean",StringQ[viewTeX] && StringFreeQ[viewTeX,"xPlorer"|"notationAtom"|"=="] && StringContainsQ[viewTeX,"\\frac"],True];
assert["tex-failure",FailureQ[ExpressionText[Failure["Test",<||>],"TeX"]],True];
DeleteBackground["ViewCase"];

UndefScalarFunction[psi];

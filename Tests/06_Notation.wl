CreateBackground["ViewCase"];
DefScalarFunction[psi];
viewEx=Derivative[1,2][psi][u,v]+Derivative[2][Sin][u];
(* Sin evaluates; the multivariable derivative still exercises the formatter. *)
viewEx=Derivative[1,2][psi][u,v];
Do[
 view=DisplayExpression["ViewCase",viewEx,PartialStyle->style];
 assert["view-original-"<>style,Normal[view],viewEx];
 assert["view-copy-"<>style,With[{vv=view},ToExpression[MakeBoxes[vv,StandardForm],StandardForm,HoldComplete]],With[{ee=viewEx},HoldComplete[ee]]];
,{style,{"Native","MultiIndex","Fraction","Partial","Prime"}}];
viewCD=PortExpression["ViewCase",CD[-a][A[-b]]];
Do[
 view=DisplayExpression["ViewCase",viewCD,CovariantStyle->style];
 assert["covariant-view-"<>style,Normal[view],viewCD];
 assert["covariant-copy-"<>style,With[{vv=view},ToExpression[MakeBoxes[vv,StandardForm],StandardForm,HoldComplete]],With[{ee=viewCD},HoldComplete[ee]]];
 assert["covariant-boxes-"<>style,With[{vv=view},MatchQ[MakeBoxes[vv,StandardForm],_InterpretationBox]],True];
,{style,{"Prefix","Postfix"}}];
assert["notation-invalid",FailureQ[SetNotation["ViewCase",<|"PartialStyle"->"bad"|>]],True];
SetNotation["ViewCase",<|"PartialStyle"->"Fraction"|>];
assert["notation-call-override",Normal[DisplayExpression["ViewCase",viewEx,PartialStyle->"Native"]],viewEx];
DeleteBackground["ViewCase"];

UndefScalarFunction[psi];

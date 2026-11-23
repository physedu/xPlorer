(* Run in a fresh kernel for a cold-start check. Requires xAct installed. *)
Global`$XPlorerStartupDirectory = DirectoryName[DirectoryName[$InputFileName]];
Global`$XPlorerStartupChecks = Module[
  {directory = Global`$XPlorerStartupDirectory, notebook, inputs, before, result},
  notebook = Get[FileNameJoin[{directory,"xPlorer_Workflow.nb"}]];
  inputs = Cases[notebook,Cell[BoxData[boxes_],"Input",___] :> boxes,Infinity];
  before = MemberQ[$Packages,"xPlorer`"];
  result = Block[{NotebookDirectory = Function[directory], Print = (Null &)},
    ToExpression[First[inputs],StandardForm]];
  <|"PackageWasAlreadyLoaded" -> before,
    "Checks" -> <|
      "SingleGetReturnsNull" -> SameQ[result,Null],
      "PackageLoaded" -> MemberQ[$Packages,"xPlorer`"],
      "PackageVersion" -> SameQ[xPlorer`$XPlorerVersion,"14.0.0-beta.7"],
      "DependenciesAvailable" -> And @@ (MemberQ[$ContextPath,#] & /@
        {"xPlorer`","xAct`xTensor`","xAct`xPert`","xAct`xCoba`"})
    |>
  |>
];
Global`$XPlorerStartupChecks

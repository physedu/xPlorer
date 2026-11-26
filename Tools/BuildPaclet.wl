(* Build a distributable archive on Mathematica Desktop. Do not mistake a staged directory for a successful archive. *)
Needs["PacletTools`"];
Module[{result=PacletBuild[DirectoryName[DirectoryName[$InputFileName]]],archive},
 If[FailureQ[result],Return[result]];
 archive=result["PacletArchive"];
 If[archive===$Failed || !FileExistsQ[archive],Failure["PacletArchive",<|"MessageTemplate"->"No distributable paclet archive was produced.","BuildResult"->result|>],result]
]

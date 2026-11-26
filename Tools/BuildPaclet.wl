(* Build directly from the distributable source tree. No staging or file copies. *)
Needs["PacletTools`"];
Module[{root=DirectoryName[DirectoryName[$InputFileName]],source,out,result,archive},
 source=FileNameJoin[{root,"Paclet"}];
 out=FileNameJoin[{root,"build"}];
 If[!FileExistsQ[FileNameJoin[{source,"PacletInfo.wl"}]],
  Return[Failure["MissingPacletFiles",<|"Path"->source,"MessageTemplate"->"The Paclet source directory is missing."|>]]];
 If[!DirectoryQ[out],CreateDirectory[out]];
 If[!DirectoryQ[out],Return[Failure["PacletOutput",<|"Path"->out|>]]];
 result=PacletBuild[source,out];
 If[FailureQ[result],Return[result]];
 If[!MatchQ[result,Success[_,_Association]],Return[Failure["PacletBuild",<|"BuildResult"->result|>]]];
 archive=Replace[result["PacletArchive"],File[p_String]:>p];
 If[!StringQ[archive] || !FileExistsQ[archive],
  Return[Failure["PacletArchive",<|"MessageTemplate"->"No distributable paclet archive was produced.","BuildResult"->result|>]]];
 Success["PacletBuild",Join[result[[2]],<|"PacletArchive"->archive|>]]
]

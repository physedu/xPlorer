(* Build directly from the distributable source tree. No staging or file copies. *)
Needs["PacletTools`"];
Module[{build},
 build[] := Module[{root=DirectoryName[DirectoryName[$InputFileName]],source,out,result,archive,required,missing},
  source=FileNameJoin[{root,"Paclet"}];
  out=FileNameJoin[{root,"build"}];
  required={"PacletInfo.wl","xPlorer.wl","Kernel/init.m","Kernel/init.wl","LICENSE","CITATION.cff"};
  missing=Select[required,FileType[FileNameJoin[{source,#}]]=!=File&];
  If[missing=!={},
   Return[Failure["MissingPacletFiles",<|"Path"->source,"MissingFiles"->missing,"MessageTemplate"->"The Paclet source directory is incomplete."|>]]];
  If[!FileExistsQ[out],CreateDirectory[out]];
  If[!DirectoryQ[out],Return[Failure["PacletOutput",<|"Path"->out|>]]];
  result=PacletBuild[source,out];
  If[FailureQ[result],Return[result]];
  If[!MatchQ[result,Success[_,_Association]],Return[Failure["PacletBuild",<|"BuildResult"->result|>]]];
  archive=Replace[result["PacletArchive"],File[p_String]:>p];
  If[!StringQ[archive] || FileType[archive]=!=File,
   Return[Failure["PacletArchive",<|"MessageTemplate"->"No distributable paclet archive was produced.","BuildResult"->result|>]]];
  Success["PacletBuild",Join[result[[2]],<|"PacletArchive"->archive|>]]
 ];
 build[]
]

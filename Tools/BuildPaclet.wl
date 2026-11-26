(* The Paclet directory is already the complete distributable tree.
   Archive it directly; PacletBuild would copy it into a second staging tree. *)
Module[{build},
 build[] := Module[{root=DirectoryName[DirectoryName[$InputFileName]],source,out,archive,required,missing},
  source=FileNameJoin[{root,"Paclet"}];
  out=FileNameJoin[{root,"build"}];
  required={"PacletInfo.wl","xPlorer.wl","Kernel/init.m","Kernel/init.wl","LICENSE","CITATION.cff"};
  missing=Select[required,FileType[FileNameJoin[{source,#}]]=!=File&];
  If[missing=!={},
   Return[Failure["MissingPacletFiles",<|"Path"->source,"MissingFiles"->missing,"MessageTemplate"->"The Paclet source directory is incomplete."|>]]];
  If[!FileExistsQ[out],CreateDirectory[out]];
  If[!DirectoryQ[out],Return[Failure["PacletOutput",<|"Path"->out|>]]];
  archive=System`CreatePacletArchive[source,out];
  If[!StringQ[archive] || FileType[archive]=!=File,
   Return[Failure["PacletArchive",<|"MessageTemplate"->"No distributable paclet archive was produced.","ArchiveResult"->archive|>]]];
  Success["PacletBuild",<|"PacletArchive"->archive|>]
 ];
 build[]
]

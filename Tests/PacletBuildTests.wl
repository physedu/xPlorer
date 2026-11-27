(* Run with Get[.../Tests/PacletBuildTests.wl]. No xAct or installed paclet required.
   Exercise deterministic error paths without building or installing an archive. *)
Module[{builder=FileNameJoin[{DirectoryName[DirectoryName[$InputFileName]],"Tools","BuildPaclet.wl"}],
 temp,source,tools,copy,required,missingSource,incompleteSource,blockedOutput,checks},
 temp=CreateDirectory[];
 tools=CreateDirectory[FileNameJoin[{temp,"Tools"}]];
 copy=CopyFile[builder,FileNameJoin[{tools,"BuildPaclet.wl"}]];
 missingSource=Get[copy];
 source=CreateDirectory[FileNameJoin[{temp,"Paclet"}]];
 Export[FileNameJoin[{source,"PacletInfo.wl"}],"(* Test fixture *)","Text"];
 incompleteSource=Get[copy];
 required={"xPlorer.wl","Kernel/init.m","Kernel/init.wl","LICENSE","CITATION.cff"};
 CreateDirectory[FileNameJoin[{source,"Kernel"}]];
 Scan[Export[FileNameJoin[{source,#}],"(* Test fixture *)","Text"]&,required];
 Export[FileNameJoin[{temp,"build"}],"Not a directory","Text"];
 blockedOutput=Get[copy];
 checks=<|
  "Missing source returns Failure"->MatchQ[missingSource,Failure["MissingPacletFiles",_Association]],
  "Incomplete source returns Failure"->MatchQ[incompleteSource,Failure["MissingPacletFiles",_Association]],
  "Missing file list"->(FailureQ[incompleteSource]&&Sort[incompleteSource["MissingFiles"]]===Sort[required]),
  "Output file is not a directory"->MatchQ[blockedOutput,Failure["PacletOutput",_Association]]
 |>;
 DeleteDirectory[temp,DeleteContents->True];
 <|"Total"->Length[checks],"Passed"->Count[Values[checks],True],"Failures"->Keys@Select[checks,#=!=True&]|>
]

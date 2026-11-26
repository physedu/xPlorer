(* Build from a clean distribution tree, not the development repository.
   The allowlist must match PacletInfo.wl. Do not suppress PacletBuild warnings. *)
Needs["PacletTools`"];
Module[{root=DirectoryName[DirectoryName[$InputFileName]],files,missing,temp,stage,
 out,result,archive,destination,copy,report},
 files={"PacletInfo.wl","xPlorer.wl","Kernel/init.m","Kernel/init.wl","LICENSE","CITATION.cff"};
 missing=Select[files,!FileExistsQ[FileNameJoin[{root,#}]]&];
 If[missing=!={},Return[Failure["MissingPacletFiles",<|
  "MessageTemplate"->"Required distribution files are missing.","Files"->missing|>]]];
 temp=Check[CreateDirectory[],$Failed];
 If[!StringQ[temp],Return[Failure["PacletStaging",<|"MessageTemplate"->"Could not create a temporary directory."|>]]];
 stage=FileNameJoin[{temp,"xPlorer"}];
 out=FileNameJoin[{root,"build"}];
 report=Module[{},
  copy=Check[
   CreateDirectory[FileNameJoin[{stage,"Kernel"}],CreateIntermediateDirectories->True];
   Scan[CopyFile[FileNameJoin[{root,#}],FileNameJoin[{stage,#}]]&,files];
   AllTrue[files,FileExistsQ[FileNameJoin[{stage,#}]]&],$Failed];
  If[copy=!=True,Return[Failure["PacletStaging",<|
   "MessageTemplate"->"Could not prepare the clean distribution tree."|>]]];
  result=PacletBuild[stage];
  If[FailureQ[result],Return[result]];
  If[!MatchQ[result,Success[_,_Association]],Return[Failure["PacletBuild",<|
   "MessageTemplate"->"PacletBuild did not return a successful build report.","BuildResult"->result|>]]];
  archive=Replace[result["PacletArchive"],File[p_String]:>p];
  If[!StringQ[archive] || !FileExistsQ[archive],Return[Failure["PacletArchive",<|
   "MessageTemplate"->"No distributable paclet archive was produced.","BuildResult"->result|>]]];
  If[!DirectoryQ[out],Check[CreateDirectory[out],$Failed]];
  If[!DirectoryQ[out],Return[Failure["PacletOutput",<|"Path"->out|>]]];
  destination=FileNameJoin[{out,FileNameTake[archive]}];
  copy=Check[CopyFile[archive,destination,OverwriteTarget->True],$Failed];
  If[copy===$Failed || !FileExistsQ[destination],Return[Failure["PacletOutput",<|
   "MessageTemplate"->"Could not copy the archive to the repository build directory.","Path"->destination|>]]];
  (* The temporary BuildPacletDirectory is removed; expose only the durable archive path. *)
  Success["PacletBuild",Join[KeyDrop[result[[2]],{"BuildPacletDirectory"}],<|"PacletArchive"->destination|>]]
 ];
 Check[DeleteDirectory[temp,DeleteContents->True],Null];
 report
]

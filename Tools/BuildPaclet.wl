(* Build from a clean distribution tree, not the development repository.
   The allowlist must match PacletInfo.wl. Do not suppress PacletBuild warnings. *)
Needs["PacletTools`"];
Module[{root=DirectoryName[DirectoryName[$InputFileName]],files,missing,temp,stage,
 out,result,archive,destination,copy,report,fail},
 files={"PacletInfo.wl","xPlorer.wl","Kernel/init.m","Kernel/init.wl","LICENSE","CITATION.cff"};
 missing=Select[files,!FileExistsQ[FileNameJoin[{root,#}]]&];
 If[missing=!={},Return[Failure["MissingPacletFiles",<|
  "MessageTemplate"->"Required distribution files are missing.","Files"->missing|>]]];
 temp=Check[CreateDirectory[],$Failed];
 If[!StringQ[temp],Return[Failure["PacletStaging",<|"MessageTemplate"->"Could not create a temporary directory."|>]]];
 stage=FileNameJoin[{temp,"xPlorer"}];
 out=FileNameJoin[{root,"build"}];
 fail=Unique["PacletBuildExit"]; 
 report=Catch[
  copy=Check[
   CreateDirectory[FileNameJoin[{stage,"Kernel"}],CreateIntermediateDirectories->True];
   Scan[CopyFile[FileNameJoin[{root,#}],FileNameJoin[{stage,#}]]&,files];
   AllTrue[files,FileExistsQ[FileNameJoin[{stage,#}]]&],$Failed];
  If[copy=!=True,Throw[Failure["PacletStaging",<|
   "MessageTemplate"->"Could not prepare the clean distribution tree."|>],fail]];
  result=PacletBuild[stage];
  If[FailureQ[result],Throw[result,fail]];
  If[!MatchQ[result,Success[_,_Association]],Throw[Failure["PacletBuild",<|
   "MessageTemplate"->"PacletBuild did not return a successful build report.","BuildResult"->result|>],fail]];
  archive=Replace[result["PacletArchive"],File[p_String]:>p];
  If[!StringQ[archive] || !FileExistsQ[archive],Throw[Failure["PacletArchive",<|
   "MessageTemplate"->"No distributable paclet archive was produced.","BuildResult"->result|>],fail]];
  If[!DirectoryQ[out],Check[CreateDirectory[out],$Failed]];
  If[!DirectoryQ[out],Throw[Failure["PacletOutput",<|"Path"->out|>],fail]];
  destination=FileNameJoin[{out,FileNameTake[archive]}];
  copy=Check[CopyFile[archive,destination,OverwriteTarget->True],$Failed];
  If[copy===$Failed || !FileExistsQ[destination],Throw[Failure["PacletOutput",<|
   "MessageTemplate"->"Could not copy the archive to the repository build directory.","Path"->destination|>],fail]];
  (* The temporary BuildPacletDirectory is removed; expose only the durable archive path. *)
  Success["PacletBuild",Join[KeyDrop[result[[2]],{"BuildPacletDirectory"}],<|"PacletArchive"->destination|>]]
 ,fail];
 Check[DeleteDirectory[temp,DeleteContents->True],Null];
 report
]

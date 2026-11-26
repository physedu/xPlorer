(* Build from a clean distribution tree, not the development repository.
   The allowlist must match PacletInfo.wl. Do not suppress PacletBuild warnings. *)
Needs["PacletTools`"];
Module[{root=DirectoryName[DirectoryName[$InputFileName]],files,missing,temp=None,stage,
 out,result,archive,destination,copy,report,fail,copyBytes},
 files={"PacletInfo.wl","xPlorer.wl","Kernel/init.m","Kernel/init.wl","LICENSE","CITATION.cff"};
 (* Local byte copy avoids CopyFile's option dispatch on affected kernels.
    Verify the destination before proceeding; never change the source. *)
 copyBytes[src_String,dst_String]:=Module[{bytes,stream,written,closed},
  bytes=Check[BinaryReadList[src,"Byte"],$Failed];
  If[!ListQ[bytes],Return[$Failed]];
  stream=Check[OpenWrite[dst,BinaryFormat->True],$Failed];
  If[!MatchQ[stream,_OutputStream],Return[$Failed]];
  written=Check[BinaryWrite[stream,bytes,"Byte"],$Failed];
  closed=Check[Close[stream],$Failed];
  If[written===$Failed || closed===$Failed || !FileExistsQ[dst] ||
    Check[FileHash[src,"SHA256"] =!= FileHash[dst,"SHA256"],True],$Failed,dst]
 ];
 fail=Unique["PacletBuildExit"];
 report=Catch[
 missing=Select[files,!FileExistsQ[FileNameJoin[{root,#}]]&];
 If[missing=!={},Throw[Failure["MissingPacletFiles",<|
  "MessageTemplate"->"Required distribution files are missing.","Files"->missing|>],fail]];
 temp=Check[CreateDirectory[],$Failed];
 If[!StringQ[temp],Throw[Failure["PacletStaging",<|"MessageTemplate"->"Could not create a temporary directory."|>],fail]];
 stage=FileNameJoin[{temp,"xPlorer"}];
 out=FileNameJoin[{root,"build"}];
  copy=Check[
   CreateDirectory[FileNameJoin[{stage,"Kernel"}],CreateIntermediateDirectories->True];
   AllTrue[files,StringQ[copyBytes[FileNameJoin[{root,#}],FileNameJoin[{stage,#}]]]&],$Failed];
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
  copy=copyBytes[archive,destination];
  If[copy===$Failed || !FileExistsQ[destination],Throw[Failure["PacletOutput",<|
   "MessageTemplate"->"Could not copy the archive to the repository build directory.","Path"->destination|>],fail]];
  (* The temporary BuildPacletDirectory is removed; expose only the durable archive path. *)
  Success["PacletBuild",Join[KeyDrop[result[[2]],{"BuildPacletDirectory"}],<|"PacletArchive"->destination|>]]
 ,fail];
 If[StringQ[temp] && DirectoryQ[temp],Check[DeleteDirectory[temp,DeleteContents->True],Null]];
 report
]

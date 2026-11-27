(* Prepare a public beta distribution from an already built local paclet.
   This does not publish to GitHub. Load from the repository root or Tools. *)
With[{root=DirectoryName[DirectoryName[$InputFileName]]},
 PrepareXPlorerRelease[archive_String] := Module[
  {source=FileNameJoin[{root,"Paclet"}],version="14.0.0-beta.14",required,files,temp,copy,extract,meta,packRoot,mismatch,build,stage,zip,asset,archiveResult,result},
  required={"PacletInfo.wl","xPlorer.wl","Kernel/init.m","Kernel/init.wl","LICENSE","CITATION.cff"};
  files={"xPlorer_Workflow.nb","xPlorer_API_Examples.nb","LICENSE","CITATION.cff","Release/README.md"};
  If[FileType[archive]=!=File||ToLowerCase[FileExtension[archive]]=!="paclet",Return[Failure["ReleaseArchive",<|"MessageTemplate"->"Choose an existing local .paclet file."|>]]];
  If[!AllTrue[Join[(FileNameJoin[{source,#}]& /@ required),(FileNameJoin[{root,#}]& /@ files)],FileExistsQ],Return[Failure["ReleaseFiles",<|"MessageTemplate"->"The source distribution tree is incomplete."|>]]];
  build=FileNameJoin[{root,"build"}];
  stage=FileNameJoin[{build,"xPlorer-"<>version}];
  zip=stage<>".zip";
  If[FileExistsQ[stage]||FileExistsQ[zip],Return[Failure["ReleaseExists",<|"Path"->stage,"MessageTemplate"->"Move the previous staging directory and ZIP aside before preparing again."|>]]];
  temp=CreateDirectory[];copy=FileNameJoin[{temp,"candidate.zip"}];extract=FileNameJoin[{temp,"archive"}];
  result=Check[CopyFile[archive,copy];CreateDirectory[extract];ExtractArchive[copy,extract],$Failed];
  If[result===$Failed,DeleteDirectory[temp,DeleteContents->True];Return[Failure["ArchiveRead",<|"MessageTemplate"->"Could not extract the supplied paclet."|>]]];
  meta=FileNames["PacletInfo.wl",extract,Infinity];
  If[Length[meta]=!=1,DeleteDirectory[temp,DeleteContents->True];Return[Failure["ArchiveLayout",<|"MessageTemplate"->"Expected one PacletInfo.wl in the archive."|>]]];
  packRoot=DirectoryName[First[meta]];
  mismatch=Select[required,Function[p,!FileExistsQ[FileNameJoin[{packRoot,p}]]||FileHash[FileNameJoin[{packRoot,p}],"SHA256"]=!=FileHash[FileNameJoin[{source,p}],"SHA256"]]];
  DeleteDirectory[temp,DeleteContents->True];
  If[mismatch=!={},Return[Failure["ArchiveMismatch",<|"Files"->mismatch,"MessageTemplate"->"The paclet does not match the current source tree. Rebuild before distribution."|>]]];
  If[!DirectoryQ[build],CreateDirectory[build]];
  result=Check[
   CreateDirectory[stage];CreateDirectory[FileNameJoin[{stage,"Paclet","Kernel"}],CreateIntermediateDirectories->True];
   Scan[CopyFile[FileNameJoin[{source,#}],FileNameJoin[{stage,"Paclet",#}]]&,required];
   Scan[CopyFile[FileNameJoin[{root,#}],FileNameJoin[{stage,FileNameTake[#]}]]&,files];
   asset=FileNameJoin[{stage,"xPlorer-"<>version<>".paclet"}];CopyFile[archive,asset];
   Null,$Failed];
  If[result===$Failed,Return[Failure["ReleaseStaging",<|"Path"->stage,"MessageTemplate"->"Staging failed; inspect the partial local directory."|>]]];
  archiveResult=Check[CreateArchive[stage,zip],$Failed];
  If[archiveResult===$Failed||!FileExistsQ[zip],
    Return[Failure["ReleaseZip",<|"StagedDirectory"->stage,"Paclet"->asset,"MessageTemplate"->"The verified distribution folder is ready, but ZIP creation failed. Compress the folder manually."|>]]];
  Success["ReleasePrepared",<|"Directory"->stage,"ZIP"->zip,"Paclet"->asset,"SHA256"->IntegerString[FileHash[zip,"SHA256"],16,64]|>]
 ];
];

(* Install a traditional Mathematica application from a downloaded repository.
   Load this file once, then evaluate InstallXPlorer[].
   An existing installation is never overwritten automatically. *)
With[{source=FileNameJoin[{DirectoryName[$InputFileName],"Paclet"}]},
 InstallXPlorer[applicationDirectory_String]:=Module[
  {target=FileNameJoin[{applicationDirectory,"xPlorer"}],files={"xPlorer.wl","LICENSE","CITATION.cff","Kernel/init.m","Kernel/init.wl"},staging,result},
  If[FileExistsQ[target],Return[Failure["AlreadyInstalled",<|"MessageTemplate"->"An xPlorer application already exists. Move it to a backup location before installing another version.","Path"->target|>]]];
  If[!AllTrue[files,FileExistsQ[FileNameJoin[{source,#}]]&],Return[Failure["MissingFiles",<|"MessageTemplate"->"Download and extract the complete repository before installing.","Source"->source|>]]];
  If[!DirectoryQ[applicationDirectory],Quiet[Check[CreateDirectory[applicationDirectory,CreateIntermediateDirectories->True],Null]]];
  If[!DirectoryQ[applicationDirectory],Return[Failure["InstallDirectory",<|"Path"->applicationDirectory|>]]];
  staging=CreateDirectory[FileNameJoin[{applicationDirectory,"xPlorer-install-"<>CreateUUID[]}]];
  If[!StringQ[staging],Return[Failure["InstallDirectory",<|"Path"->applicationDirectory|>]]];
  result=Quiet@Check[
   CreateDirectory[FileNameJoin[{staging,"Kernel"}]];
   Scan[CopyFile[FileNameJoin[{source,#}],FileNameJoin[{staging,#}]]&,files];
   If[!AllTrue[files,FileExistsQ[FileNameJoin[{staging,#}]]&],$Failed,RenameDirectory[staging,target]],$Failed];
  If[result===$Failed,If[DirectoryQ[staging],DeleteDirectory[staging,DeleteContents->True]];
   Return[Failure["InstallFailed",<|"Path"->target|>]]];
  <|"Installed"->target,"Next"->"Restart the kernel and evaluate Needs[\"xPlorer`\"] (xAct must be installed separately)."|>
 ];
];
InstallXPlorer[]:=InstallXPlorer[FileNameJoin[{$UserBaseDirectory,"Applications"}]];

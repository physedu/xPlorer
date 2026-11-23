(* Build an archive after validating the package. Requires PacletTools. *)
Needs["PacletTools`"];
PacletBuild[DirectoryName[DirectoryName[$InputFileName]]]

(* Run in a fresh kernel after editing tutorial_cells.json, then run build_notebook.py. *)
Module[{directory=DirectoryName[$InputFileName],cells,make,cache},
 cells=Import[FileNameJoin[{directory,"tutorial_cells.json"}],"RawJSON"];
 make[s_] := ToExpression["("<>s<>"\n)",InputForm,
  Function[expr,ToString[MakeBoxes[expr,StandardForm],InputForm,CharacterEncoding->"ASCII",PageWidth->Infinity],HoldAllComplete]];
 cache=Association[(#["code"]->make[#["code"]])& /@ Select[cells,#["kind"]==="input"&]];
 Export[FileNameJoin[{directory,"input_boxes.json"}],cache,"RawJSON"]
]

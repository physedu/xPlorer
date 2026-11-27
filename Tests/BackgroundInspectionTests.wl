(* Background inspection is a read-only display, never a calculation. *)
If[!MemberQ[$Packages,"xPlorer`"],Get[FileNameJoin[{DirectoryName[DirectoryName[$InputFileName]],"Paclet","xPlorer.wl"}]]];
Block[{xAct`xPerm`$xpermQ=False,xAct`xTensor`$DefInfoQ=False,xAct`xCoba`$CVVerbose=False},
 checks=<||>; boxes[e_]:=With[{v=e},MakeBoxes[v,StandardForm]];
 checks["empty overview"]=MatchQ[ShowBackground[],_Grid];
 checks["unknown tag"]=FailureQ[ShowBackground["Absent"]]&&FailureQ[BackgroundValue["Absent"]];
 DefManifold[M,4,{a,b,c,d,e,f,i,j}]; DefMetric[-1,g[-a,-b],CD]; DefTensor[phi[],M]; DefTensor[A[-a],M]; DefTensor[F[-a,-b],M,Antisymmetric[{-a,-b}]]; DefConstantSymbol[m];
 RegisterTheory["Metric",g]; RegisterTheory["CovD",CD]; RegisterTheory["Indices",{a,b,c,d,e,f,i,j}]; RegisterTheory["Fields",{phi,A,F}]; RegisterTheory["Parameter",m];
 L=-CD[-a][phi[]] CD[a][phi[]]/2-m^2 phi[]^2/2;
 RegisterTheory["Lagrangian","Scalar"->L]; RegisterTheory["Expression","KG"->VarD[phi[],CD][L]]; RegisterTheory["Title","Massive scalar"];
 CreateBackground["Study",SymbolSuffix->"S",BackgroundLabel->"S",ShowObjectLabels->True];
 before=BackgroundValue[];
 empty=ShowBackground["Study"]; emptyBoxes=boxes[empty];
 checks["abstract summary"]=MatchQ[empty,_Column]&&!FreeQ[empty,"Not assigned"]&&FreeQ[empty,_Failure|_Missing];
 checks["abstract unchanged"]=SameQ[before,BackgroundValue[]];
 checks["summary alias"]=SameQ[empty,ShowBackground["Study","Summary"]];
 DefineChart["Study",{t[],x[],y[],z[]}];
 DefineChart["Study","Scaled",{T[],u[],v[],w[]},Function[{tt,xx,yy,zz},{tt,2 xx,yy,zz}]];
 MetricInBasis[gS,-chartS,DiagonalMatrix[{-1,1,1,1}]]; ComponentValue[phiS[],xS[]^2];
 AllComponentValues[AS[{-aS,-chartS}],{1,2,3,4}]; ComponentValue[FS[{1,-chartS},{0,-chartS}],3];
 RegisterProfile["Study","Initial"]; SetRuleGroup["Study","Massless",{m->0}]; ActivateRuleGroups["Study",{"Massless"}]; SaveResult["Study","Example",28];
 CreateBackground["Other",SymbolSuffix->"O"];
 before=BackgroundValue[];
 nativeBefore=TensorValues[AS];
 sections={"Geometry","Fields","Connections","Charts","Rules","Profiles","Results","Presentation","Lagrangians","Expressions"};
 views=AssociationMap[ShowBackground["Study",#]&,sections];
 filled=ShowBackground["Study"]; all=ShowBackground[];
 rendered=boxes /@ Join[Values[views],{filled,all}];
 checks["all sections valid"]=AllTrue[Values[views],MatchQ[#,_Grid|_Column]&&FreeQ[#,_Failure|_Missing]&];
 checks["rendered all sections"]=FreeQ[rendered,_Failure|_Missing|_MakeBoxes];
 checks["filled summary"]=MatchQ[filled,_Column]&&!FreeQ[filled,"Study"]&&!FreeQ[filled,"Massive scalar"]&&FreeQ[filled,_Failure|_Missing];
 checks["profiles"]=!FreeQ[views["Profiles"],"Initial"];
 checks["rules"]=!FreeQ[views["Rules"],"Massless"];
 checks["results"]=!FreeQ[views["Results"],"Example"];
 checks["actual field inputs"]=!FreeQ[views["Fields"],xS[]^2]&&!FreeQ[views["Fields"],{1,2,3,4}];
 checks["partial is not zero-filled"]=!FreeQ[views["Fields"],"Partial input (unassigned slots unknown)"];
 checks["field aliases"]=!FreeQ[views["Fields"],"phiS"]&&!FreeQ[views["Fields"],"AS"];
 checks["chart names"]=!FreeQ[views["Charts"],"Scaled"]&&!FreeQ[views["Charts"],"chartS"];
 checks["list includes both"]=!FreeQ[all,"Study"]&&!FreeQ[all,"Other"];
 checks["actual matrix"]=SameQ[BackgroundValue["Study","MetricMatrix"],DiagonalMatrix[{-1,1,1,1}]];
 checks["raw record compatibility"]=SameQ[BackgroundValue["Study"],$BG["Study"]]&&SameQ[Keys[BackgroundValue["Study","Fields"]],{"phi","A","F"}];
 checks["section key"]=SameQ[BackgroundValue["Study","Fields","phi"]["NewHead"],phiS];
 checks["unknown section and key"]=FailureQ[ShowBackground["Study","Unknown"]]&&FailureQ[BackgroundValue["Study","Fields","Unknown"]];
 checks["stored result remains"]=SameQ[ResultOf["Study","Example"],28];
 checks["inspection leaves all records unchanged"]=SameQ[before,BackgroundValue[]];
 checks["inspection leaves native field values unchanged"]=SameQ[nativeBefore,TensorValues[AS]];
 <|"Version"->$XPlorerVersion,"Passed"->Count[Values[checks],True],"Total"->Length[checks],"Failures"->Keys@Select[checks,!TrueQ[#]&]|>
]

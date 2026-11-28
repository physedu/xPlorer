(* Optional xTras: derive once and compare two independent component studies.
   Load xPlorer before this file, in a fresh kernel with xTras installed. *)
Needs["xAct`xTras`"];
DefManifold[TrasM,4,{aa,bb,cc,dd,ee,ff,ii,jj}];
DefMetric[-1,gg[-aa,-bb],CDa];DefTensor[phia[],TrasM];DefConstantSymbol[mass];
lagG=RicciScalarCDa[];
lagP=-(CDa[-aa][phia[]] CDa[aa][phia[]]+mass^2 phia[]^2)/2;
eqG=ToCanonical@ContractMetric@VarL[gg[aa,bb],CDa][lagG];
eqP=ToCanonical@ContractMetric@VarD[phia[],CDa][lagP];
RegisterTheory["Metric",gg];RegisterTheory["CovD",CDa];RegisterTheory["Indices",{aa,bb,cc,dd,ee,ff,ii,jj}];
RegisterTheory["Field",phia];RegisterTheory["Parameter",mass];
RegisterTheory["Lagrangians",{"Gravity"->lagG,"Matter"->lagP}];
RegisterTheory["Expressions",{"MetricEOM"->eqG,"ScalarEOM"->eqP}];
CreateBackground["Flat",SymbolSuffix->"F"];CreateBackground["Cosmo",SymbolSuffix->"C"];
DefineChart["Flat",{tt[],xx[],yy[],zz[]}];DefineChart["Cosmo",{tt[],xx[],yy[],zz[]}];
MetricInBasis[ggF,{-1,1,1,1}];MetricInBasis[ggC,{-1,ttC[]^2,ttC[]^2,ttC[]^2}];
ComponentValue[phiaF[],ttF[]^2];ComponentValue[phiaC[],ttC[]^2];
flatG=ToComponents["Flat",eqGF,StrictComponents->True];
cosmoG=ToComponents["Cosmo",eqGC,StrictComponents->True];
flatP=ToComponents["Flat",eqPF,StrictComponents->True];
cosmoP=ToComponents["Cosmo",eqPC,StrictComponents->True];
checks=<|
 "Native VarL gives Ricci minus half metric times scalar"->TrueQ[ToCanonical[eqG-(RicciCDa[-aa,-bb]-gg[-aa,-bb] RicciScalarCDa[]/2)]===0],
 "Flat Einstein components"->SameQ[flatG,ConstantArray[0,{4,4}]],
 "FLRW Einstein components"->TrueQ[Simplify[cosmoG==DiagonalMatrix[{3/ttC[]^2,-1,-1,-1}]]],
 "Flat scalar equation"->TrueQ[Simplify[flatP==-2-mass^2 ttF[]^2]],
 "FLRW scalar equation"->TrueQ[Simplify[cosmoP==-8-mass^2 ttC[]^2]],
 "Native Einstein component comparison"->TrueQ[Simplify[cosmoG==ToComponents["Cosmo",EinsteinCDa[-aa,-bb],StrictComponents->True]]]
|>;
<|"Total"->Length[checks],"Passed"->Count[Values[checks],True],"Failures"->Keys@Select[checks,#=!=True&]|>

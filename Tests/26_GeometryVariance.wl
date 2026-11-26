(* Native geometry variances and imploded derivative invalidation. *)
DefManifold[MN,4,{a,b,c,d,e,f}];DefMetric[-1,g[-a,-b],CD];
RegisterTheory["Metric",g];RegisterTheory["CovD",CD];RegisterTheory["Indices",{a,b,c,d,e,f}];
CreateBackground["N"];CreateBackground["O"];DefineChart["N",{"t","x","y","z"}];DefineChart["O",{"t","x","y","z"}];
ch=ChartOf["N"];co=ChartOf["O"];x=CoordinatesOf["N"][[2]][];
MetricInBasis[gN,{-Exp[2 x],1,1,1}];MetricInBasis[gO,{-1,1,1,1}];
ri=Ricci[ConnectionOf["N"]];rm=Riemann[ConnectionOf["N"]];ro=Ricci[ConnectionOf["O"]];
r0=ToValues[ri[{0,ch},{0,ch}]];r1=Last[ComponentValue[ri[{0,ch},{0,-ch}]]];
data=xPlorer`Private`geometryNativeData[ShowBackground["N"]];
dm=xPlorer`Private`nativeGeometrySpecHead["DMetric"[-1,-1,-1],data];
ddm=xPlorer`Private`nativeGeometrySpecHead["DDMetric"[-1,-1,-1,-1],data];
d0=ToValues[dm[{0,-ch},{0,-ch},{1,-ch}]];
checks=<|"Raised Ricci calculated lazily"->(Simplify[r0===Exp[-2 x]]===True&&r1===-1),
"Metric derivative initial value"->(d0===-2 Exp[2 x]),
"Second derivative native group present"->(TensorValIDs[ddm]=!={}),
"Unrequested background unchanged"->(TensorValIDs[ro]==={})|>;
(* Instrument actual conversion calls on repeated reads. *)
calls=0;Internal`InheritedBlock[{ChangeComponents},Unprotect[ChangeComponents];
 ChangeComponents[f_,i_] /; !TrueQ[countingCC] := Block[{countingCC=True},calls++;ChangeComponents[f,i]];
 Protect[ChangeComponents];r2=ToValues[ri[{0,ch},{0,ch}]]];
checks["Repeated native variance avoids conversion"]=calls===0&&r2===r0;
sourceSpec=xPlorer`Private`chooseGeometrySource[ShowBackground["N"],ri,{1,1},{"Ricci"[-1,-1]}];
checks["Cached geometry source is a native specification"]=sourceSpec==="Ricci"[-1,-1];
DeleteTensorValues[ri,{{ch,ch}}];checks["Deleted raised geometry rebuilt"]=ToValues[ri[{0,ch},{0,ch}]]===r0;
(* A standard source plus native transformation must support another Riemann variance. *)
rr=ToValues[rm[{0,ch},{1,ch},{0,ch},{1,ch}]];
checks["Nonstandard Riemann variance"]=Simplify[rr-Exp[-2 x]]===0;
MetricInBasis[gN,{-4 Exp[2 x],1,1,1},ComputeOnSet->None];
checks["Imploded derivative groups invalidated"]=TensorValIDs[dm]==={}&&TensorValIDs[ddm]==={};
checks["Derivative tensor definitions retained"]=xTensorQ[dm]&&xTensorQ[ddm];
checks["Native derivative lazy rebuild"]=ToValues[dm[{0,-ch},{0,-ch},{1,-ch}]]===-8 Exp[2 x];
checks["Raised Ricci updated"]=Simplify[ToValues[ri[{0,ch},{0,ch}]]-Exp[-2 x]/4]===0;
checks["Other background isolated"]=MetricMatrixOf["O"]===DiagonalMatrix[{-1,1,1,1}];
checks["Cleanup"]=And@@(SameQ[DeleteBackground[#],Null]& /@ {"N","O"});
<|"Total"->Length[checks],"Passed"->Count[Values[checks],True],"Failures"->Keys@Select[checks,#=!=True&]|>

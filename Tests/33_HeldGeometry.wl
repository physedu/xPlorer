(* Literal native held metric edits and geometry reads, rule-state authoritative replay. *)
DefManifold[MN,4,{a,b,c,d,e,f}];DefMetric[-1,g[-a,-b],CD];DefTensor[A[-a],MN];RegisterTheory["Metric",g];RegisterTheory["CovD",CD];RegisterTheory["Indices",{a,b,c,d,e,f}];RegisterTheory["Fields",{A}];
CreateBackground["N"];CreateBackground["O"];DefineChart["N",{"t","x","y","z"}];DefineChart["O",{"t","x","y","z"}];ch=ChartOf["N"];co=ChartOf["O"];x=CoordinatesOf["N"][[2]][];
MetricInBasis[gN,{-Exp[2x],1,1,1}];MetricInBasis[gO,{-1,1,1,1}];AllComponentValues[AN[-aN],{1,2,3,4}];ri=Ricci[ConnectionOf["N"]];rs=RicciScalar[ConnectionOf["N"]];ro=Ricci[ConnectionOf["O"]];ei=Einstein[ConnectionOf["N"]];we=Weyl[ConnectionOf["N"]];
r=With[{head=ri,chart=ch},HeldComponentValue[head[{0,-chart},{0,-chart}]]];runs=ShowBackground["N"]["GeometryRuns"];
checks=<|"Held first Ricci read computes requested curvature"->(MatchQ[r,_Rule]&&Last[r]===Exp[2x]&&MemberQ[ShowBackground["N"]["ComputedGeometry"],"Ricci"])|>;
r2=With[{head=ri,chart=ch},HeldComponentValue[head[{0,-chart},{0,-chart}]]];
checks["Repeated held curvature read reuses native computation"]=r===r2&&ShowBackground["N"]["GeometryRuns"]===runs;
checks["Held scalar geometry read"]=Last[With[{head=rs},HeldComponentValue[head[]]]]===-2;
checks["Held geometry alternate variance"]=Simplify[Last[With[{head=ri,chart=ch},HeldComponentValue[head[{0,chart},{0,chart}]]]]-Exp[-2x]]===0;
checks["Unrequested geometry and other background untouched"]=TensorValIDs[we]==={}&&TensorValIDs[ei]==={}&&TensorValIDs[ro]==={};
gamma=GiveSymbol[Christoffel,Sequence@@Sort[{ConnectionOf["N"],PDOfBasis[ch]}]];
gr=With[{head=gamma,chart=ch},HeldComponentValue[head[{0,chart},{0,-chart},{1,-chart}]]];
checks["Held literal Christoffel head uses native geometry"]=MatchQ[gr,_Rule]&&Last[gr]===1;
checks["Compound Christoffel head is not a literal held symbol"]=With[{head=Christoffel[ConnectionOf["N"],PDOfBasis[ch]],chart=ch},!xPlorer`Private`managedHeldGeometryReadQ[head,head[{0,chart},{0,-chart},{1,-chart}]]];
data=xPlorer`Private`geometryNativeData[ShowBackground["N"]];
dm=xPlorer`Private`nativeGeometrySpecHead["DMetric"[-1,-1,-1],data];
ddm=xPlorer`Private`nativeGeometrySpecHead["DDMetric"[-1,-1,-1,-1],data];
checks["Held derivative geometry read"]=Last[With[{head=dm,chart=ch},HeldComponentValue[head[{0,-chart},{0,-chart},{1,-chart}]]]]===-2 Exp[2x];
DeleteTensorValues[ddm];
checks["Held second derivative geometry rebuilds native group"]=Last[With[{head=ddm,chart=ch},HeldComponentValue[head[{0,-chart},{0,-chart},{1,-chart},{1,-chart}]]]]===-4 Exp[2x];

a0=ToValues[AN[{0,ch}]];source=TensorValues[AN,{{-ch}}];rev=ShowBackground["N"]["MetricRevision"];
r=Block[{$CVSimplify=Function[v,v+100]},With[{head=gN,chart=ch},HeldComponentValue[head[{0,-chart},{0,-chart}],-4 Exp[2x]]]];
checks["Held metric write bypasses ambient CVSimplify"]=MatchQ[r,_Rule]&&Last[r]===-4 Exp[2x]&&MetricMatrixOf["N"]===DiagonalMatrix[{-4 Exp[2x],1,1,1}]&&ToValues[gN[{0,-ch},{0,-ch}]]===-4 Exp[2x];
checks["Metric edit invalidates derived geometry and field"]=ShowBackground["N"]["MetricRevision"]===rev+1&&TensorValIDs[ri]==={}&&TensorValIDs[AN]==={ValID[AN,{{-ch}}]}&&TensorValues[AN,{{-ch}}]===source;
checks["Held inverse and Ricci use edited metric"]=Last[With[{head=gN,chart=ch},HeldComponentValue[head[{0,chart},{0,chart}]]]]===-Exp[-2x]/4&&Last[With[{head=ri,chart=ch},HeldComponentValue[head[{0,-chart},{0,-chart}]]]]===4 Exp[2x]&&ToValues[AN[{0,ch}]]===-Exp[-2x]/4;
r=With[{head=gN,chart=ch},HeldComponentValue[head[{0,chart},{0,chart}],-Exp[-2x]/8]];
checks["Held upper metric edit updates covariant matrix"]=MatchQ[r,_Rule]&&MetricMatrixOf["N"][[1,1]]===-8 Exp[2x];
rev=ShowBackground["N"]["MetricRevision"];rr=ToValues[ri[{0,-ch},{0,-ch}]];raw=TensorValues[ri];
bad=With[{head=gN,chart=ch},HeldComponentValue[head[{0,-chart},{0,-chart}],0]];
checks["Held singular metric rejected before mutation"]=FailureQ[bad]&&MetricMatrixOf["N"][[1,1]]===-8 Exp[2x]&&TensorValues[ri]===raw&&ShowBackground["N"]["MetricRevision"]===rev;
Block[{$CVReplace=False},With[{head=gN,chart=ch},HeldComponentValue[head[{0,-chart},{0,-chart}],-9 Exp[2x]]]];
checks["Held metric respects native CVReplace"]=MetricMatrixOf["N"][[1,1]]===-8 Exp[2x]&&ShowBackground["N"]["MetricRevision"]===rev;
With[{head=gN,chart=ch},HeldComponentValue[head[{0,-chart},{1,-chart}],1]];
checks["Held off-diagonal symmetric metric edit"]=MetricMatrixOf["N"][[1,2]]===1&&MetricMatrixOf["N"][[2,1]]===1;
mat=MetricMatrixOf["N"];Block[{$CVSimplify=Function[v,v+100]},ClearComputedValues["N"]];
checks["Managed metric replay preserves exact recorded input"]=ToValues[ComponentArray[gN,{-ch,-ch}],gN]===mat;
recipe=ReconstructionData["N"];copy=RecreateBackground["Copy",recipe];cc=ChartOf["Copy"];xc=CoordinatesOf["Copy"][[2]][];
checks["Held metric reconstructs with remapped coordinates"]=AssociationQ[copy]&&MetricMatrixOf["Copy"]===(mat/.x->xc)&&ToValues[gCopy[{0,-cc},{0,-cc}]]===-8 Exp[2xc];
checks["Other background isolated"]=MetricMatrixOf["O"]===DiagonalMatrix[{-1,1,1,1}]&&TensorValIDs[ro]==={};
(* Literal geometry queries must not evaluate aliases before checking ownership. *)
checks["Held geometry alias arguments excluded"]=With[{head=ri,chart=ch},!xPlorer`Private`managedHeldGeometryReadQ[head,head[{i,-chart},{0,-chart}]]&&!xPlorer`Private`managedHeldGeometryReadQ[head,head[{0,-ch},{0,-ch}]]];
(* Force native preparation failures; each must propagate past the Do loop. *)
mock=Failure["MockPreparation",<||>];
f1=Internal`InheritedBlock[{xPlorer`Private`captureNativeMetricCompute},
 xPlorer`Private`captureNativeMetricCompute[___]:=mock;
 (* Exact more-specific native signature replaced, not a generic fallback. *)
 xPlorer`Private`captureNativeMetricCompute[tag_,cch_,what_,opts___Rule]:=mock;
 ToValues[ei[{0,-ch},{0,-ch}]]];
checks["Geometry preparation failure propagates"]=f1===mock;
f2=Internal`InheritedBlock[{xPlorer`Private`ensureFieldConfiguration},
 xPlorer`Private`ensureFieldConfiguration[b_,rec_,signs_]:=mock;
 AllComponentValues[AN[{aN,ch}]]];
checks["Full field preparation failure propagates"]=f2===mock;
f3=Internal`InheritedBlock[{xPlorer`Private`ensureSelectedFieldComponent},
 xPlorer`Private`ensureSelectedFieldComponent[b_,rec_,atom_]:=mock;
 ToValues[AN[{0,ch}]]];
checks["Selected field preparation failure propagates"]=f3===mock;

gid=SelectFirst[TensorValIDs[gN],MemberQ[Last[List@@#],{-ch,-ch}]&];RuleToSet[gid];
checks["Held literal metric Set accesses blocked"]=MatchQ[With[{head=gN,chart=ch},HeldComponentValue[head[{0,-chart},{0,-chart}]]],Failure["NativeSetState",_Association]]&&MatchQ[With[{head=gN,chart=ch},HeldComponentValue[head[{0,-chart},{0,-chart}],-10 Exp[2x]]],Failure["NativeSetState",_Association]]&&xAct`xCoba`Private`StateOfValID[gid]===Set;
SetToRule[gid];
checks["Held metric access resumes after SetToRule"]=Last[With[{head=gN,chart=ch},HeldComponentValue[head[{0,-chart},{0,-chart}]]]]===-8 Exp[2x];
DefChart[originalChart,MN,Range[0,3],{u0[],u1[],u2[],u3[]}];
rrNative=HeldComponentValue[A[{0,-originalChart}],17];rrNativeRead=HeldComponentValue[A[{0,-originalChart}]];
checks["External native held operations untouched"]=MatchQ[rrNative,_Rule]&&rrNativeRead===rrNative&&Last[rrNativeRead]===17;
checks["Held native attribute retained"]=MemberQ[Attributes[HeldComponentValue],HoldFirst]&&MemberQ[Attributes[HeldComponentValue],Protected];
checks["Cleanup"]=And@@(SameQ[DeleteBackground[#],Null]& /@ {"Copy","N","O"});
<|"Total"->Length[checks],"Passed"->Count[Values[checks],True],"Failures"->Keys@Select[checks,#=!=True&]|>

(* Diagnostic only: known open HeldComponentValue issue, not a passing regression suite. Fresh kernel with xPlorer loaded. *)
DefManifold[MN,4,{a,b,c,d,e,f}]; DefMetric[-1,g[-a,-b],CD];
DefTensor[A[-a],MN]; DefTensor[phi[],MN];
RegisterTheory["Metric",g]; RegisterTheory["CovD",CD]; RegisterTheory["Indices",{a,b,c,d,e,f}]; RegisterTheory["Fields",{A,phi}];
CreateBackground["N"]; DefineChart["N",{"t","x","y","z"}]; ch=ChartOf["N"]; MetricInBasis[gN,DiagonalMatrix[{-1,1,1,1}]];
ComponentValue[AN[{0,-ch}]->1];
ComponentValue[{AN[{1,-ch}]->2,AN[{2,-ch}]->3}];
ComponentValue[{AN[{0,-ch}],AN[{3,-ch}]},{4,5}];
ordinary=ShowBackground["N"]["FieldComponents"];
hh=BackgroundObject["N","A"]; ph=BackgroundObject["N","phi"];
With[{h=hh,bb=ch},HeldComponentValue[h[{0,-bb}],7]];
heldNative=ToValues[AN[{0,-ch}]]; heldRegistry=ShowBackground["N"]["FieldComponents"];
heldQuery=With[{h=hh,bb=ch},HeldComponentValue[h[{0,bb}]]];
ordinaryQuery=ToValues[AN[{0,ch}]];
With[{h=ph},HeldComponentValue[h[],9]];
scalarNative=ToValues[phiN[]]; scalarRegistry=ShowBackground["N"]["FieldComponents"];
ClearComputedValues["N"]; afterClear=ToValues[AN[{0,-ch}]]; scalarAfterClear=ToValues[phiN[]];
<|"OrdinaryListAndRuleRecords"->ordinary,"HeldNativeValue"->heldNative,"RegistryUnchangedAfterHeldWrite"->SameQ[ordinary,heldRegistry],"HeldRaisedRule"->heldQuery,"OrdinaryRaisedValue"->ordinaryQuery,"HeldScalarValue"->scalarNative,"RegistryUnchangedAfterHeldScalar"->SameQ[heldRegistry,scalarRegistry],"VectorAfterClear"->afterClear,"ScalarAfterClear"->scalarAfterClear|>

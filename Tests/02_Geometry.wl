tagSchw = "XPTestSchw" <> StringTake[CreateUUID[],8];
makeBackground[tagSchw,{"t","r","theta","varphi"},
 Function[{t,r,th,ph},DiagonalMatrix[{-(1-2Mbh/r),1/(1-2Mbh/r),r^2,r^2 Sin[th]^2}]],
 Assumptions->Function[{t,r,th,ph},Mbh>0 && r>2Mbh && 0<th<Pi]];
radius = CoordinatesOf[tagSchw][[2]][];
SetFieldComponents[tagSchw,phi,Function[{t,r,th,ph},r^2]];
assert["schwarzschild-ricci", ToComponents[tagSchw,Ricci[CD][-a,-b]], ConstantArray[0,{4,4}]];
assert["schwarzschild-kretschmann", Simplify[ToComponents[tagSchw,Kretschmann[CD][]]-48Mbh^2/radius^6], 0];
assert["curved-scalar-gradient", ToComponents[tagSchw,CD[-a][phi[]]], {0,2radius,0,0}];
assert["curved-scalar-box", Simplify[ToComponents[tagSchw,CD[a][CD[-a][phi[]]]]-(6-8Mbh/radius)], 0];
assert["schwarzschild-identities", CheckBackground[tagSchw,Checks->{"MetricCompatibility","Bianchi","Signature"}]["Status"], "Passed"];
assert["coexisting-background-isolation", ToComponents[tagMink,phi[]], 7];
tagFLRW = "XPTestFLRW" <> StringTake[CreateUUID[],8];
DefScalarFunction[scale];
makeBackground[tagFLRW,{"t","x","y","z"},Function[{t,x,y,z},DiagonalMatrix[{-1,scale[t]^2,scale[t]^2,scale[t]^2}]],
 Assumptions->Function[{t,x,y,z},scale[t]>0]];
time = CoordinatesOf[tagFLRW][[1]][];
assert["flrw-friedmann", Simplify[First[ToComponents[tagFLRW,Einstein[CD][-a,-b],Components->{{0,0}}]]-3(scale'[time]/scale[time])^2], 0];
assert["flrw-bianchi", CheckBackground[tagFLRW,Checks->{"MetricCompatibility","Bianchi"}]["Status"], "Passed"];

(* Einstein-Hilbert gravity coupled to a real massive scalar.
   Run in a fresh kernel. xTras is optional for xPlorer but required here.
   The registered Lagrangians are scalars; VarL includes the volume factor. *)

Needs["xAct`xTras`"];
Needs["xPlorer`"];

DefManifold[MEH, 4, {a, b, c, d, e, f}];
DefMetric[-1, g[-a, -b], CD];
DefTensor[phi[], MEH];
DefConstantSymbol[m];
DefConstantSymbol[kappa];

(* S = Integrate[Sqrt[-Det[g]] Ltotal, coordinates].
   This symbolic action is represented by its scalar integrand Ltotal. *)

Lgrav = RicciScalarCD[]/(2 kappa);
Lkin = -1/2 CD[-a][phi[]] CD[a][phi[]];
Lmass = -1/2 m^2 phi[]^2;
Lmatter = Lkin + Lmass;
Ltotal = Lgrav + Lmatter;

(* Scalar variation holds the metric fixed.
   Metric variation with respect to the inverse metric includes the volume variation.
   Boundary terms are discarded; assume appropriate boundary conditions. *)

scalarEq = VarD[phi[], CD][Ltotal] // ContractMetric // ToCanonical;
metricEq = VarL[g[a, b], CD][Ltotal] // ContractMetric // ToCanonical;

(* metricEq = (G_ab/kappa - T_ab)/2. *)

stressTensor = CD[-a][phi[]] CD[-b][phi[]] -
  1/2 g[-a, -b] (CD[-c][phi[]] CD[c][phi[]] + m^2 phi[]^2);
metricReference = (RicciCD[-a, -b] - 1/2 g[-a, -b] RicciScalarCD[])/(2 kappa) - stressTensor/2;

RegisterTheory["Title", "Einstein gravity with a massive scalar"];
RegisterTheory["Description", "Einstein-Hilbert action plus a minimally coupled real scalar."];
RegisterTheory["Conditions", "Fixed metric in scalar variation; inverse metric variation with boundary terms discarded."];
RegisterTheory["Metric", g];
RegisterTheory["CovD", CD];
RegisterTheory["Indices", {a, b, c, d, e, f}];
RegisterTheory["Field", phi, Sector -> "Matter"];
RegisterTheory["Parameter", m, Sector -> "Matter"];
RegisterTheory["Parameter", kappa, Sector -> "Gravity"];
RegisterTheory["Lagrangian", "Gravity" -> Lgrav, Sector -> "Gravity"];
RegisterTheory["Lagrangian", "Matter" -> Lmatter, Sector -> "Matter"];
RegisterTheory["Lagrangian", "Total" -> Ltotal];
RegisterTheory["Expression", "ScalarEq" -> scalarEq, Sector -> "Matter"];
RegisterTheory["Expression", "MetricEq" -> metricEq, Sector -> "Gravity"];
RegisterTheory["Expression", "StressTensor" -> stressTensor, Sector -> "Matter"];

CreateBackground["EHFlat", SymbolSuffix -> "Flat"];
DefineChart["EHFlat", {"t", "x", "y", "z"}];
SetCMetricSystem["EHFlat", DiagonalMatrix[{-1, 1, 1, 1}]];

(* Vacuum solution: both field equations vanish. *)
SetFieldComponents[phiFlat[], 0];
vacuumScalar = scalarEqFlat // ToComponents;
vacuumMetric = metricEqFlat // ToComponents;

(* Constant test field: scalar and metric equations need not vanish.
   This is a residual calculation, not a new solution of Einstein's equations. *)
SetFieldComponents[phiFlat[], 1];
constantScalar = scalarEqFlat // ToComponents;
constantMetric = metricEqFlat // ToComponents;

(* Independent mathematical checks. *)
scalarReference = CD[-a][CD[a][phi[]]] - m^2 phi[];
einsteinScalarChecks = <|
  "ScalarVariation" -> SameQ[ToCanonical[ContractMetric[Expand[scalarEq - scalarReference]]], 0],
  "MetricVariation" -> SameQ[ToCanonical[ContractMetric[Expand[metricEq - metricReference]]], 0],
  "VacuumScalar" -> SameQ[vacuumScalar, 0],
  "VacuumMetric" -> SameQ[vacuumMetric, ConstantArray[0, {4, 4}]],
  "ConstantScalar" -> SameQ[constantScalar, -m^2],
  "ConstantMetric" -> SameQ[constantMetric, m^2 DiagonalMatrix[{-1, 1, 1, 1}]/4]
|>;
einsteinScalarChecks

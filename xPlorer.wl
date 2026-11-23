(* ::Package:: *)

BeginPackage["xPlorer`", {"xAct`xTensor`", "xAct`xPert`", "xAct`xCoba`"}];

RegisterTheory::usage =
  "RegisterTheory[\"Metric\", metric] registers the abstract metric.
\
RegisterTheory[\"CovD\", CD] registers the covariant derivative.
\
RegisterTheory[\"Indices\", {a,b,c,...}] registers abstract indices.

\
RegisterTheory[\"Lagrangian\", L] registers the main lagrangian.
\
RegisterTheory[\"Lagrangian\", name, Lx] registers a named lagrangian.

\
RegisterTheory[\"Parameter\", name, value] registers one parameter.
\
RegisterTheory[\"Parameter\", {name1->v1, name2->v2, ...}] registers several parameters.

\
RegisterTheory[\"Field\", \"Scalar\", phi, opts] registers one scalar.
\
RegisterTheory[\"Field\", \"Vector\", A, opts] registers one vector.
\
RegisterTheory[\"Field\", \"MetricPert\", h, opts] registers one metric perturbation.
\
RegisterTheory[\"Field\", \"Tensor\", T, rank, sym, opts] registers one tensor.
\
RegisterTheory[\"Field\", {...}] registers several fields.

\
RegisterTheory[\"Expr\", expr] registers one expression with inferred name.
\
RegisterTheory[\"Expr\", key, expr] registers one expression with explicit key.
\
RegisterTheory[\"Expr\", {...}] registers several expressions.";
ShowTheoryKeys::usage = "ShowTheoryKeys[] returns the keys currently stored in $Theory. Main internal keys are Metric, CovD, Indices, Lagrangian, LagrangianMap, Parameter, Field and Expr.";
ClearTheory::usage = "ClearTheory[] resets $Theory to an empty association.";
AutoBuildTheory::usage = "AutoBuildTheory[] builds a minimal theory with internal keys Metric, CovD, Indices, Field, Parameter and Lagrangian.";

CreateBackground::usage = "CreateBackground[tag] creates a background from $Theory. Use CreateBackground[tag, Indices -> Automatic] to reuse theory indices or CreateBackground[tag, Indices -> {...}] to choose a background-specific index list. Option MetricSignature lets you override the default signature sign used in DefMetric.";
Options[CreateBackground] = {Indices -> Automatic, MetricSignature -> -1};
PortExpression::usage = "PortExpression[tag, expr] ports an abstract expression expr to the background tag.";
PrettyExp::usage = "PrettyExp[tag][expr] rewrites a background expression to the original abstract notation for display only.";
AddRules::usage = "AddRules[tag, rules] adds specialization rules to the background tag.";
ClearRules::usage = "ClearRules[tag] removes specialization rules from the background tag.";
ShowRules::usage = "ShowRules[tag] returns the specialization rules stored for tag.";
ApplyRules::usage = "ApplyRules[tag, expr] applies the specialization rules stored for tag to expr.";
UseExpression::usage = "UseExpression[tag, key] ports $Theory[\"Expr\"][key] to the background tag and applies its rules.";
DefineChart::usage = "DefineChart[tag, coordNames] defines a chart in the background tag. coordNames must match the background dimension.";
DeleteBackground::usage = "DeleteBackground[tag] undefines owned xAct objects and removes the background from the registry.";
ClearBackgrounds::usage = "ClearBackgrounds[] deletes each registered background and its owned xAct objects.";
SetFlatRules::usage = "SetFlatRules[tag] imposes flat-curvature rules for the connection of the background tag.";

RicciOf::usage = "RicciOf[tag] returns the Ricci head associated with the background tag.";
RicciScalarOf::usage = "RicciScalarOf[tag] returns the RicciScalar head associated with the background tag.";
EinsteinOf::usage = "EinsteinOf[tag] returns the Einstein head associated with the background tag.";
RiemannOf::usage = "RiemannOf[tag] returns the Riemann head associated with the background tag.";
WeylOf::usage = "WeylOf[tag] returns the Weyl head associated with the background tag.";
ChristoffelOf::usage = "ChristoffelOf[tag] returns the Christoffel head associated with the background tag.";
BackgroundIndices::usage = "BackgroundIndices[tag, n] returns the first n internal indices of the background tag.";
ShowBackground::usage = "ShowBackground[tag] returns the internal association of the background tag.";
ChartOf::usage = "ChartOf[tag] returns the chart symbol stored for the background tag.";
CoordinatesOf::usage = "CoordinatesOf[tag] returns the coordinate symbols stored for the background tag.";
BasisOf::usage = "BasisOf[tag] returns the basis symbol stored for the background tag.";
SetCMetricSystem::usage = "SetCMetricSystem[tag, mat, opts] assigns the matrix mat as components of the already existing background metric in the coordinated chart/basis of tag using xCoba MetricInBasis, then computes the objects selected by ComputeOnSet (metric and inverse by default).";
CMetricOf::usage = "CMetricOf[tag] returns the xCoba component metric stored for the background tag.";
ComponentCovDOf::usage = "ComponentCovDOf[tag] returns the xCoba component covariant derivative stored for the background tag.";
MetricMatrixOf::usage = "MetricMatrixOf[tag] returns the matrix used in SetCMetricSystem for the background tag.";
ShowTheory::usage = "ShowTheory[] returns the internal $Theory association used by the package.";
TheoryValue::usage = "TheoryValue[key] returns the value stored under a given internal $Theory key.";

$BG::usage = "$BG stores the backgrounds created by the package.";


SyntaxInformation[RegisterTheory] = <|"ArgumentsPattern" -> {_, ___}|>;

ToComponents::usage = "ToComponents[tag, expressionOrKey, opts] ports an expression and evaluates its components in the background chart.";
SetFieldComponents::usage = "SetFieldComponents[tag, field, values, opts] assigns scalar/vector/tensor components. A pure Function receives the chart coordinate scalars.";
ComputeGeometry::usage = "ComputeGeometry[tag, targets, opts] computes only the requested xCoba geometry and reuses compatible cached results.";
CheckBackground::usage = "CheckBackground[tag, opts] returns Passed, Failed or Inconclusive checks, including optional metric compatibility and contracted Bianchi tests.";
PerturbOn::usage = "PerturbOn[tag, expressionOrKey, n, opts] computes the nth variation (or Taylor coefficient when requested), with optional component output.";
ToBasisOf::usage = "ToBasisOf[tag, expr] converts to the background basis and traces basis dummies.";
ToValuesOf::usage = "ToValuesOf[tag, expr] evaluates values in the background basis.";
ExprMatrixOf::usage = "ExprMatrixOf[tag, expr] is the compatibility alias for ToComponents on rank-two expressions.";
FreeIndices::usage = "FreeIndices specifies the ordered free abstract indices of a component result.";
Components::usage = "Components -> All or a list of coordinate-number tuples selects the component output.";
IndexPositions::usage = "IndexPositions specifies +1 or -1 for each tensor slot; Automatic preserves the declared variance.";
PerturbationOrderLabel::usage = "PerturbationOrderLabel specifies the LI order when assigning perturbation components.";
Checks::usage = "Checks selects validation checks, including MetricCompatibility and Bianchi.";
ComputeOnSet::usage = "ComputeOnSet specifies geometry computed when setting a metric; defaults to the metric and inverse only.";
PerturbationForm::usage = "PerturbationForm is Variation (nth derivative) or TaylorCoefficient (nth derivative divided by n!).";
ApplySpecialization::usage = "ApplySpecialization controls whether background specialization rules are applied.";
StrictComponents::usage = "StrictComponents -> True returns Failure when tensor components or covariant derivatives remain unresolved.";
ForceCompute::usage = "ForceCompute -> True forces a fresh geometry calculation.";
$XPlorerVersion::usage = "$XPlorerVersion is the xPlorer package version.";
$XPlorerVersion = "14.0.0-beta.5";

Presentation::usage = "Presentation -> <|key -> label|> overrides inherited labels when creating a background. Keys include Metric, CovD, curvature names and registered field keys.";
SetPresentation::usage = "SetPresentation[tag, association] changes only labels of owned background objects. Automatic restores the inherited default for a key.";
PresentationOf::usage = "PresentationOf[tag] reports current labels and their defaults.";
SetXPlorerPreferences::usage = "SetXPlorerPreferences[association] sets optional presentation defaults for future backgrounds; use <||> to reset. It never changes mathematical options.";
BackgroundObject::usage = "BackgroundObject[tag, key] returns the actual field or geometry head. Full InputForm retains its context.";

DisplayExpression::usage = "DisplayExpression[tag, expr, opts] creates a reversible interpreted view. Normal returns the original expression; copying the boxes retains the mathematical expression.";
SetNotation::usage = "SetNotation[tag, association] sets background display defaults; no mathematical data changes.";
PartialStyle::usage = "PartialStyle chooses Native, MultiIndex, Fraction, Partial, or Prime (single argument only) in DisplayExpression.";
CovariantStyle::usage = "CovariantStyle chooses Native, Prefix, or Postfix in DisplayExpression.";
ShowBackgroundLabel::usage = "ShowBackgroundLabel adds a background label to an expression view.";

ClearComputedValues::usage = "ClearComputedValues[tag] clears derived geometry and restores declared metric/field inputs.";
ClearFieldComponents::usage = "ClearFieldComponents[tag, fieldOrKey] clears assigned and derived values of one field, retaining its definition.";
UnregisterTheory::usage = "UnregisterTheory[section, key] removes a registration, not the original xAct definition. Cascade -> True removes dependent expression registrations.";
DeletionPlan::usage = "DeletionPlan[tag, key, opts] previews dependency blockers and owned deletion order. Default key is Background.";
DeleteBackgroundObject::usage = "DeleteBackgroundObject[tag, key, Cascade -> False] undefines an owned field, chart, connection, metric, parameter or background. External dependents remain protected.";
Cascade::usage = "Cascade -> True permits deletion of tracked dependents within the selected background only.";
ReconstructionData::usage = "ReconstructionData[tag] exports managed input records for inspection. It is not automatic kernel undo.";

AddConnection::usage = "AddConnection[tag, key, source, opts] copies an existing source xAct connection onto a background.";
ConnectionOf::usage = "ConnectionOf[tag, key] returns a named connection; omitted key or Primary returns the metric Levi-Civita derivative.";
ConnectionsOf::usage = "ConnectionsOf[tag] lists named connection heads.";
ConnectionDifference::usage = "ConnectionDifference[tag, key1, key2] returns the native Christoffel difference tensor with background indices.";
TorsionOf::usage = "TorsionOf[tag, key] returns the selected native torsion tensor head.";

Begin["`Private`"]

SetAttributes[NameKey, HoldAll];
NameKey[k_String] := k;
NameKey[k_Symbol] := SymbolName[Unevaluated[k]];
NameKey[k_] := ToString[Unevaluated[k], InputForm];;

SetAttributes[RegisterTheory, HoldAll];


RegisterTheory::badfield = "Invalid field specification: `1`.";
RegisterTheory::badexpr = "Invalid expression specification: `1`.";
RegisterTheory::badparam = "Invalid parameter specification: `1`.";
CreateBackground::notheory = "No theory has been registered yet.";
CreateBackground::nometric = "$Theory does not contain Metric.";
CreateBackground::nocovd = "$Theory does not contain CovD.";
CreateBackground::noindices = "$Theory does not contain a valid Indices list.";
CreateBackground::nofield = "$Theory does not contain a valid Field association.";
CreateBackground::badbgindices = "Option Indices must be Automatic or a list of symbols.";
CreateBackground::badsignature = "Option MetricSignature must be an integer sign such as -1 or 1.";
PortExpression::nobg = "Background `1` does not exist.";
PrettyExp::nobg = "Background `1` does not exist.";
AddRules::nobg = "Background `1` does not exist.";
ClearRules::nobg = "Background `1` does not exist.";
ShowRules::nobg = "Background `1` does not exist.";
ApplyRules::nobg = "Background `1` does not exist.";
SetFlatRules::nobg = "Background `1` does not exist.";
UseExpression::notheory = "No theory has been registered yet.";
UseExpression::noexpr = "$Theory does not contain a valid \"Expr\" association.";
UseExpression::nokey = "Expression key `1` was not found in $Theory[\"Expr\"].";
DefineChart::nobg = "Background `1` does not exist.";
DefineChart::badcoords = "DefineChart expects exactly 4 coordinate names.";
SetCMetricSystem::nobg = "Background `1` does not exist.";
SetCMetricSystem::nochart = "Background `1` does not have a chart defined.";
SetCMetricSystem::badmat = "The metric matrix must be a 4 x 4 list.";
DeleteBackground::nobg = "Background `1` does not exist.";
TheoryValue::nokey = "Key `1` was not found in $Theory.";

If[!ValueQ[$BG] || !AssociationQ[$BG], $BG = <||>;];
If[!ValueQ[$Theory] || !AssociationQ[$Theory], $Theory = <||>;];

MergeTheoryValue[old_, new_] := Which[
  AssociationQ[old] && AssociationQ[new], Join[old, new],
  True, new
];

InferFieldKey[head_] := SymbolName[Unevaluated[head]];
InferFieldPrintAs[head_] := Module[{p = PrintAs[head]},
  Which[StringQ[p], p, p === Identity, SymbolName[head], Head[p] === Function, p[head], True, SymbolName[head]]];

FieldPrintAsFromOpts[head_, opts___Rule] := Lookup[Association[opts], PrintAs, InferFieldPrintAs[head]];
MetricPertOrderFromOpts[opts___Rule] := Lookup[Association[opts], Order, 1];

TensorSymmetryFromArgs[args___] := Module[{lst = {args}},
  Which[
    MemberQ[lst, "Symmetric"], "Symmetric",
    MemberQ[lst, "Antisymmetric"], "Antisymmetric",
    True, None
  ]
];

MakeFieldAssoc[key_String, type_String, head_, extra_Association : <||>] := <|
  key -> Join[
    <|
      "Type" -> type,
      "Head" -> Unevaluated[head],
      "PrintAs" -> Lookup[extra, "PrintAs", InferFieldPrintAs[head]]
    |>,
    KeyDrop[extra, "PrintAs"]
  ]
|>;

NormalizeFieldSpec[{key_, type_, head_}] /; MemberQ[{"Scalar", "Vector", "MetricPert"}, type] :=
  First @ Normal @ MakeFieldAssoc[NameKey[Unevaluated[key]], type, head];
NormalizeFieldSpec[{key_, type_, head_, printAs_Rule}] /; MemberQ[{"Scalar", "Vector", "MetricPert"}, type] && MatchQ[printAs, PrintAs -> _] :=
  First @ Normal @ MakeFieldAssoc[NameKey[Unevaluated[key]], type, head, <|"PrintAs" -> Last[printAs]|>];
NormalizeFieldSpec[{type_, head_}] /; MemberQ[{"Scalar", "Vector", "MetricPert"}, type] :=
  First @ Normal @ MakeFieldAssoc[InferFieldKey[head], type, head];
NormalizeFieldSpec[{type_, head_, printAs_Rule}] /; MemberQ[{"Scalar", "Vector", "MetricPert"}, type] && MatchQ[printAs, PrintAs -> _] :=
  First @ Normal @ MakeFieldAssoc[InferFieldKey[head], type, head, <|"PrintAs" -> Last[printAs]|>];
NormalizeFieldSpec[{type_, head_, rank_Integer}] /; type === "Tensor" :=
  First @ Normal @ MakeFieldAssoc[InferFieldKey[head], "Tensor", head, <|"Rank" -> rank, "Symmetry" -> None|>];
NormalizeFieldSpec[{type_, head_, rank_Integer, sym_}] /; type === "Tensor" && MemberQ[{"Symmetric", "Antisymmetric"}, sym] :=
  First @ Normal @ MakeFieldAssoc[InferFieldKey[head], "Tensor", head, <|"Rank" -> rank, "Symmetry" -> sym|>];
NormalizeFieldSpec[{type_, head_, rank_Integer, printAs_Rule}] /; type === "Tensor" && MatchQ[printAs, PrintAs -> _] :=
  First @ Normal @ MakeFieldAssoc[InferFieldKey[head], "Tensor", head, <|"Rank" -> rank, "Symmetry" -> None, "PrintAs" -> Last[printAs]|>];
NormalizeFieldSpec[{type_, head_, rank_Integer, sym_, printAs_Rule}] /; type === "Tensor" && MemberQ[{"Symmetric", "Antisymmetric"}, sym] && MatchQ[printAs, PrintAs -> _] :=
  First @ Normal @ MakeFieldAssoc[InferFieldKey[head], "Tensor", head, <|"Rank" -> rank, "Symmetry" -> sym, "PrintAs" -> Last[printAs]|>];
NormalizeFieldSpec[{key_, type_, head_, rank_Integer}] /; type === "Tensor" :=
  First @ Normal @ MakeFieldAssoc[NameKey[Unevaluated[key]], "Tensor", head, <|"Rank" -> rank, "Symmetry" -> None|>];
NormalizeFieldSpec[{key_, type_, head_, rank_Integer, sym_}] /; type === "Tensor" && MemberQ[{"Symmetric", "Antisymmetric"}, sym] :=
  First @ Normal @ MakeFieldAssoc[NameKey[Unevaluated[key]], "Tensor", head, <|"Rank" -> rank, "Symmetry" -> sym|>];
NormalizeFieldSpec[{key_, type_, head_, rank_Integer, printAs_Rule}] /; type === "Tensor" && MatchQ[printAs, PrintAs -> _] :=
  First @ Normal @ MakeFieldAssoc[NameKey[Unevaluated[key]], "Tensor", head, <|"Rank" -> rank, "Symmetry" -> None, "PrintAs" -> Last[printAs]|>];
NormalizeFieldSpec[{key_, type_, head_, rank_Integer, sym_, printAs_Rule}] /; type === "Tensor" && MemberQ[{"Symmetric", "Antisymmetric"}, sym] && MatchQ[printAs, PrintAs -> _] :=
  First @ Normal @ MakeFieldAssoc[NameKey[Unevaluated[key]], "Tensor", head, <|"Rank" -> rank, "Symmetry" -> sym, "PrintAs" -> Last[printAs]|>];

NormalizeFieldRules[list_List] := Association @ (NormalizeFieldSpec /@ list);
NormalizeNameValueRules[list_List] := Association @ Replace[
  list,
  {
    {k_, v_} :> (NameKey[Unevaluated[k]] -> v),
    (k_ -> v_) :> (NameKey[Unevaluated[k]] -> v)
  },
  1
];

ClearTheory[] := ($Theory = <||>; $Theory);
ShowTheoryKeys[] := If[AssociationQ[$Theory], Keys[$Theory], {}];

AutoBuildTheory[] := <|
  "Metric" -> metric,
  "CovD" -> CD,
  "Indices" -> {a, b, c, d, e, f, i, j},
  "Field" -> <|
    InferFieldKey[\[Phi]] -> <|"Type" -> "Scalar", "Head" -> \[Phi], "PrintAs" -> InferFieldPrintAs[\[Phi]]|>
  |>,
  "Parameter" -> <|"Mass" -> m0|>,
  "Lagrangian" -> L
|>;

RegisterTheory[assoc_Association] := ($Theory = If[AssociationQ[$Theory], Join[$Theory, assoc], assoc]; $Theory);

RegisterTheory["Metric", value_] := ($Theory = Replace[$Theory, Except[_Association] -> <||>]; $Theory["Metric"] = value; $Theory);
RegisterTheory["CovD", value_] := ($Theory = Replace[$Theory, Except[_Association] -> <||>]; $Theory["CovD"] = value; $Theory);
RegisterTheory["Indices", value_List] := ($Theory = Replace[$Theory, Except[_Association] -> <||>]; $Theory["Indices"] = value; $Theory);

RegisterTheory["Lagrangian", value_] := ($Theory = Replace[$Theory, Except[_Association] -> <||>]; $Theory["Lagrangian"] = value; $Theory);
RegisterTheory["Lagrangian", key_, value_] := Module[{newAssoc},
  $Theory = Replace[$Theory, Except[_Association] -> <||>];
  newAssoc = <|NameKey[Unevaluated[key]] -> value|>;
  If[!KeyExistsQ[$Theory, "LagrangianMap"], $Theory["LagrangianMap"] = newAssoc, $Theory["LagrangianMap"] = MergeTheoryValue[$Theory["LagrangianMap"], newAssoc]];
  If[!KeyExistsQ[$Theory, "Lagrangian"], $Theory["Lagrangian"] = value];
  $Theory
];

RegisterTheory["Parameter", key_, value_] := Module[{newAssoc},
  $Theory = Replace[$Theory, Except[_Association] -> <||>];
  newAssoc = <|NameKey[Unevaluated[key]] -> value|>;
  If[!KeyExistsQ[$Theory, "Parameter"], $Theory["Parameter"] = newAssoc, $Theory["Parameter"] = MergeTheoryValue[$Theory["Parameter"], newAssoc]];
  $Theory
];
RegisterTheory["Parameter", list_List] := Module[{newAssoc},
  $Theory = Replace[$Theory, Except[_Association] -> <||>];
  newAssoc = NormalizeNameValueRules[list];
  If[!KeyExistsQ[$Theory, "Parameter"], $Theory["Parameter"] = newAssoc, $Theory["Parameter"] = MergeTheoryValue[$Theory["Parameter"], newAssoc]];
  $Theory
];

RegisterTheory["Field", type_String, head_, opts___Rule] /; MemberQ[{"Scalar", "Vector", "MetricPert"}, type] := Module[{newAssoc, key, printAs, order},
  $Theory = Replace[$Theory, Except[_Association] -> <||>];
  key = InferFieldKey[head];
  printAs = FieldPrintAsFromOpts[head, opts];
  If[type === "MetricPert",
    order = MetricPertOrderFromOpts[opts];
    newAssoc = MakeFieldAssoc[key, type, head, <|"PrintAs" -> printAs, "Order" -> order|>],
    newAssoc = MakeFieldAssoc[key, type, head, <|"PrintAs" -> printAs|>]
  ];
  If[!KeyExistsQ[$Theory, "Field"], $Theory["Field"] = newAssoc, $Theory["Field"] = MergeTheoryValue[$Theory["Field"], newAssoc]];
  $Theory
];

RegisterTheory["Field", key_String, type_String, head_, opts___Rule] /; MemberQ[{"Scalar", "Vector", "MetricPert"}, type] := Module[{newAssoc, printAs, order, ks},
  $Theory = Replace[$Theory, Except[_Association] -> <||>];
  ks = NameKey[Unevaluated[key]];
  printAs = FieldPrintAsFromOpts[head, opts];
  If[type === "MetricPert",
    order = MetricPertOrderFromOpts[opts];
    newAssoc = MakeFieldAssoc[ks, type, head, <|"PrintAs" -> printAs, "Order" -> order|>],
    newAssoc = MakeFieldAssoc[ks, type, head, <|"PrintAs" -> printAs|>]
  ];
  If[!KeyExistsQ[$Theory, "Field"], $Theory["Field"] = newAssoc, $Theory["Field"] = MergeTheoryValue[$Theory["Field"], newAssoc]];
  $Theory
];

RegisterTheory["Field", "Tensor", head_, rank_Integer, rest___] := Module[{newAssoc, key, sym, printAs},
  $Theory = Replace[$Theory, Except[_Association] -> <||>];
  key = InferFieldKey[head];
  sym = TensorSymmetryFromArgs[rest];
  printAs = FieldPrintAsFromOpts[head, Sequence @@ Select[{rest}, MatchQ[#, _Rule] &]];
  newAssoc = MakeFieldAssoc[key, "Tensor", head, <|"Rank" -> rank, "Symmetry" -> sym, "PrintAs" -> printAs|>];
  If[!KeyExistsQ[$Theory, "Field"], $Theory["Field"] = newAssoc, $Theory["Field"] = MergeTheoryValue[$Theory["Field"], newAssoc]];
  $Theory
];

RegisterTheory["Field", key_String, "Tensor", head_, rank_Integer, rest___] := Module[{newAssoc, sym, printAs, ks},
  $Theory = Replace[$Theory, Except[_Association] -> <||>];
  ks = NameKey[Unevaluated[key]];
  sym = TensorSymmetryFromArgs[rest];
  printAs = FieldPrintAsFromOpts[head, Sequence @@ Select[{rest}, MatchQ[#, _Rule] &]];
  newAssoc = MakeFieldAssoc[ks, "Tensor", head, <|"Rank" -> rank, "Symmetry" -> sym, "PrintAs" -> printAs|>];
  If[!KeyExistsQ[$Theory, "Field"], $Theory["Field"] = newAssoc, $Theory["Field"] = MergeTheoryValue[$Theory["Field"], newAssoc]];
  $Theory
];

RegisterTheory["Field", list_List] := Module[{newAssoc},
  $Theory = Replace[$Theory, Except[_Association] -> <||>];
  newAssoc = NormalizeFieldRules[list];
  If[!KeyExistsQ[$Theory, "Field"], $Theory["Field"] = newAssoc, $Theory["Field"] = MergeTheoryValue[$Theory["Field"], newAssoc]];
  $Theory
];

RegisterTheory["Expr", expr_Symbol] := Module[{newAssoc, key},
  $Theory = Replace[$Theory, Except[_Association] -> <||>];
  key = SymbolName[Unevaluated[expr]];
  newAssoc = <|key -> expr|>;
  If[
    !KeyExistsQ[$Theory, "Expr"],
    $Theory["Expr"] = newAssoc,
    $Theory["Expr"] = MergeTheoryValue[$Theory["Expr"], newAssoc]
  ];
  $Theory
];

RegisterTheory["Expr", key_, expr_] := Module[{newAssoc, ks},
  $Theory = Replace[$Theory, Except[_Association] -> <||>];
  ks = NameKey[Unevaluated[key]];
  newAssoc = <|ks -> expr|>;
  If[
    !KeyExistsQ[$Theory, "Expr"],
    $Theory["Expr"] = newAssoc,
    $Theory["Expr"] = MergeTheoryValue[$Theory["Expr"], newAssoc]
  ];
  $Theory
];

RegisterTheory["Expr", list_List] := Module[{newAssoc},
  $Theory = Replace[$Theory, Except[_Association] -> <||>];
  newAssoc = Association @ Replace[
    Unevaluated[list],
    {
      s_Symbol :> (SymbolName[Unevaluated[s]] -> s),
      {k_, v_} :> (NameKey[Unevaluated[k]] -> v),
      (k_ -> v_) :> (NameKey[Unevaluated[k]] -> v)
    },
    1
  ];
  If[
    !KeyExistsQ[$Theory, "Expr"],
    $Theory["Expr"] = newAssoc,
    $Theory["Expr"] = MergeTheoryValue[$Theory["Expr"], newAssoc]
  ];
  $Theory
];
(* Backgrounds own their symbols. All public operations return Failure on invalid input. *)
failure[code_, message_, data_: <||>] := Failure[code, Join[<|"MessageTemplate" -> message|>, data]];
SetAttributes[guard, HoldAll];
guard[body_] := Check[Catch[Catch[body], _, Function[{v, t}, $Failed]], $Failed];
background[tag_] := Lookup[$BG, tag, failure["UnknownBackground", "The background does not exist.", <|"Tag" -> tag|>]];
If[!IntegerQ[$BackgroundCounter], $BackgroundCounter = 0];
put[tag_, assoc_Association] := ($BG[tag] = Join[$BG[tag], assoc]);
coordinateValues[bg_] := Through[bg["Coordinates"][]];
profile[value_, bg_] := If[Head[value] === Function, value @@ coordinateValues[bg], value];
allGeometry[cd_, g_] := <|"Christoffel" -> GiveSymbol[Christoffel, cd], "Riemann" -> Riemann[cd],
  "Ricci" -> Ricci[cd], "RicciScalar" -> RicciScalar[cd], "Einstein" -> Einstein[cd],
  "Weyl" -> Weyl[cd], "TFRicci" -> TFRicci[cd], "Kretschmann" -> Kretschmann[cd],
  "Epsilon" -> epsilon[g], "DetMetric" -> GiveSymbol[Determinant, g, AIndex]|>;

Options[CreateBackground] = {Indices -> Automatic, MetricSignature -> Automatic, Presentation -> <||>};
CreateBackground[tag_String, OptionsPattern[]] := Module[
  {theory = $Theory, srcg, srccd, srcm, dim, base, display, inds, ctx, m, g, cd, sig,
   specs, fields = <||>, oldgeo, geo, rules, result, parameter, make, owned, labels, defaults, suffix, perturbHead = None},
  If[KeyExistsQ[$BG, tag], Return[$BG[tag]]];
  If[!And @@ (KeyExistsQ[theory, #] & /@ {"Metric", "CovD", "Indices"}),
    Return[failure["IncompleteTheory", "Register a metric, covariant derivative and indices first."]]];
  srcg = theory["Metric"]; srccd = theory["CovD"];
  If[!MetricQ[srcg] || !CovDQ[srccd] || CovDOfMetric[srcg] =!= srccd,
    Return[failure["InvalidTheory", "The registered metric and its Levi-Civita derivative must already be defined in xAct."]]];
  srcm = BaseOfVBundle[VBundleOfMetric[srcg]]; dim = DimOfManifold[srcm];
  If[!IntegerQ[dim] || dim < 2, Return[failure["Dimension", "A concrete dimension of at least two is required."]]];
  base = theory["Indices"];
  If[!ListQ[base] || Length[base] < 2 || !DuplicateFreeQ[base] || !And @@ (AIndexQ[#, VBundleOfMetric[srcg]] & /@ base),
    Return[failure["Indices", "Theory indices must be distinct abstract indices on the metric bundle."]]];
  display = Replace[OptionValue[Indices], Automatic -> base];
  If[!ListQ[display] || Length[display] =!= Length[base] || !VectorQ[display, MatchQ[#, _Symbol] &],
    Return[failure["Indices", "Background display indices must have the same length as the theory index list."]]];
  sig = Replace[OptionValue[MetricSignature], Automatic :> SignDetOfMetric[srcg]];
  If[!MemberQ[{-1, 1}, sig] && !(MatchQ[sig, {_Integer, _Integer, 0}] && Min[sig] >= 0 && Total[sig] === dim),
    Return[failure["Signature", "Use determinant sign -1 or +1, or signature counts {positive,negative,0} matching the dimension."]]];
  ctx = "xPlorer`Backgrounds`B" <> ToString[++$BackgroundCounter] <> "`";
  suffix = safeName[tag];
  m = Symbol[ctx <> "M" <> suffix]; g = Symbol[ctx <> SymbolName[srcg] <> suffix]; cd = Symbol[ctx <> SymbolName[srccd] <> suffix];
  labels = OptionValue[Presentation];
  If[!AssociationQ[labels], Return[failure["Presentation", "Presentation must be an association of labels."]]];
  labels = Join[$PresentationPreferences, Lookup[theory, "Presentation", <||>], labels];
  defaults = <|"Metric" -> InferFieldPrintAs[srcg], "CovD" -> SymbolOfCovD[srccd]|>;
  installCovDNames[cd, ctx];
  parameter = Symbol[ctx <> "eps"];
  inds = MapIndexed[Symbol[ctx <> "i" <> ToString[First[#2]]] &, display];
  specs = Lookup[theory, "Field", <||>];
  If[!AssociationQ[specs], Return[failure["Fields", "Field must be an association."]]];
  If[Complement[Keys[labels], Join[Keys[specs], {"Metric", "CovD", "Christoffel", "Riemann", "Ricci", "RicciScalar", "Einstein", "Weyl", "TFRicci", "Kretschmann", "Epsilon", "DetMetric"}]] =!= {} ||
    !AllTrue[Normal[labels], Function[r, If[First[r] === "CovD", MatchQ[Last[r], {_String,_String}], StringQ[Last[r]]]]],
    Return[failure["Presentation", "Supply valid labels for known objects before creating a background."]]];
  make[key_, spec_] := Module[{head, new, type, rank, slots, signs, symmetry, deps, args, print, n, dagger=Real, vanish=False, frobenius=False},
    If[!AssociationQ[spec] || !And @@ (KeyExistsQ[spec, #] & /@ {"Head", "Type"}), Return[$Failed]];
    head = spec["Head"]; type = spec["Type"]; print = Lookup[spec, "PrintAs", key];
    new = Symbol[ctx <> safeName[key] <> suffix <> ToString[Length[fields] + 1]];
    print = Lookup[labels, key, print];
    If[type === "MetricPert",
      If[perturbHead =!= None, Return[$Failed]];
      Block[{$PerturbationParameter}, With[{gg = g, hh = new, pp = parameter, pr = print},
        DefMetricPerturbation[gg, hh, pp, PrintAs -> pr]]];
      perturbHead = new; signs = {-1, -1}; rank = 2,
      rank = Switch[type, "Scalar", 0, "Vector", 1, "Tensor", Lookup[spec, "Rank", -1], _, -1];
      If[!IntegerQ[rank] || rank < 0, Return[$Failed]];
      symmetry = Lookup[spec, "Symmetry", None];
      signs = ConstantArray[-1, rank]; deps = {m};
      If[xTensorQ[head],
        If[WeightOfTensor[head]=!=0 || !FreeQ[UpValues[head],OrthogonalToVectorQ|Projected|GradeOfTensor], Return[$Failed]];
        dagger=Which[HermitianQ[head],Hermitian,AntihermitianQ[head],Antihermitian,Dagger[head]===head,Real,Dagger[head]===MultiplyHead[-1,head],Imaginary,True,Complex];
        frobenius=FrobeniusQ[head];
        slots = SlotsOfTensor[head];
        If[Length[slots] =!= rank || !And @@ (MemberQ[{VBundleOfMetric[srcg], -VBundleOfMetric[srcg]}, #] & /@ slots), Return[$Failed]];
        signs = If[MatchQ[#, Times[-1, _]], -1, 1] & /@ slots;
        symmetry = SymmetryGroupOfTensor[head];
        deps = DependenciesOfTensor[head] /. srcm -> m;
        If[!FreeQ[deps, s_Symbol /; ManifoldQ[s] && s =!= m], Return[$Failed]];
      ];
      args = MapThread[Times, {signs, Take[If[rank <= Length[inds], inds, GetIndicesOfVBundle[TangentBundleOfManifold[m], rank]], rank]}];
      symmetry = Switch[symmetry, "Symmetric", Symmetric[Range[rank]], "Antisymmetric", Antisymmetric[Range[rank]], None, GenSet[], _, symmetry];
      With[{hh = new, aa = args, dd = deps, ss = symmetry, pr = print, dg=dagger,fb=frobenius},
        DefTensor[hh @@ aa, dd, ss, PrintAs -> pr,Dagger->dg,FrobeniusQ->fb]];
    ];
    If[!xTensorQ[new], Return[$Failed]];
    fields[key] = <|"Type" -> type, "OldHead" -> head, "NewHead" -> new,
      "PrintAs" -> print, "Rank" -> rank, "IndexPositions" -> signs|>;
    new
  ];
  result = guard[
    With[{mm = m, nn = dim, ii = inds}, DefManifold[mm, nn, ii]];
    MapThread[Function[{ix, lab}, With[{s = ix, p = InferFieldPrintAs[lab]}, PrintAs[s] ^= p]], {inds, display}];
    With[{gg = g, aa = inds[[1]], bb = inds[[2]], cc = cd, ss = sig, gp = Lookup[labels, "Metric", defaults["Metric"]], cp = Lookup[labels, "CovD", defaults["CovD"]]},
      If[MemberQ[First /@ Options[DefMetric], DefMetricPerturbation],
        DefMetric[ss, gg[-aa, -bb], cc, cp, PrintAs -> gp, DefMetricPerturbation -> False],
        DefMetric[ss, gg[-aa, -bb], cc, cp, PrintAs -> gp]]];
    KeyValueMap[make, specs]
  ];
  If[result === $Failed || !ListQ[result] || MemberQ[result, $Failed],
    guard[disposeObjects[<|"Manifold" -> m, "Metric" -> g, "CovD" -> cd, "Field" -> fields, "PerturbationParameter" -> parameter|>]];
    Return[failure["CreateBackground", "xAct could not create every requested object; the partial background was rolled back."]]];
  oldgeo = allGeometry[srccd, srcg]; geo = allGeometry[cd, g];
  defaults = Join[defaults, Association@KeyValueMap[(#1 -> Lookup[#2,"PrintAs",InferFieldPrintAs[#2["Head"]]] ) &, specs],
    Association@KeyValueMap[(#1 -> If[xTensorQ[#2], InferFieldPrintAs[#2], SymbolName[#2]]) &, geo]];
  rules = Join[{srcg -> g, srccd -> cd}, Thread[Values[oldgeo] -> Values[geo]],
    (# ["OldHead"] -> # ["NewHead"] & /@ Values[fields]),
    (Dagger[#["OldHead"]] -> Dagger[#["NewHead"]] & /@ Select[Values[fields],xTensorQ[#["OldHead"]] && DaggerQ[#["OldHead"]]&])];
  $BG[tag] = Join[<|"Tag" -> tag, "Context" -> ctx, "PresentationDefaults" -> defaults, "PresentationOverrides" -> labels, "Theory" -> theory, "Dimension" -> dim,
    "SourceManifold" -> srcm, "SourceBundle" -> VBundleOfMetric[srcg], "Manifold" -> m,
    "Metric" -> g, "CovD" -> cd, "Signature" -> sig, "Indices" -> inds, "BaseIndices" -> base,
    "DisplayIndices" -> display, "Field" -> fields, "HeadRules" -> rules,
    "IndexRules" -> Thread[base -> inds], "SpecializationRules" -> {},
    "MetricRevision" -> 0, "ComputedGeometry" -> {}, "GeometryRuns" -> 0,
    "FieldComponents" -> <||>, "PerturbationHead" -> perturbHead, "PerturbationParameter" -> parameter|>, geo];
  put[tag,<|"Connections"-><|"Primary"-><|"Head"->cd,"OldHead"->srccd,"Geometry"->connectionGeometry[cd],"Torsion"->False,"Curvature"->True,"Metric"->g|>|>|>];
  result=KeyValueMap[Function[{key,spec},With[{ss=spec["Head"],pr=spec["SymbolOfCovD"]},AddConnection[tag,key,ss,SymbolOfCovD->pr]]],Lookup[theory,"Connections",<||>]];
  If[AnyTrue[result,FailureQ],DeleteBackground[tag];Return[First@Select[result,FailureQ]]];
  SetPresentation[tag, labels];
  $BG[tag]
];

sourceIndexQ[s_Symbol, bundle_] := Module[{known = Flatten[IndicesOfVBundle[bundle]], name = SymbolName[s]},
  MemberQ[known, s] || (StringContainsQ[name, "$"] && AnyTrue[known, StringStartsQ[name, SymbolName[#] <> "$"] &] && AIndexQ[s, bundle])
];
PortExpression[tag_String, expr_] := Module[{bg = background[tag], held, indices, extras, ir, output, leftovers},
  If[FailureQ[bg], Return[bg]];
  held = With[{ex = expr}, HoldComplete[ex]];
  indices = DeleteDuplicates@Cases[held, s_Symbol /; sourceIndexQ[s, bg["SourceBundle"]], Infinity, Heads -> True];
  extras = Complement[indices, bg["BaseIndices"]];
  ir = Join[bg["IndexRules"], (# -> DummyIn[TangentBundleOfManifold[bg["Manifold"]]] & /@ extras)];
  held = held /. bg["HeadRules"] /. ir;
  leftovers = DeleteDuplicates@Cases[held, h_Symbol /; xTensorQ[h] && MemberQ[DependenciesOfTensor[h], bg["SourceManifold"]], Infinity, Heads -> True];
  If[leftovers =!= {}, Return[failure["UnregisteredFields", "Register all fields used by the expression before creating the background.", <|"Fields" -> leftovers|>]]];
  output = guard[ReplaceDummies[ReleaseHold[held]]];
  If[output === $Failed, failure["PortExpression", "The expression could not be transferred consistently."], output]
];
PrettyExp[tag_String][expr_] := Module[{bg = background[tag], held},
  If[FailureQ[bg], Return[bg]];
  held = With[{ex = expr}, HoldComplete[ex]];
  ReleaseHold[held /. (Reverse /@ bg["HeadRules"]) /. (Reverse /@ bg["IndexRules"])]
];
AddRules[tag_String, rules_List] := Module[{bg = background[tag]}, If[FailureQ[bg], Return[bg]];
  If[!AllTrue[rules, MatchQ[#, _Rule | _RuleDelayed] &], Return[failure["Rules", "Supply a list of rules."]]];
  put[tag, <|"SpecializationRules" -> Join[bg["SpecializationRules"], rules]|>]];
ClearRules[tag_String] := If[FailureQ[background[tag]], background[tag], put[tag, <|"SpecializationRules" -> {}|>]];
ShowRules[tag_String] := Module[{b = background[tag]}, If[FailureQ[b], b, b["SpecializationRules"]]];
ApplyRules[tag_String, expr_] := Module[{b = background[tag]}, If[FailureQ[b], b, expr /. b["SpecializationRules"]]];
SetFlatRules[tag_String] := Module[{b = background[tag], heads, rules}, If[FailureQ[b], Return[b]];
  heads = Lookup[b, {"Riemann", "Ricci", "Einstein", "Weyl"}];
  rules = Join[With[{hh = #}, HoldPattern[hh[__]] :> 0] & /@ heads,
    With[{rr = b["RicciScalar"], kk = b["Kretschmann"]}, {rr[] -> 0, kk[] -> 0}]];
  AddRules[tag, rules]
];
resolve[tag_, key_String] := Module[{b = background[tag], expressions}, If[FailureQ[b], Return[b]];
  expressions = Lookup[b["Theory"], "Expr", <||>];
  Lookup[expressions, key, failure["ExpressionKey", "The expression key is absent from this background's theory snapshot.", <|"Key" -> key|>]]];
resolve[tag_, expr_] := expr;
UseExpression[tag_String, key_String] := Module[{ex = resolve[tag, key]}, If[FailureQ[ex], Return[ex]];
  ex = PortExpression[tag, ex]; If[FailureQ[ex], ex, ApplyRules[tag, ex]]];
UseExpression[tag_String, key_Symbol] := UseExpression[tag, SymbolName[Unevaluated[key]]];

DefineChart[tag_String, names_List] := Module[{b = background[tag], chart, coords, result},
  If[FailureQ[b], Return[b]];
  If[Length[names] =!= b["Dimension"] || !VectorQ[names, StringQ] || !DuplicateFreeQ[names],
    Return[failure["Coordinates", "Supply distinct coordinate labels matching the dimension."]]];
  If[KeyExistsQ[b, "Chart"] && ChartQ[b["Chart"]],
    Return[If[Lookup[b, "CoordinateLabels", {}] === names, b, failure["ChartExists", "This background already has a chart; create another background for different coordinates."]]]];
  chart = Symbol[b["Context"] <> "chart"];
  coords = Table[Symbol[b["Context"] <> "coord" <> ToString[n]], {n, Length[names]}];
  result = guard[With[{ch = chart, mm = b["Manifold"], nums = Range[0, b["Dimension"] - 1], vals = Through[coords[]]},
    DefChart[ch, mm, nums, vals]]];
  If[result === $Failed || !ChartQ[chart], Return[failure["DefineChart", "xCoba could not define the chart."]]];
  MapThread[Function[{s, lab}, With[{ss = s, ll = lab}, PrintAs[ss] ^= ll]], {coords, names}];
  put[tag, <|"Chart" -> chart, "Basis" -> chart, "Coordinates" -> coords, "CoordinateLabels" -> names|>]
];
ChartOf[tag_String] := getter[tag, "Chart"];
CoordinatesOf[tag_String] := getter[tag, "Coordinates"];
BasisOf[tag_String] := getter[tag, "Basis"];
getter[tag_, key_] := Module[{b = background[tag]}, If[FailureQ[b], b, Lookup[b, key, failure["NotInitialized", "The requested background property has not been initialized.", <|"Property" -> key|>]]]];

clearGeometry[tag_] := Module[{b = $BG[tag], heads, cached, positions, owned},
  If[!KeyExistsQ[b,"Metric"] || !MetricQ[b["Metric"]],Return[Null]];
  owned = DeleteMissing[Lookup[b, {"Metric", "CovD", "Chart"}]];
  cached = DownValues[xCobaCacheTable];
  positions = Select[Range[Length[cached]], Function[pos, AnyTrue[owned, !FreeQ[cached[[pos]], #] &]]];
  If[positions =!= {}, With[{pp = List /@ positions}, ClearxCobaCache[pp]]];
  heads = DeleteDuplicates@Join[{b["Metric"]}, Values[allGeometry[b["CovD"], b["Metric"]]],
    If[KeyExistsQ[b, "Chart"] && ChartQ[b["Chart"]], {GiveSymbol[Christoffel, Sequence @@ Sort[{b["CovD"], PDOfBasis[b["Chart"]]}]], GiveSymbol[Determinant, b["Metric"], b["Chart"]]}, {}]];
  Scan[If[xTensorQ[#], guard[DeleteTensorValues[#]]] &, heads];
  put[tag, <|"ComputedGeometry" -> {}|>];
];
signatureStatus[mat_, expected_, ass_] := Module[{values, signs, result},
  If[IntegerQ[expected],
    result = Simplify[Sign[Det[mat]] == expected, Assumptions -> ass],
    values = Which[MatrixQ[mat, NumericQ], Eigenvalues[mat], TrueQ[Simplify[mat == DiagonalMatrix[Diagonal[mat]], Assumptions -> ass]], Diagonal[mat], True, Return["Inconclusive"]];
    signs = Simplify[Sign[#], Assumptions -> ass] & /@ values;
    If[!VectorQ[signs, MemberQ[{-1, 0, 1}, #] &], Return["Inconclusive"]];
    result = {Count[signs, 1], Count[signs, -1], Count[signs, 0]} == expected
  ];
  Which[TrueQ[result], "Passed", TrueQ[result === False], "Failed", True, "Inconclusive"]
];
Options[SetCMetricSystem] = {ComputeOnSet -> {"Metric"}, Assumptions -> True, CVSimplify -> Together, Verbose -> False};
SetCMetricSystem[tag_String, input_, OptionsPattern[]] := Module[{b = background[tag], mat, det, result, ass = OptionValue[Assumptions], sym},
  If[FailureQ[b], Return[b]];
  If[!KeyExistsQ[b, "Chart"], Return[failure["NoChart", "Define the chart before assigning a metric."]]];
  ass = profile[ass, b];
  mat = profile[input, b];
  If[Dimensions[mat] =!= {b["Dimension"], b["Dimension"]}, Return[failure["MetricDimensions", "The metric matrix must match the background dimension."]]];
  sym = Simplify[mat == Transpose[mat], Assumptions -> ass];
  If[!TrueQ[sym], Return[failure["MetricSymmetry", "Metric symmetry must be verifiable under the supplied assumptions."]]];
  det = Simplify[Det[mat], Assumptions -> ass];
  If[TrueQ[det == 0], Return[failure["DegenerateMetric", "The metric is identically degenerate."]]];
  If[signatureStatus[mat, b["Signature"], ass] === "Failed", Return[failure["MetricSignature", "The matrix signature conflicts with the declared background metric."]]];
  clearGeometry[tag];
  result = guard[MetricInBasis[b["Metric"], -b["Basis"], mat]];
  If[result === $Failed, Return[failure["MetricAssignment", "xCoba could not assign the metric."]]];
  put[tag, <|"MetricMatrix" -> mat, "MetricRevision" -> b["MetricRevision"] + 1,
    "CMetric" -> b["Metric"], "ComponentCovD" -> b["CovD"], "Assumptions" -> ass|>];
  result = replayFields[tag]; If[FailureQ[result], Return[result]];
  If[OptionValue[ComputeOnSet] =!= None,
    result = ComputeGeometry[tag, OptionValue[ComputeOnSet], CVSimplify -> OptionValue[CVSimplify], Assumptions -> ass, Verbose -> OptionValue[Verbose]];
    If[FailureQ[result], Return[result]]];
  $BG[tag]
];
CMetricOf[tag_String] := getter[tag, "CMetric"];
ComponentCovDOf[tag_String] := getter[tag, "ComponentCovD"];
MetricMatrixOf[tag_String] := getter[tag, "MetricMatrix"];

$geometryTargets = <|"Metric" -> {"Metric"[-1, -1], "Metric"[1, 1], "DetMetric"[]},
  "Christoffel" -> {"Christoffel"[1, -1, -1]}, "Ricci" -> {"Ricci"[-1, -1]},
  "RicciScalar" -> {"RicciScalar"[]}, "Einstein" -> {"Einstein"[-1, -1]},
  "Riemann" -> {"Riemann"[-1, -1, -1, -1], "Riemann"[-1, -1, -1, 1], "Riemann"[-1, -1, 1, 1]},
  "Weyl" -> {"Weyl"[-1, -1, -1, -1]}, "Kretschmann" -> {"Kretschmann"[]}|>;
Options[ComputeGeometry] = {CVSimplify -> Together, Assumptions -> Automatic, Verbose -> False, ForceCompute -> False};
ComputeGeometry[tag_String, targets_: {"Metric"}, OptionsPattern[]] := Module[
  {b = background[tag], wanted, todo, policy, ass, fun = OptionValue[CVSimplify], result, seconds, specs},
  If[FailureQ[b], Return[b]];
  If[!KeyExistsQ[b, "MetricMatrix"], Return[failure["NoMetricComponents", "Assign the metric matrix first."]]];
  wanted = If[targets === All, Keys[$geometryTargets], Flatten[{targets}]];
  If[!VectorQ[wanted, StringQ] || !SubsetQ[Keys[$geometryTargets], wanted], Return[failure["GeometryTargets", "Unknown geometry target.", <|"Allowed" -> Keys[$geometryTargets]|>]]];
  ass = Replace[OptionValue[Assumptions], Automatic :> Lookup[b, "Assumptions", True]];
  policy = {fun, ass};
  If[TrueQ[OptionValue[ForceCompute]] || (KeyExistsQ[b, "GeometryPolicy"] && b["GeometryPolicy"] =!= policy),
    clearGeometry[tag]; MetricInBasis[b["Metric"], -b["Basis"], b["MetricMatrix"]];
    replayFields[tag]; b = $BG[tag]];
  todo = Complement[wanted, b["ComputedGeometry"]];
  If[todo === {}, Return[<|"Computed" -> {}, "Cached" -> wanted, "Seconds" -> 0., "MetricRevision" -> b["MetricRevision"]|>]];
  specs = Flatten[Lookup[$geometryTargets, todo]];
  {seconds, result} = AbsoluteTiming[guard[MetricCompute[b["Metric"], b["Chart"], specs,
    CVSimplify -> fun, Verbose -> OptionValue[Verbose]]]];
  If[result === $Failed, Return[failure["GeometryComputation", "xCoba could not compute the requested geometry."]]];
  put[tag, <|"ComputedGeometry" -> Union[b["ComputedGeometry"], wanted], "GeometryPolicy" -> policy,
    "GeometryRuns" -> b["GeometryRuns"] + 1, "LastGeometrySeconds" -> seconds|>];
  <|"Computed" -> todo, "Cached" -> Complement[wanted, todo], "Seconds" -> seconds, "MetricRevision" -> b["MetricRevision"]|>
];

fieldSpec[b_, field_] := Module[{found},
  found = Select[Values[b["Field"]], # ["OldHead"] === field || # ["NewHead"] === field &];
  If[Length[found] === 1, First[found], failure["UnknownField", "The field is not registered in this background."]]
];
indicesFor[b_, n_] := If[n <= Length[b["Indices"]], Take[b["Indices"], n], GetIndicesOfVBundle[TangentBundleOfManifold[b["Manifold"]], n]];
storeField[b_, spec_] := Module[{head = spec["Head"], signs = spec["IndexPositions"], inds, expression},
  inds = indicesFor[b, Length[signs]];
  expression = head @@ Join[If[spec["Order"] === None, {}, {LI[spec["Order"]]}], MapThread[{#1 #2, #2 b["Basis"]} &, {inds, signs}]];
  guard[Block[{$CVVerbose = False}, If[signs === {}, ComponentValue[expression, spec["Values"]], AllComponentValues[expression, spec["Values"]]]]]
];
replayFields[tag_] := Module[{b = $BG[tag], records, heads, result},
  records = Values[b["FieldComponents"]];
  heads = DeleteDuplicates[Lookup[records, "Head", {}]];
  Scan[guard[DeleteTensorValues[#]] &, heads];
  result = storeField[b, #] & /@ records;
  If[MemberQ[result, $Failed], failure["FieldAssignment", "xCoba could not restore the field components."], Null]
];
Options[SetFieldComponents] = {IndexPositions -> Automatic, PerturbationOrderLabel -> 1, Assumptions -> Automatic};
SetFieldComponents[tag_String, field_Symbol, input_, OptionsPattern[]] := Module[
  {b = background[tag], fs, vals, signs, order, key, rec, result, ass, tensor, expected, actual},
  If[FailureQ[b], Return[b]];
  If[!KeyExistsQ[b, "Basis"], Return[failure["NoChart", "Define the chart before assigning field components."]]];
  fs = fieldSpec[b, field]; If[FailureQ[fs], Return[fs]];
  vals = profile[input, b]; signs = Replace[OptionValue[IndexPositions], Automatic :> fs["IndexPositions"]];
  If[Length[signs] =!= fs["Rank"] || !VectorQ[signs, MemberQ[{-1, 1}, #] &], Return[failure["IndexPositions", "Specify one +1 or -1 per tensor slot."]]];
  If[If[fs["Rank"] === 0, ListQ[vals], Dimensions[vals] =!= ConstantArray[b["Dimension"], fs["Rank"]]], Return[failure["FieldDimensions", "The component array does not match the field rank and dimension."]]];
  order = If[fs["Type"] === "MetricPert", OptionValue[PerturbationOrderLabel], None];
  If[order =!= None && (!IntegerQ[order] || order < 1), Return[failure["PerturbationOrder", "Perturbation components need a positive LI order."]]];
  ass = Replace[OptionValue[Assumptions], Automatic :> Lookup[b, "Assumptions", True]];
  (* Canonicalize the supplied array against the tensor's declared slot symmetries before storing anything. *)
  tensor = fs["NewHead"] @@ Join[If[order === None, {}, {LI[order]}], MapThread[{#1 #2, #2 b["Basis"]} &, {indicesFor[b, fs["Rank"]], signs}]];
  expected = If[fs["Rank"] === 0, tensor, guard[ToCanonical[ComponentArray[tensor]]]];
  If[expected === $Failed, Return[failure["FieldComponents", "The component configuration is invalid."]]];
  actual = MapThread[Function[{component, value},
    Which[component === 0, {0, value}, Head[component] === Times && First[component] === -1, {-component, -value}, True, {component, value}]],
    {Flatten[{expected}], Flatten[{vals}]}];
  If[!AllTrue[Select[actual, First[#] === 0 &], TrueQ[Simplify[Last[#] == 0, Assumptions -> ass]] &] ||
    !AllTrue[GatherBy[Select[actual, First[#] =!= 0 &], First], Function[group, AllTrue[group, TrueQ[Simplify[Last[#] == Last[First[group]], Assumptions -> ass]] &]]],
    Return[failure["FieldSymmetry", "The supplied values conflict with the tensor slot symmetries."]]];
  key = SymbolName[fs["NewHead"]] <> ":" <> ToString[order];
  rec = <|"Head" -> fs["NewHead"], "IndexPositions" -> signs, "Order" -> order, "Values" -> vals|>;
  put[tag, <|"FieldComponents" -> Join[b["FieldComponents"], <|key -> rec|>]|>];
  result = replayFields[tag]; If[FailureQ[result], put[tag, <|"FieldComponents" -> b["FieldComponents"]|>]; replayFields[tag]; Return[result]];
  rec
];

geometryNeeded[b_, expr_] := Module[{keys},
  keys = Select[Keys[$geometryTargets], # =!= "Metric" && !FreeQ[expr, b[#]] &];
  If[!FreeQ[expr, b["CovD"]], AppendTo[keys, "Christoffel"]];
  Union[{"Metric"}, keys]
];
prepareFieldConfigurations[tag_, expr_] := Module[{b = $BG[tag], atoms, fs, records, result, init},
  atoms = DeleteDuplicates@Cases[expr, x_ /; MatchQ[Unevaluated[x], h_[___]] && MemberQ[Lookup[Values[b["Field"]], "NewHead"], Head[x]], {0, Infinity}];
  Do[
    fs = fieldSpec[b, Head[atom]]; records = Select[Values[b["FieldComponents"]], # ["Head"] === Head[atom] &];
    If[records =!= {} && fs["Rank"] > 0,
      init = Head[atom] @@ Join[Select[List @@ atom, MatchQ[#, _LI] &],
        MapThread[{#1 #2, #2 b["Basis"]} &, {indicesFor[b, fs["Rank"]], First[records]["IndexPositions"]}]];
      result = guard[ChangeComponents[atom, init]];
      If[result === $Failed, Return[failure["FieldVariance", "Could not change the field index configuration."]]]
    ], {atom, atoms}]; Null
];
Options[ToComponents] = {FreeIndices -> Automatic, Components -> All, Assumptions -> Automatic,
  Simplification -> Simplify, ApplySpecialization -> True, StrictComponents -> False, CVSimplify -> Together};
resolveValues[expr_] := FixedPoint[ToValues, expr, 12];
coordinateIndexify[expr_, b_] := Module[{held, indices, rules},
  held = With[{e = expr}, HoldComplete[e]];
  indices = DeleteDuplicates@Cases[held, s_Symbol /; sourceIndexQ[s, TangentBundleOfManifold[b["Manifold"]]], Infinity, Heads -> True];
  rules = Thread[indices -> ({#, b["Basis"]} & /@ indices)];
  ReleaseHold[held /. rules]
];
traceValues[expr_List] := traceValues /@ expr;
traceValues[expr_Plus] := Total[traceValues /@ List @@ expr];
traceValues[expr_] := Module[{ex = resolveValues[expr], dummies, traced},
  If[Head[ex] === Plus, Return[traceValues[ex]]];
  dummies = IndicesOf[Dummy, BIndex][ex];
  If[Length[dummies] === 0, Return[ex]];
  traced = resolveValues[TraceBasisDummy[ex, First[dummies]]];
  If[traced === ex, ex, traceValues[traced]]
];
componentAt[expr_, indices_, numbers_] := Module[{held, rules},
  held = With[{e = expr}, HoldComplete[e]];
  rules = MapThread[Rule, {indices, MapThread[List, {numbers, Last /@ indices}]}];
  ReleaseHold[held /. rules]
];
ToComponents[tag_String, input_, OptionsPattern[]] := Module[
  {b = background[tag], ex, inds, actual, basisinds, result, geometry, arr, selected, simp = OptionValue[Simplification], ass, unresolved},
  If[FailureQ[b], Return[b]];
  If[!KeyExistsQ[b, "MetricMatrix"], Return[failure["NoMetricComponents", "Assign metric components before evaluating components."]]];
  ex = resolve[tag, input]; If[FailureQ[ex], Return[ex]];
  ex = PortExpression[tag, ex]; If[FailureQ[ex], Return[ex]];
  If[TrueQ[OptionValue[ApplySpecialization]], ex = ApplyRules[tag, ex]];
  If[FailureQ[ex], Return[ex]];
  actual = guard[List @@ IndicesOf[Free][ex]];
  If[actual === $Failed, Return[failure["FreeIndices", "The expression has inconsistent free indices."]]];
  inds = OptionValue[FreeIndices];
  If[inds === Automatic, inds = actual,
    If[Head[inds] === IndexList, inds = List @@ inds];
    If[!ListQ[inds], Return[failure["FreeIndices", "FreeIndices must be a list."]]];
    inds = List @@ PortExpression[tag, IndexList @@ inds];
    If[Sort[inds] =!= Sort[actual], Return[failure["FreeIndices", "The specified indices must match all free indices exactly."]]]];
  geometry = ComputeGeometry[tag, geometryNeeded[b, ex], CVSimplify -> OptionValue[CVSimplify]];
  If[FailureQ[geometry], Return[geometry]];
  ex = guard[ChangeCovD[SeparateMetric[][ex], b["CovD"], PDOfBasis[b["Chart"]]]];
  If[ex === $Failed, Return[failure["Derivatives", "The covariant derivative could not be expanded."]]];
  ex = guard[coordinateIndexify[ex, b]];
  If[ex === $Failed, Return[failure["BasisConversion", "The expression could not be converted to the chart basis."]]];
  result = prepareFieldConfigurations[tag, ex]; If[FailureQ[result], Return[result]];
  basisinds = If[UpIndexQ[#], {#, b["Basis"]}, {#, -b["Basis"]}] & /@ inds;
  selected = OptionValue[Components];
  If[selected === All,
    arr = If[inds === {}, ex, guard[ComponentArray[ex, IndexList @@ basisinds]]],
    If[!ListQ[selected] || !AllTrue[selected, ListQ[#] && Length[#] === Length[inds] && VectorQ[#, IntegerQ[#] && 0 <= # < b["Dimension"] &] &],
      Return[failure["Components", "Select components using a list of zero-based coordinate-number tuples."]]];
    arr = If[inds === {}, ConstantArray[ex, Length[selected]],
      (guard[componentAt[ex, basisinds, #]] & /@ selected)]
  ];
  If[arr === $Failed || !FreeQ[arr, $Failed], Return[failure["ComponentArray", "The component array could not be constructed."]]];
  arr = guard[resolveValues[traceValues[arr]]];
  If[arr === $Failed, Return[failure["ComponentValues", "xCoba could not evaluate component values."]]];
  ass = Replace[OptionValue[Assumptions], Automatic :> Lookup[b, "Assumptions", True]];
  arr = If[MemberQ[{Simplify, FullSimplify}, simp], simp[arr, Assumptions -> ass], simp[arr]];
  unresolved = DeleteDuplicates@Cases[arr, x_ /; (MatchQ[Unevaluated[x], h_[___]] && xTensorQ[Head[x]]) || MatchQ[Unevaluated[x], _?CovDQ[_][___]] || MatchQ[Unevaluated[x], _Perturbation], {0, Infinity}];
  If[TrueQ[OptionValue[StrictComponents]] && unresolved =!= {},
    failure["UnresolvedComponents", "Some tensor components or derivatives remain symbolic.", <|"Expressions" -> unresolved|>], arr]
];
ToBasisOf[tag_String, expr_] := Module[{b = background[tag]}, If[FailureQ[b], b, guard[TraceBasisDummy[ToBasis[b["Basis"]][expr]]]]];
ToValuesOf[tag_String, expr_] := Module[{ex = ToBasisOf[tag, expr]}, If[FailureQ[ex], ex, guard[ToValues[ex]]]];
ExprMatrixOf[tag_String, expr_] := ToComponents[tag, expr];

zeroCheck[expr_, ass_] := Module[{simp = Simplify[expr, Assumptions -> ass]},
  Which[TrueQ[simp == 0], "Passed", TrueQ[Simplify[simp != 0, Assumptions -> ass]], "Failed", True, "Inconclusive"]];
arrayZeroCheck[expr_, ass_] := Module[{statuses}, If[FailureQ[expr], Return[<|"Status" -> "Inconclusive", "Reason" -> expr|>]];
  statuses = zeroCheck[#, ass] & /@ Flatten[{expr}];
  <|"Status" -> Which[MemberQ[statuses, "Failed"], "Failed", MemberQ[statuses, "Inconclusive"], "Inconclusive", True, "Passed"], "Residual" -> expr|>];
Options[CheckBackground] = {Checks -> {"Structure", "MetricSymmetry", "Nondegenerate", "InverseMetric", "Signature", "AssignedFields"}, Assumptions -> Automatic};
CheckBackground[tag_String, OptionsPattern[]] := Module[{b = background[tag], checks = OptionValue[Checks], ass, results = <||>, mat, determinant, inds, ex, comp, unknown, s, missingFields},
  If[FailureQ[b], Return[b]];
  If[checks === All, checks = {"Structure", "MetricSymmetry", "Nondegenerate", "InverseMetric", "Signature", "AssignedFields", "MetricCompatibility", "Bianchi"}];
  unknown = Complement[Flatten[{checks}], {"Structure", "MetricSymmetry", "Nondegenerate", "InverseMetric", "Signature", "AssignedFields", "MetricCompatibility", "Bianchi"}];
  If[unknown =!= {}, Return[failure["Checks", "Unknown background check.", <|"Checks" -> unknown|>]]];
  ass = Replace[OptionValue[Assumptions], Automatic :> Lookup[b, "Assumptions", True]];
  Do[
    results[check] = Switch[check,
      "Structure", <|"Status" -> If[ManifoldQ[b["Manifold"]] && MetricQ[b["Metric"]] && CovDQ[b["CovD"]] && KeyExistsQ[b, "Chart"] && KeyExistsQ[b, "MetricMatrix"], "Passed", "Failed"]|>,
      "AssignedFields", missingFields = Select[Values[b["Field"]], # ["Type"] =!= "MetricPert" && !MemberQ[Lookup[Values[b["FieldComponents"]], "Head", {}], # ["NewHead"]] &];
        <|"Status" -> If[missingFields === {}, "Passed", "Inconclusive"], "MissingFields" -> Lookup[missingFields, "OldHead", {}]|>,
      "MetricCompatibility" | "Bianchi",
        inds = indicesFor[b, 3];
        ex = If[check === "MetricCompatibility", b["CovD"][-inds[[1]]][b["Metric"][-inds[[2]], -inds[[3]]]],
          b["CovD"][inds[[1]]][b["Einstein"][-inds[[1]], -inds[[2]]]]];
        (* ChangeCovD happens before xTensor can replace these identities by zero. Explicit coordinate check below. *)
        If[check === "MetricCompatibility", coordinateCompatibility[tag, ass], coordinateBianchi[tag, ass]],
      _, If[!KeyExistsQ[b, "MetricMatrix"], <|"Status" -> "Inconclusive", "Reason" -> "Metric components missing"|>,
        mat = b["MetricMatrix"];
        Switch[check,
          "MetricSymmetry", arrayZeroCheck[mat - Transpose[mat], ass],
          "Nondegenerate", determinant = Simplify[Det[mat], Assumptions -> ass];
            <|"Status" -> Which[TrueQ[determinant == 0], "Failed", TrueQ[Simplify[determinant != 0, Assumptions -> ass]], "Passed", True, "Inconclusive"], "Determinant" -> determinant|>,
          "Signature", <|"Status" -> signatureStatus[mat, b["Signature"], ass]|>,
          "InverseMetric", comp = ToComponents[tag, b["Metric"] @@ Take[b["Indices"], 2], ApplySpecialization -> False];
            arrayZeroCheck[If[FailureQ[comp], comp, mat . comp - IdentityMatrix[b["Dimension"]]], ass]
        ]]];
    , {check, Flatten[{checks}]}];
  s = Lookup[Values[results], "Status"];
  <|"Background" -> tag, "Status" -> Which[MemberQ[s, "Failed"], "Failed", MemberQ[s, "Inconclusive"], "Inconclusive", True, "Passed"], "Checks" -> results|>
];
coordinateCompatibility[tag_, ass_] := Module[{b = $BG[tag], ch, cd, ids, gamma, mat, coords, residual, n},
  ComputeGeometry[tag, {"Christoffel"}]; ch = b["Basis"]; cd = b["CovD"]; ids = indicesFor[b, 3];
  gamma = ToValues[ComponentArray[Christoffel[cd, PDOfBasis[ch]][{ids[[1]], ch}, {-ids[[2]], -ch}, {-ids[[3]], -ch}]]];
  mat = b["MetricMatrix"]; coords = coordinateValues[b]; n = b["Dimension"];
  residual = Table[D[mat[[i, j]], coords[[k]]] - Sum[gamma[[l, k, i]] mat[[l, j]] + gamma[[l, k, j]] mat[[i, l]], {l, n}], {k, n}, {i, n}, {j, n}];
  arrayZeroCheck[residual, ass]
];
coordinateBianchi[tag_, ass_] := Module[{b = $BG[tag], ch, cd, ids, gamma, inv, einstein, coords, n, mixed, residual},
  ComputeGeometry[tag, {"Christoffel", "Einstein"}]; ch = b["Basis"]; cd = b["CovD"]; ids = indicesFor[b, 3];
  gamma = ToValues[ComponentArray[Christoffel[cd, PDOfBasis[ch]][{ids[[1]], ch}, {-ids[[2]], -ch}, {-ids[[3]], -ch}]]];
  inv = Inverse[b["MetricMatrix"]]; einstein = ToComponents[tag, b["Einstein"][-ids[[1]], -ids[[2]]], ApplySpecialization -> False];
  If[FailureQ[einstein], Return[<|"Status" -> "Inconclusive", "Reason" -> einstein|>]];
  mixed = inv . einstein; coords = coordinateValues[b]; n = b["Dimension"];
  residual = Table[Sum[D[mixed[[i, j]], coords[[i]]] + Sum[gamma[[i, i, l]] mixed[[l, j]] - gamma[[l, i, j]] mixed[[i, l]], {l, n}], {i, n}], {j, n}];
  arrayZeroCheck[residual, ass]
];

Options[PerturbOn] = {Output -> "Abstract", PerturbationForm -> "Variation", ApplySpecialization -> True,
  FreeIndices -> Automatic, Components -> All, Assumptions -> Automatic, Simplification -> Simplify, StrictComponents -> False};
PerturbOn[tag_String, input_, order_Integer: 1, OptionsPattern[]] := Module[{b = background[tag], ex, result, form = OptionValue[PerturbationForm]},
  If[FailureQ[b], Return[b]];
  If[order < 0, Return[failure["PerturbationOrder", "The order must be nonnegative."]]];
  If[b["PerturbationHead"] === None, Return[failure["NoMetricPerturbation", "Register a MetricPert field before creating the background."]]];
  If[!MemberQ[{"Variation", "TaylorCoefficient"}, form] || !MemberQ[{"Abstract", "Components"}, OptionValue[Output]], Return[failure["PerturbationOptions", "Choose Variation or TaylorCoefficient, and Abstract or Components output."]]];
  ex = resolve[tag, input]; If[FailureQ[ex], Return[ex]];
  ex = PortExpression[tag, ex]; If[FailureQ[ex], Return[ex]];
  result = guard[Block[{$PerturbationParameter = b["PerturbationParameter"]}, ToCanonical[ContractMetric[ExpandPerturbation[Perturbation[ex, order]]]]]];
  If[result === $Failed, Return[failure["Perturbation", "xPert could not expand the requested variation."]]];
  If[form === "TaylorCoefficient", result = result/Factorial[order]];
  If[OptionValue[Output] === "Components", Return[ToComponents[tag, result, FreeIndices -> OptionValue[FreeIndices], Components -> OptionValue[Components], Assumptions -> OptionValue[Assumptions],
    Simplification -> OptionValue[Simplification], StrictComponents -> OptionValue[StrictComponents], ApplySpecialization -> OptionValue[ApplySpecialization]]]];
  If[TrueQ[OptionValue[ApplySpecialization]], result = ApplyRules[tag, result]];
  result
];

ownedObjects[b_] := Module[{roots, relative},
  roots = DeleteMissing@Join[Lookup[b, {"Manifold", "Metric", "CovD", "Chart", "PerturbationParameter"}], Lookup[Values[b["Field"]], "NewHead", {}],connectionHeads[b],relativeHeads[b]];
  If[KeyExistsQ[b,"CovD"] && CovDQ[b["CovD"]] && KeyExistsQ[b, "Chart"] && ChartQ[b["Chart"]], relative = GiveSymbol[Christoffel, Sequence @@ Sort[{b["CovD"], PDOfBasis[b["Chart"]]}]]; If[xTensorQ[relative], AppendTo[roots, relative]]];
  FixedPoint[DeleteDuplicates@Join[#, Flatten[ServantsOf /@ #]] &, roots]
];
disposeObjects[b_] := Module[{fields, relative, parameter = b["PerturbationParameter"]},
  fields = Reverse[Lookup[Values[b["Field"]], "NewHead", {}]];
  Scan[If[xTensorQ[#], DeleteTensorValues[#]; UndefTensor[#]] &, fields];
  If[KeyExistsQ[b,"CovD"] && CovDQ[b["CovD"]] && KeyExistsQ[b, "Chart"] && ChartQ[b["Chart"]],
    relative = GiveSymbol[Christoffel, Sequence @@ Sort[{b["CovD"], PDOfBasis[b["Chart"]]}]];
    If[xTensorQ[relative], UndefTensor[relative]]];
  Scan[If[CovDQ[#] && #=!=Lookup[b,"CovD",None],UndefCovD[#]]&,Reverse@connectionHeads[b]];
  If[MetricQ[b["Metric"]], UndefMetric[b["Metric"]]];
  If[KeyExistsQ[b, "Chart"] && ChartQ[b["Chart"]], UndefChart[b["Chart"]]];
  If[ManifoldQ[b["Manifold"]], UndefManifold[b["Manifold"]]];
  If[ParameterQ[parameter], UndefParameter[parameter]];
  Null
];
DeleteBackground[tag_String] := Module[{b = background[tag], result, owned, external},
  If[FailureQ[b], Return[b]];
  owned = ownedObjects[b];
  external = Complement[DeleteDuplicates@Flatten[VisitorsOf /@ owned], owned];
  If[external =!= {}, Return[failure["ExternalDependents", "External xAct objects depend on this background; undefine them explicitly first.", <|"Objects" -> external|>]]];
  clearGeometry[tag];
  result = guard[Internal`InheritedBlock[{Undef},
    Unprotect[Undef];
    Undef[s_Symbol /; StringStartsQ[ToString[Unevaluated[s], InputForm], "Removed["]] := Null;
    disposeObjects[b]
  ]];
  If[result === $Failed, Return[failure["DeleteBackground", "xAct could not undefine all owned objects; the registry entry was retained."]]];
  KeyDropFrom[$BG, tag]; Null
];
ClearBackgrounds[] := Module[{results}, results = DeleteBackground /@ Keys[$BG]; If[AnyTrue[results, FailureQ], results, Null]];
RicciOf[tag_String] := getter[tag, "Ricci"];
RicciScalarOf[tag_String] := getter[tag, "RicciScalar"];
EinsteinOf[tag_String] := getter[tag, "Einstein"];
RiemannOf[tag_String] := getter[tag, "Riemann"];
WeylOf[tag_String] := getter[tag, "Weyl"];
ChristoffelOf[tag_String] := getter[tag, "Christoffel"];
BackgroundIndices[tag_String, n_: Automatic] := Module[{b = background[tag]}, If[FailureQ[b], Return[b]];
  If[n === Automatic, b["Indices"], If[IntegerQ[n] && 0 <= n <= Length[b["Indices"]], Take[b["Indices"], n], failure["IndexCount", "Invalid number of indices."]]]];
ShowBackground[tag_String] := background[tag];
ShowTheory[] := $Theory;
TheoryValue[key_String] := Lookup[$Theory, key, failure["TheoryKey", "The theory key does not exist.", <|"Key" -> key|>]];


(* Scoped formatting and naming: only owned symbols receive upvalues. *)
If[!AssociationQ[$PresentationPreferences], $PresentationPreferences = <||>];
safeName[s_String] := Module[{t = StringReplace[s, Except[LetterCharacter | DigitCharacter] -> ""]},
  If[t === "", "Object", If[StringMatchQ[StringTake[t,1], DigitCharacter], "N" <> t, t]]];
installCovDNames[cd_, ctx_] := With[{cc = cd, context = ctx},
  cc /: GiveSymbol[kind_Symbol, cc] := Symbol[context <> SymbolName[kind] <> SymbolName[cc]];
  cc /: GiveSymbol[Christoffel, cc, other_Symbol] := Symbol[context <> "Christoffel" <> SymbolName[cc] <> SymbolName[other]];
  cc /: GiveSymbol[Christoffel, other_Symbol, cc] := Symbol[context <> "Christoffel" <> SymbolName[other] <> SymbolName[cc]];
];
setBareBoxes[head_Symbol, label_String] := With[{hh = head, ll = label},
  hh /: MakeBoxes[hh, StandardForm] := InterpretationBox[ll, hh];
  hh /: MakeBoxes[hh, TraditionalForm] := InterpretationBox[ll, hh];
];
SetXPlorerPreferences[assoc_Association] := If[AllTrue[Values[assoc], StringQ[#] || MatchQ[#, {_String,_String}] &],
  $PresentationPreferences = assoc, failure["Presentation", "Defaults must be strings or connection marker pairs."]];
RegisterTheory["Presentation", assoc_Association] := ($Theory["Presentation"] = assoc; $Theory);
BackgroundObject[tag_String, key_String] := Module[{b = background[tag]},
  If[FailureQ[b], Return[b]];
  If[KeyExistsQ[b["Field"], key], b["Field"][key]["NewHead"], getter[tag,key]]
];
SetPresentation[tag_String, assoc_Association] := Module[{b = background[tag], unknown, current, effective, objects, val},
  If[FailureQ[b], Return[b]];
  unknown = Complement[Keys[assoc], Keys[b["PresentationDefaults"]]];
  If[unknown =!= {} || !AllTrue[Normal[assoc], Function[r, Last[r] === Automatic || If[First[r] === "CovD", MatchQ[Last[r], {_String,_String}], StringQ[Last[r]]]]],
    Return[failure["Presentation", "Use known object keys and string labels; CovD takes two strings.", <|"Keys" -> unknown|>]]];
  current = Join[b["PresentationOverrides"], assoc];
  current = Select[current, # =!= Automatic &];
  effective = Join[b["PresentationDefaults"], current];
  objects = Join[AssociationThread[Keys[b["Field"]], Lookup[Values[b["Field"]], "NewHead"]], KeyTake[b, Keys[b["PresentationDefaults"]]]];
  KeyValueMap[Function[{key,head},
    val = effective[key];
    If[key === "CovD", With[{cc = head, vv = val}, SymbolOfCovD[cc] ^= vv],
      With[{hh = head, vv = val}, PrintAs[hh] ^= vv]];
    setBareBoxes[head, SymbolName[head]];
  ], objects];
  Scan[setBareBoxes[#, SymbolName[#]] &, Join[{b["Manifold"]}, b["Indices"]]];
  put[tag, <|"PresentationOverrides" -> current|>]; effective
];
PresentationOf[tag_String] := Module[{b = background[tag]}, If[FailureQ[b], b,
  <|"Defaults" -> b["PresentationDefaults"], "Overrides" -> b["PresentationOverrides"],
    "Effective" -> Join[b["PresentationDefaults"], b["PresentationOverrides"]]|>]];

(* Expression views are interpreted boxes, never replacements in the calculation. *)
$notationDefaults = <|"PartialStyle" -> "Native", "CovariantStyle" -> "Native", "ShowBackgroundLabel" -> False|>;
validNotation[a_] := AssociationQ[a] && Complement[Keys[a], Keys[$notationDefaults]] === {} &&
  MemberQ[{"Native","MultiIndex","Fraction","Partial","Prime"}, Lookup[a,"PartialStyle","Native"]] &&
  MemberQ[{"Native","Prefix","Postfix"}, Lookup[a,"CovariantStyle","Native"]] &&
  MemberQ[{True,False}, Lookup[a,"ShowBackgroundLabel",False]];
SetNotation[tag_String, a_Association] := Module[{b=background[tag]}, If[FailureQ[b],Return[b]];
  If[!validNotation[a],Return[failure["Notation","Unknown notation setting."]]];
  put[tag,<|"Notation" -> Join[$notationDefaults,Lookup[b,"Notation",<||>],a]|>]["Notation"]];
Options[DisplayExpression] = {PartialStyle -> Automatic, CovariantStyle -> Automatic, ShowBackgroundLabel -> Automatic};
DisplayExpression[tag_String, expr_, OptionsPattern[]] := Module[{b=background[tag],a,local},
  If[FailureQ[b],Return[b]];
  local=Select[<|"PartialStyle"->OptionValue[PartialStyle],"CovariantStyle"->OptionValue[CovariantStyle],"ShowBackgroundLabel"->OptionValue[ShowBackgroundLabel]|>,# =!= Automatic &];
  a=Join[$notationDefaults,Lookup[b,"Notation",<||>],local];
  If[!validNotation[a],Return[failure["Notation","Unknown notation setting."]]];
  expressionView[expr,a,tag]
];
expressionView /: Normal[expressionView[e_,_,_]] := e;
expressionView /: MakeBoxes[expressionView[e_,a_,tag_], StandardForm] :=
  With[{boxes=If[TrueQ[a["ShowBackgroundLabel"]],RowBox[{StyleBox[tag,FontWeight->Bold],": ",notationBoxes[e,a]}],notationBoxes[e,a]], original=e}, InterpretationBox[boxes,original]];
expressionView /: MakeBoxes[expressionView[e_,a_,tag_], TraditionalForm] := MakeBoxes[expressionView[e,a,tag],StandardForm];
nativeBoxes[e_] := With[{ex=e},MakeBoxes[ex,StandardForm]];
notationBoxes[e_,a_] := Module[{orders,args,fn,n,terms,den,body,mark,ix,h=Head[e],items},
  If[a["PartialStyle"]==="Native" && a["CovariantStyle"]==="Native",Return[nativeBoxes[e]]];
  If[MatchQ[e,Derivative[__][_][__]] && a["PartialStyle"]=!="Native",
    orders=List@@Head[Head[e]]; args=List@@e; fn=Head[e][[1]]; n=Total[orders];
    If[a["PartialStyle"]==="Prime" && Length[args]=!=1,Return[nativeBoxes[e]]];
    body=RowBox[{nativeBoxes[fn],"[",RowBox[Riffle[nativeBoxes /@ args,","]],"]"}];
    Return[Switch[a["PartialStyle"],
      "MultiIndex",RowBox[{SuperscriptBox[nativeBoxes[fn],RowBox[{"(",RowBox[Riffle[ToString /@ orders,","]],")"}]],"[",RowBox[Riffle[nativeBoxes /@ args,","]],"]"}],
      "Prime",RowBox[{SuperscriptBox[nativeBoxes[fn],StringRepeat["'",n]],"[",nativeBoxes[First[args]],"]"}],
      _,terms=MapThread[If[#2===0,Nothing,RowBox[{"\[PartialD]",If[#2===1,nativeBoxes[#1],SuperscriptBox[nativeBoxes[#1],ToString[#2]]]}]]&,{args,orders}];
      den=RowBox[Riffle[terms," "]];
      If[a["PartialStyle"]==="Fraction",FractionBox[RowBox[{If[n===1,"\[PartialD]",SuperscriptBox["\[PartialD]",ToString[n]]],body}],den],
        RowBox[{RowBox[Riffle[MapThread[If[#2===0,Nothing,SubscriptBox[If[#2===1,"\[PartialD]",SuperscriptBox["\[PartialD]",ToString[#2]]],nativeBoxes[#1]]]&,{args,orders}]," "]]," ",body}]]]]
  ];
  If[MatchQ[e,_?CovDQ[_][_]] && a["CovariantStyle"]=!="Native",
    fn=Head[Head[e]]; ix=First[Head[e]]; body=notationBoxes[First[e],a];
    mark=First[SymbolOfCovD[fn]];
    Return[If[a["CovariantStyle"]==="Postfix",SubscriptBox[RowBox[{"(",body,")"}],RowBox[{mark,nativeBoxes[ix]}]],
      RowBox[{SubscriptBox[Last[SymbolOfCovD[fn]],nativeBoxes[ix]],"(",body,")"}]]]
  ];
  If[AtomQ[e] || xTensorQ[h] || FreeQ[e,Derivative|_?CovDQ],Return[nativeBoxes[e]]];
  items=notationBoxes[#,a]& /@ (List@@e);
  Switch[h,
    Plus, RowBox[Riffle[(RowBox[{"(",#,")"}]& /@ items)," + "]],
    Times,RowBox[Riffle[(RowBox[{"(",#,")"}]& /@ items)," "]],
    Power,SuperscriptBox[RowBox[{"(",items[[1]],")"}],items[[2]]],
    List,RowBox[{"{",RowBox[Riffle[items,","]],"}"}],
    Equal,RowBox[Riffle[items," == "]],
    _,RowBox[{nativeBoxes[h],"[",RowBox[Riffle[items,","]],"]"}]
  ]
];

(* Explicit lifecycle operations. Registration never transfers ownership. *)
ClearComputedValues[tag_String] := Module[{b=background[tag],r},If[FailureQ[b],Return[b]];
  clearGeometry[tag];
  If[KeyExistsQ[b,"MetricMatrix"],r=guard[MetricInBasis[b["Metric"],-b["Basis"],b["MetricMatrix"]]];If[r===$Failed,Return[failure["ClearValues","Metric values could not be restored."]]]];
  replayFields[tag];invalidateResults[tag];Null
];
ClearFieldComponents[tag_String,field_] := Module[{b=background[tag],fs,records,r},If[FailureQ[b],Return[b]];
  fs=If[StringQ[field],Lookup[b["Field"],field,Missing[]],fieldSpec[b,field]];
  If[!AssociationQ[fs],Return[failure["UnknownField","Choose a registered field."]]];
  r=guard[DeleteTensorValues[fs["NewHead"]]];If[r===$Failed,Return[failure["ClearValues","Could not clear the field values."]]];
  records=Select[b["FieldComponents"],#["Head"]=!=fs["NewHead"]&];
  put[tag,<|"FieldComponents"->records|>];invalidateResults[tag];Null
];
Options[UnregisterTheory]={Cascade->False};
UnregisterTheory[section_String,key_String,OptionsPattern[]] := Module[{a=Lookup[$Theory,section,<||>],head,refs,ex,lag},
  If[!AssociationQ[a] || !KeyExistsQ[a,key],Return[failure["TheoryKey","The registered item does not exist."]]];
  head=If[section==="Field",a[key]["Head"],None];refs={};
  If[head=!=None,
    ex=Lookup[$Theory,"Expr",<||>];refs=Keys@Select[ex,!FreeQ[#,head]&];
    lag=!FreeQ[Lookup[$Theory,"Lagrangian",None],head] || !FreeQ[Lookup[$Theory,"LagrangianMap",<||>],head];
    If[(refs=!={} || lag) && !TrueQ[OptionValue[Cascade]],Return[failure["RegisteredDependents","Expressions depend on this field; Cascade -> True removes their registrations, not xAct source objects.",<|"Expressions"->refs|>]]];
    If[TrueQ[OptionValue[Cascade]],$Theory["Expr"]=KeyDrop[ex,refs];
      If[lag,KeyDropFrom[$Theory,{"Lagrangian","LagrangianMap"}]]]
  ];
  $Theory[section]=KeyDrop[a,key];$Theory
];
UnregisterTheory[section_String] := If[KeyExistsQ[$Theory,section],KeyDropFrom[$Theory,section];$Theory,failure["TheoryKey","The section does not exist."]];
objectRegisteredQ[s_] := TrueQ[xTensorQ[s] || CovDQ[s] || ChartQ[s] || MetricQ[s] || ManifoldQ[s] || ParameterQ[s]];
servantClosure[roots_] := FixedPoint[DeleteDuplicates@Join[#,Flatten[ServantsOf /@ #]]&,roots];
visitorClosure[roots_] := FixedPoint[DeleteDuplicates@Join[#,Flatten[VisitorsOf /@ #]]&,roots];
managedObjects[b_] := Join[KeyTake[b,{"Metric","CovD","Chart","Manifold","PerturbationParameter"}],
  AssociationThread[Keys[b["Field"]],Lookup[Values[b["Field"]],"NewHead"]],
  Map[#["Head"]&,Lookup[b,"Connections",<||>]]];
Options[DeletionPlan]={Cascade->False};
DeletionPlan[tag_String,key_String:"Background",OptionsPattern[]] := Module[
 {b=background[tag],obj,roots,owned,remove,external,visitors,fields,exprs,ruleHits,uses,blockers,order,geometry},
 If[FailureQ[b],Return[b]];
 If[MemberQ[{"Background","Manifold"},key],
  owned=ownedObjects[b];external=Complement[visitorClosure[owned],owned];
  Return[<|"Background"->tag,"Key"->key,"Objects"->owned,"ExternalBlockers"->external,"Blockers"->external,
    "RegisteredExpressions"->Keys@Lookup[b["Theory"],"Expr",<||>],"RulePositions"->Range[Length[b["SpecializationRules"]]],
    "Order"->{"Fields","Connections","Metric","Chart","Manifold","Parameter"},"CanDelete"->(external==={})|>]];
 If[key==="CovD",Return[failure["PrimaryConnection","The Levi-Civita connection belongs to the metric. Delete Metric with its family instead."]]];
 obj=Lookup[managedObjects[b],key,Missing[]];If[MissingQ[obj],Return[failure["ObjectKey","Choose an owned background object, not a source symbol or generated curvature servant."]]];
 owned=ownedObjects[b];roots=servantClosure[{obj}];
 If[key==="Chart" && KeyExistsQ[b,"Metric"],
   roots=Union[roots,Select[{GiveSymbol[Determinant,b["Metric"],b["Chart"]],GiveSymbol[Christoffel,Sequence@@Sort[{b["CovD"],PDOfBasis[b["Chart"]]}]]},xTensorQ]];
   owned=Union[owned,roots]
 ];
 visitors=visitorClosure[roots];
 external=Complement[visitors,owned];
 remove=If[TrueQ[OptionValue[Cascade]],Intersection[visitors,owned],roots];
 (* The manifold is always an owner/host, never an implicit cascade target. *)
 If[MemberQ[remove,b["Manifold"]],Return[failure["CascadeScope","Use explicit background deletion for a manifold cascade."]]];
 exprs=Keys@Select[Lookup[b["Theory"],"Expr",<||>],Function[e,uses=PortExpression[tag,e];AnyTrue[remove,!FreeQ[uses,#]&]]];
 ruleHits=Select[Range[Length[b["SpecializationRules"]]],Function[n,AnyTrue[remove,!FreeQ[b["SpecializationRules"][[n]],#]&]]];
 blockers=Join[external,If[TrueQ[OptionValue[Cascade]],{},Complement[visitors,remove]],If[TrueQ[OptionValue[Cascade]],{},exprs],If[TrueQ[OptionValue[Cascade]],{},ruleHits]];
 order=Select[Reverse@Values[b["Field"]],MemberQ[remove,#["NewHead"]]&];order=Lookup[order,"NewHead",{}];
 order=DeleteDuplicates@Join[order,Select[remove,xTensorQ[#] && !MetricQ[#] && MasterOf[#]=!=obj&],
   Select[remove,CovDQ[#] && #=!=b["CovD"]&],If[MemberQ[remove,b["Metric"]],{b["Metric"]},{}],
   If[MemberQ[remove,Lookup[b,"Chart",None]],{b["Chart"]},{}],Select[remove,ParameterQ],{obj}];
 order=Select[order,!MemberQ[remove,MasterOf[#]]&];
 <|"Background"->tag,"Key"->key,"Objects"->remove,"ExternalBlockers"->external,"Blockers"->blockers,
  "RegisteredExpressions"->exprs,"RulePositions"->ruleHits,"Order"->order,"CanDelete"->(blockers==={})|>
];
undefOwned[o_] := Module[{master=MasterOf[o]},
 If[objectRegisteredQ[o] && master=!=Null && objectRegisteredQ[master],
   With[{mm=master,ss=o},ServantsOf[mm]^=DeleteCases[ServantsOf[mm],ss];MasterOf[ss]^=Null]];
 Which[ChartQ[o],UndefChart[o],MetricQ[o],UndefMetric[o],CovDQ[o],UndefCovD[o],xTensorQ[o],DeleteTensorValues[o];UndefTensor[o],ParameterQ[o],UndefParameter[o],True,Null]
];
Options[DeleteBackgroundObject]={Cascade->False};
DeleteBackgroundObject[tag_String,key_String,OptionsPattern[]] := Module[{b=background[tag],plan,removed,names,r,newb,deadKeys,exprs,remaining},
 If[FailureQ[b],Return[b]];
 plan=DeletionPlan[tag,key,Cascade->OptionValue[Cascade]];If[FailureQ[plan],Return[plan]];
 If[!TrueQ[plan["CanDelete"]],Return[failure["DeleteBlocked","Owned or external dependents block deletion.",<|"Plan"->plan|>]]];
 If[MemberQ[{"Background","Manifold"},key],Return[DeleteBackground[tag]]];
 removed=plan["Objects"];names=ToString[#,InputForm]& /@ removed;
 If[KeyExistsQ[b,"MetricMatrix"],clearGeometry[tag]];
 r=guard[Internal`InheritedBlock[{Undef},Unprotect[Undef];
   Undef[s_Symbol /; StringStartsQ[ToString[Unevaluated[s],InputForm],"Removed["]]:=Null;
   Scan[undefOwned,plan["Order"]]
 ]];
 remaining=Select[names,TrueQ[ToExpression[#,InputForm,objectRegisteredQ]]&];
 If[r===$Failed || remaining=!={},Return[failure["PartialDeletion","Deletion did not complete. Inspect the retained registry and actual xAct objects before retrying.",<|"RemainingNames"->remaining|>]]];
 newb=$BG[tag];deadKeys=Keys@Select[managedObjects[newb],!objectRegisteredQ[#]&];
 newb["Field"]=Select[newb["Field"],xTensorQ[#["NewHead"]]&];
 newb["Connections"]=Select[Lookup[newb,"Connections",<||>],CovDQ[#["Head"]]&];
 newb["FieldComponents"]=Select[newb["FieldComponents"],xTensorQ[#["Head"]]&];
 newb["HeadRules"]=Select[newb["HeadRules"],objectRegisteredQ[Last[#]]&];
 newb["SpecializationRules"]=Delete[b["SpecializationRules"],List /@ plan["RulePositions"]];
 With[{tt=Join[newb["Theory"],<|"Expr"->KeyDrop[Lookup[b["Theory"],"Expr",<||>],plan["RegisteredExpressions"]]|>]},newb["Theory"]=tt];
 If[MemberQ[deadKeys,"Metric"],
  newb=KeyDrop[newb,Join[{"Christoffel","Riemann","Ricci","RicciScalar","Einstein","Weyl","TFRicci","Kretschmann","Epsilon","DetMetric"},{"Metric","CovD","MetricMatrix","CMetric","ComponentCovD","GeometryPolicy"}]];
  newb["GeometryState"]="AbstractWithoutMetric";
 ];
 If[MemberQ[deadKeys,"Chart"],
  Scan[If[xTensorQ[#],DeleteTensorValues[#]]&,Lookup[Values[newb["Field"]],"NewHead",{}]];
  newb["FieldComponents"]=<||>;
  newb=KeyDrop[newb,{"Chart","Basis","Coordinates","CoordinateLabels","MetricMatrix","CMetric","ComponentCovD","GeometryPolicy"}]
 ];
 newb["PresentationDefaults"]=KeyDrop[newb["PresentationDefaults"],deadKeys];
 newb["PresentationOverrides"]=KeyDrop[newb["PresentationOverrides"],deadKeys];
 $BG[tag]=newb;invalidateResults[tag];
 <|"DeletedNames"->names,"BackgroundRetained"->True,"RemovedExpressions"->plan["RegisteredExpressions"]|>
];
ReconstructionData[tag_String] := Module[{b=background[tag]},If[FailureQ[b],b,
 KeyTake[b,{"Theory","Signature","CoordinateLabels","MetricMatrix","FieldComponents","SpecializationRules","PresentationOverrides","Notation"}]]];
invalidateResults[tag_] := If[KeyExistsQ[$BG,tag],put[tag,<|"DataRevision"->Lookup[$BG[tag],"DataRevision",0]+1,"SavedResults"-><||>|>]];

(* Named derivatives keep the primary Levi-Civita workflow unchanged. *)
Options[AddConnection]={SymbolOfCovD->Automatic};
RegisterTheory["Connection",key_String,source_Symbol,opts___Rule] := Module[{a=Association[opts],spec},
 If[!CovDQ[source] || Complement[Keys[a],{SymbolOfCovD}]=!={},Return[failure["Connection","Register an existing xAct covariant derivative; only SymbolOfCovD may override presentation here."]]];
 spec=<|"Head"->source,"SymbolOfCovD"->Lookup[a,SymbolOfCovD,SymbolOfCovD[source]]|>;
 $Theory["Connections"]=Join[Lookup[$Theory,"Connections",<||>],<|key->spec|>];$Theory
];
connectionGeometry[cd_] := Module[{names={"Christoffel","Torsion","Riemann","Ricci"}},
 If[MetricOfCovD[cd]=!=Null,names=Join[names,{"RicciScalar","Einstein","Weyl","TFRicci","Kretschmann"}]];
 AssociationThread[names,(GiveSymbol[Symbol["xAct`xTensor`"<>#],cd]& /@ names)]
];
ConnectionOf[tag_String,key_:Automatic] := Module[{b=background[tag],a},If[FailureQ[b],Return[b]];
 If[key===Automatic || key==="Primary",Return[getter[tag,"CovD"]]];
 a=Lookup[Lookup[b,"Connections",<||>],key,Missing[]];
 If[AssociationQ[a],a["Head"],failure["ConnectionKey","No connection has this name."]]
];
ConnectionsOf[tag_String] := Module[{b=background[tag]},If[FailureQ[b],b,Map[#["Head"]&,Lookup[b,"Connections",<||>]]]];
AddConnection[tag_String,key_String,source_Symbol,OptionsPattern[]] := Module[
 {b=background[tag],cd,marker,from,geo,oldgeo,r,all,rec,extra,token},
 If[FailureQ[b],Return[b]];
 If[AnyTrue[Values@Lookup[b,"Connections",<||>],Lookup[#,"OldHead",None]===source&],Return[failure["ConnectionSource","This source connection is already represented in the background."]]];
 If[key==="Primary" || KeyExistsQ[Lookup[b,"Connections",<||>],key] || KeyExistsQ[managedObjects[b],key],Return[failure["ConnectionKey","Choose a new connection name."]]];
 If[!CovDQ[source] || ManifoldOfCovD[source]=!=b["SourceManifold"] ||
    VBundlesOfCovD[source]=!={b["SourceBundle"]} || ExtendedFrom[source]=!=Null || WeightedWithBasis[source]=!=Null ||
    DependenciesOfCovD[source]=!={b["SourceManifold"]},Return[failure["ConnectionScope","Only ordinary covariant derivatives on the source tangent bundle, without extension or weighted-basis dependencies, are currently copied."]]];
 from=MetricOfCovD[source];
 If[from=!=Null && from=!=b["Theory"]["Metric"],Return[failure["ConnectionMetric","The associated metric must be the registered theory metric."]]];
 marker=Replace[OptionValue[SymbolOfCovD],Automatic:>SymbolOfCovD[source]];
 If[!MatchQ[marker,{_String,_String}],Return[failure["ConnectionSymbol","Supply a pair of display strings."]]];
 token=ToString[++$BackgroundCounter];cd=Symbol[b["Context"]<>safeName[key]<>safeName[tag]<>token];installCovDNames[cd,b["Context"]];
 r=guard[With[{cc=cd,ii=First[b["Indices"]],mm=b["Manifold"],sy=marker,tor=TorsionQ[source],cu=CurvatureQ[source],fm=If[from===Null,Null,b["Metric"]],cr=(CurvatureRelations[source]=!={})},
   DefCovD[cc[-ii],{},SymbolOfCovD->sy,Torsion->tor,Curvature->cu,FromMetric->fm,CurvatureRelations->cr]]];
 If[r===$Failed || !CovDQ[cd],If[CovDQ[cd],guard[UndefCovD[cd]]];Return[failure["ConnectionCreation","xAct could not copy the connection."]]];
 geo=connectionGeometry[cd];oldgeo=connectionGeometry[source];
 KeyValueMap[Function[{name,head},If[xTensorQ[head],With[{hh=head,pr=InferFieldPrintAs[oldgeo[name]]},PrintAs[hh]^=pr];setBareBoxes[head,SymbolName[head]]]],geo];
 setBareBoxes[cd,SymbolName[cd]];
 rec=<|"Head"->cd,"OldHead"->source,"Geometry"->geo,"Torsion"->TorsionQ[cd],"Curvature"->CurvatureQ[cd],"Metric"->MetricOfCovD[cd],"SymbolOfCovD"->marker|>;
 all=Join[Lookup[b,"Connections",<||>],<|key->rec|>];
 put[tag,<|"Connections"->all,"HeadRules"->Join[b["HeadRules"],{source->cd},Thread[Values[oldgeo]->Values[geo]]]|>];invalidateResults[tag];rec
];
connectionGetter[tag_,key_,property_] := Module[{cd=ConnectionOf[tag,key],g},If[FailureQ[cd],Return[cd]];
 g=connectionGeometry[cd];Lookup[g,property,failure["NonmetricCurvature","This curvature object is not defined for the selected connection."]]
];
RiemannOf[tag_String,key_String] := connectionGetter[tag,key,"Riemann"];
RicciOf[tag_String,key_String] := connectionGetter[tag,key,"Ricci"];
RicciScalarOf[tag_String,key_String] := connectionGetter[tag,key,"RicciScalar"];
EinsteinOf[tag_String,key_String] := connectionGetter[tag,key,"Einstein"];
WeylOf[tag_String,key_String] := connectionGetter[tag,key,"Weyl"];
ChristoffelOf[tag_String,key_String] := connectionGetter[tag,key,"Christoffel"];
TorsionOf[tag_String,key_:"Primary"] := connectionGetter[tag,key,"Torsion"];
ConnectionDifference[tag_String,key1_String,key2_String] := Module[{b=background[tag],c1,c2,ii},If[FailureQ[b],Return[b]];
 c1=ConnectionOf[tag,key1];c2=ConnectionOf[tag,key2];If[FailureQ[c1]||FailureQ[c2],Return[failure["ConnectionKey","Select two existing connections."]]];
 ii=indicesFor[b,3];Christoffel[c1,c2][ii[[1]],-ii[[2]],-ii[[3]]]
];
connectionHeads[b_] := DeleteDuplicates@DeleteMissing@Join[Lookup[b,{"CovD"}],Lookup[Values@Lookup[b,"Connections",<||>],"Head",{}]];
relativeHeads[b_] := Module[{allowed=Join[connectionHeads[b],{PD},If[KeyExistsQ[b,"Chart"]&&ChartQ[b["Chart"]],{PDOfBasis[b["Chart"]]},{}]]},
 First /@ Select[xAct`xTensor`Private`$Christoffels,Function[r,AnyTrue[connectionHeads[b],MemberQ[r[[2]],#]&] && AllTrue[Rest[r[[2]]],MemberQ[allowed,#]&]]]
];

RegisterTheory[args___] := failure["Registration", "Unsupported registration arguments."];

End[];
EndPackage[];

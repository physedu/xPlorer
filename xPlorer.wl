(* ::Package:: *)

(* Copyright (C) 2026 Eduardo Sanz-Romero (PhysEdu)
   SPDX-License-Identifier: GPL-3.0-or-later
   See LICENSE for the complete license text. *)

(* xPert installs its own output function when first loaded. Preserve the session printer. *)
Block[{$PrePrint}, BeginPackage["xPlorer`", {"xAct`xTensor`", "xAct`xPert`", "xAct`xCoba`"}]];

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

CreateBackground::usage = "CreateBackground[tag] creates a background from $Theory. Use CreateBackground[tag, Indices -> Automatic] to reuse theory indices or CreateBackground[tag, Indices -> {...}] to choose a background-specific index list. Free suffixed names in the calling context refer directly to the created objects, indices and registered expressions. Use SymbolSuffix for the symbol names, PrintAs for the metric label and MetricSignature for its signature.";
PortExpression::usage = "PortExpression[tag, expr] ports an abstract expression expr to the background tag.";
PrettyExp::usage = "PrettyExp[tag][expr] rewrites a background expression to the original abstract notation for display only.";
AddRules::usage = "AddRules[tag, rules] adds specialization rules to the background tag.";
ClearRules::usage = "ClearRules[tag] removes specialization rules from the background tag.";
ShowRules::usage = "ShowRules[tag] returns active rules in order. ShowRules[tag, \"Numbered\"] pairs them with their one-based positions.";
ApplyRules::usage = "ApplyRules[tag, expr] applies the specialization rules stored for tag to expr.";
UseExpression::usage = "UseExpression[tag, key] ports $Theory[\"Expr\"][key] to the background tag and applies its rules.";
DefineChart::usage = "DefineChart[tag, labels] defines the primary chart. DefineChart[tag, name, labels, map] defines another chart; map supplies primary coordinates as a function of the new coordinates.";
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
ComputeOnSet::usage = "ComputeOnSet specifies geometry computed when setting a metric; defaults to the metric, inverse and determinant.";
PerturbationForm::usage = "PerturbationForm is Variation (nth derivative) or TaylorCoefficient (nth derivative divided by n!).";
ApplySpecialization::usage = "ApplySpecialization controls whether background specialization rules are applied.";
StrictComponents::usage = "StrictComponents -> True returns Failure when tensor components or covariant derivatives remain unresolved.";
ForceCompute::usage = "ForceCompute -> True forces a fresh geometry calculation.";
$XPlorerVersion::usage = "$XPlorerVersion is the xPlorer package version.";
$XPlorerVersion = "14.0.0-beta.12";

Presentation::usage = "Presentation -> <|key -> label|> overrides inherited labels when creating a background. Keys include Metric, CovD, curvature names and registered field keys.";
SetPresentation::usage = "SetPresentation[tag, fieldOrGeometry, PrintAs -> label] changes one label; the association form changes several labels of owned background objects. Automatic restores the inherited default for a key.";
PresentationOf::usage = "PresentationOf[tag] reports current labels and their defaults.";
SetXPlorerPreferences::usage = "SetXPlorerPreferences[PartialStyle -> style] sets the session output style. Label rules set defaults for future backgrounds. SetXPlorerPreferences[] resets the session preferences.";
BackgroundObject::usage = "BackgroundObject[tag, key] returns the actual field or geometry head. Full InputForm retains its context.";

DisplayExpression::usage = "DisplayExpression[tag, expr, opts] creates a reversible interpreted view. Normal returns the original expression; copying the boxes retains the mathematical expression.";
SetNotation::usage = "SetNotation[tag, association] sets background display defaults; no mathematical data changes.";
PartialStyle::usage = "PartialStyle chooses Native, MultiIndex, Fraction, Partial, Comma or Prime (one argument) for notebook output and explicit views.";
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
ConnectionOf::usage = "ConnectionOf[tag, sourceCovDOrKey] returns a copied connection; omitted key or Primary returns the metric Levi-Civita derivative.";
ConnectionsOf::usage = "ConnectionsOf[tag] lists named connection heads.";
ConnectionDifference::usage = "ConnectionDifference[tag, key1, key2] returns the native Christoffel difference tensor with background indices.";
TorsionOf::usage = "TorsionOf[tag, key] returns the selected native torsion tensor head.";

SetConnectionComponents::usage = "SetConnectionComponents[tag, key, array, ReferenceConnection -> Coordinates or Primary] assigns independent coefficients or a difference tensor. Use string reference names.";
ReferenceConnection::usage = "ReferenceConnection is Coordinates for coordinate coefficients, or Primary for a difference from the metric connection.";
ConnectionMatrixOf::usage = "ConnectionMatrixOf[tag, key] returns coefficients in order {output, derivative, input}. Use OutputChart -> name for coordinate coefficients in another chart.";
CheckConnection::usage = "CheckConnection[tag, key] computes torsion-free and metric-compatibility residuals without assuming Levi-Civita identities.";
ReplaceRules::usage = "ReplaceRules[tag, rules] replaces the active rules. ReplaceAll uses the first matching rule.";
RemoveRules::usage = "RemoveRules[tag, positions] removes distinct one-based rule positions shown by ShowRules.";
SetRuleGroup::usage = "SetRuleGroup[tag, name, rules] defines a named group; active groups are refreshed when edited.";
ShowRuleGroups::usage = "ShowRuleGroups[tag] returns named rule lists.";
ActivateRuleGroups::usage = "ActivateRuleGroups[tag, names] replaces the active rules by the groups in the specified first-match order.";
RemoveRuleGroup::usage = "RemoveRuleGroup[tag, name] removes the group and refreshes active rules when needed.";
SaveResult::usage = "SaveResult[tag, key, value] stores a result until the next managed mathematical change. Display changes retain it.";
ResultOf::usage = "ResultOf[tag, key] retrieves a saved result, or returns Failure after invalidation.";

RecreateBackground::usage = "RecreateBackground[tag, recipe] rebuilds managed inputs under an unused tag, requiring the source xAct definitions to remain alive. It is not arbitrary kernel undo.";
SymbolBase::usage = "SymbolBase -> name sets the base of a registered field head before the background suffix is appended.";
SymbolSuffix::usage = "SymbolSuffix -> \"M\" chooses a readable symbol suffix independently of the background tag.";
BackgroundExpression::usage = "BackgroundExpression[tag,key] returns the registered formula transported without specialization rules.";
OutputChart::usage = "OutputChart -> name expresses tensor components in a named chart of the same background.";
ExpressionText::usage = "ExpressionText[tag,key,format] returns InputForm replay code, TeX or a readable mathematical view for a registered formula.";
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
InferFieldPrintAs[head_] := PrintAs[head];
validLabelQ[x_] := StringQ[x] || MatchQ[x, _RowBox|_SubscriptBox|_SuperscriptBox|_SubsuperscriptBox|_StyleBox|_OverscriptBox|_UnderscriptBox|_GridBox];
resolveLabel[head_,label_] := If[validLabelQ[label],label,xAct`xTensor`Private`PrintAsString[head,label]];

FieldPrintAsFromOpts[head_, opts___Rule] := resolveLabel[head,Lookup[Association[opts], PrintAs, InferFieldPrintAs[head]]];
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

NormalizeFieldSpec[parts_List] /; MemberQ[parts,HoldPattern[SymbolBase->_]] := Module[{entry,option},
  option=Association[Cases[parts,HoldPattern[SymbolBase->_]]];
  If[!validBaseOption[option],Return[$Failed]];
  entry=NormalizeFieldSpec[DeleteCases[parts,HoldPattern[SymbolBase->_]]];
  If[!MatchQ[entry,_Rule],Return[$Failed]];
  First[entry]->Append[Last[entry],"SymbolBase"->option[SymbolBase]]
];
NormalizeFieldRules[list_List] := Module[{entries=NormalizeFieldSpec /@ list},
  If[AllTrue[entries,MatchQ[#,_Rule]&],Association[entries],failure["FieldOptions","Invalid bulk field specification."]]
];
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
  If[!validBaseOption[Association[opts]] || Complement[Keys[Association[opts]],{PrintAs,Order,SymbolBase}]=!={},Return[failure["FieldOptions","Use PrintAs, SymbolBase and perturbation Order; define supported native properties on the source xAct tensor."]]];
  key = InferFieldKey[head];
  printAs = FieldPrintAsFromOpts[head, opts];
  If[type === "MetricPert",
    order = MetricPertOrderFromOpts[opts];
    newAssoc = MakeFieldAssoc[key, type, head, <|"PrintAs" -> printAs, "SymbolBase" -> Lookup[Association[opts],SymbolBase,Automatic], "Order" -> order|>],
    newAssoc = MakeFieldAssoc[key, type, head, <|"PrintAs" -> printAs, "SymbolBase" -> Lookup[Association[opts],SymbolBase,Automatic]|>]
  ];
  If[!KeyExistsQ[$Theory, "Field"], $Theory["Field"] = newAssoc, $Theory["Field"] = MergeTheoryValue[$Theory["Field"], newAssoc]];
  $Theory
];

RegisterTheory["Field", key_String, type_String, head_, opts___Rule] /; MemberQ[{"Scalar", "Vector", "MetricPert"}, type] := Module[{newAssoc, printAs, order, ks},
  $Theory = Replace[$Theory, Except[_Association] -> <||>];
  If[!validBaseOption[Association[opts]] || Complement[Keys[Association[opts]],{PrintAs,Order,SymbolBase}]=!={},Return[failure["FieldOptions","Unsupported registration option."]]];
  ks = NameKey[Unevaluated[key]];
  printAs = FieldPrintAsFromOpts[head, opts];
  If[type === "MetricPert",
    order = MetricPertOrderFromOpts[opts];
    newAssoc = MakeFieldAssoc[ks, type, head, <|"PrintAs" -> printAs, "SymbolBase" -> Lookup[Association[opts],SymbolBase,Automatic], "Order" -> order|>],
    newAssoc = MakeFieldAssoc[ks, type, head, <|"PrintAs" -> printAs, "SymbolBase" -> Lookup[Association[opts],SymbolBase,Automatic]|>]
  ];
  If[!KeyExistsQ[$Theory, "Field"], $Theory["Field"] = newAssoc, $Theory["Field"] = MergeTheoryValue[$Theory["Field"], newAssoc]];
  $Theory
];

RegisterTheory["Field", "Tensor", head_, rank_Integer, rest___] := Module[{newAssoc, key, sym, printAs},
  $Theory = Replace[$Theory, Except[_Association] -> <||>];
  If[!validBaseOption[Association[Select[{rest},MatchQ[#,_Rule]&]]] || !AllTrue[{rest},MemberQ[{"Symmetric","Antisymmetric"},#] || MatchQ[#, (PrintAs|SymbolBase)->_]&],Return[failure["FieldOptions","Only a supported symmetry and PrintAs are accepted here."]]];
  key = InferFieldKey[head];
  sym = TensorSymmetryFromArgs[rest];
  printAs = FieldPrintAsFromOpts[head, Sequence @@ Select[{rest}, MatchQ[#, _Rule] &]];
  newAssoc = MakeFieldAssoc[key, "Tensor", head, <|"Rank" -> rank, "Symmetry" -> sym, "PrintAs" -> printAs, "SymbolBase" -> Lookup[Association[Select[{rest},MatchQ[#,_Rule]&]],SymbolBase,Automatic]|>];
  If[!KeyExistsQ[$Theory, "Field"], $Theory["Field"] = newAssoc, $Theory["Field"] = MergeTheoryValue[$Theory["Field"], newAssoc]];
  $Theory
];

RegisterTheory["Field", key_String, "Tensor", head_, rank_Integer, rest___] := Module[{newAssoc, sym, printAs, ks},
  $Theory = Replace[$Theory, Except[_Association] -> <||>];
  If[!validBaseOption[Association[Select[{rest},MatchQ[#,_Rule]&]]] || !AllTrue[{rest},MemberQ[{"Symmetric","Antisymmetric"},#] || MatchQ[#, (PrintAs|SymbolBase)->_]&],Return[failure["FieldOptions","Unsupported tensor registration option."]]];
  ks = NameKey[Unevaluated[key]];
  sym = TensorSymmetryFromArgs[rest];
  printAs = FieldPrintAsFromOpts[head, Sequence @@ Select[{rest}, MatchQ[#, _Rule] &]];
  newAssoc = MakeFieldAssoc[ks, "Tensor", head, <|"Rank" -> rank, "Symmetry" -> sym, "PrintAs" -> printAs, "SymbolBase" -> Lookup[Association[Select[{rest},MatchQ[#,_Rule]&]],SymbolBase,Automatic]|>];
  If[!KeyExistsQ[$Theory, "Field"], $Theory["Field"] = newAssoc, $Theory["Field"] = MergeTheoryValue[$Theory["Field"], newAssoc]];
  $Theory
];

RegisterTheory["Field", list_List] := Module[{newAssoc},
  $Theory = Replace[$Theory, Except[_Association] -> <||>];
  newAssoc = NormalizeFieldRules[list]; If[FailureQ[newAssoc],Return[newAssoc]];
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

Options[CreateBackground] = {Indices -> Automatic, MetricSignature -> Automatic, Presentation -> <||>, SymbolSuffix -> Automatic, PrintAs -> Automatic};
CreateBackground[tag_String, OptionsPattern[]] := Module[
  {theory = $Theory, srcg, srccd, srcm, dim, base, display, inds, ctx, m, g, cd, sig,
   specs, fields = <||>, oldgeo, geo, rules, result, parameter, make, owned, labels, defaults, suffix, perturbHead = None},
  If[KeyExistsQ[$BG, tag],
    If[!KeyExistsQ[$BG[tag],"AliasContext"],installBackgroundObjectAliases[tag,$Context]];
    Return[$BG[tag]]];
  If[!And @@ (KeyExistsQ[theory, #] & /@ {"Metric", "CovD", "Indices"}),
    Return[failure["IncompleteTheory", "Register a metric, covariant derivative and indices first."]]];
  srcg = theory["Metric"]; srccd = theory["CovD"];
  If[!MetricQ[srcg] || !CovDQ[srccd] || CovDOfMetric[srcg] =!= srccd,
    Return[failure["InvalidTheory", "The registered metric and its Levi-Civita derivative must already be defined in xAct."]]];
  If[DaggerQ[srcg] || WeightOfTensor[srcg]=!=0,Return[failure["MetricScope","Only real zero-weight metrics are currently supported."]]];
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
  suffix = Replace[OptionValue[SymbolSuffix], Automatic :> safeName[tag]];
  If[!StringQ[suffix] || suffix === "" || safeName[suffix] =!= suffix,
    Return[failure["SymbolSuffix","Choose a symbol suffix starting with a letter, followed by letters or digits."]]];
  m = Symbol[ctx <> "M" <> suffix]; g = Symbol[ctx <> SymbolName[srcg] <> suffix]; cd = Symbol[ctx <> SymbolName[srccd] <> suffix];
  labels = OptionValue[Presentation];
  If[!AssociationQ[labels], Return[failure["Presentation", "Presentation must be an association of labels."]]];
  labels = Join[$PresentationPreferences, Lookup[theory, "Presentation", <||>], labels, If[OptionValue[PrintAs] === Automatic, <||>, <|"Metric" -> OptionValue[PrintAs]|>]];
  defaults = <|"Metric" -> InferFieldPrintAs[srcg], "CovD" -> SymbolOfCovD[srccd]|>;
  parameter = Symbol[ctx <> "eps"];
  inds = freshOwnedSymbol[ctx, SymbolName[#] <> suffix] & /@ display;
  specs = Lookup[theory, "Field", <||>];
  If[!AssociationQ[specs], Return[failure["Fields", "Field must be an association."]]];
  If[Complement[Keys[labels], Join[Keys[specs], {"Metric", "CovD", "Christoffel", "Riemann", "Ricci", "RicciScalar", "Einstein", "Weyl", "TFRicci", "Kretschmann", "Epsilon", "DetMetric"}]] =!= {} ||
    !AllTrue[Normal[labels], Function[r, If[First[r] === "CovD", MatchQ[Last[r], {_String,_String}], validLabelQ[Last[r]]]]],
    Return[failure["Presentation", "Supply valid labels for known objects before creating a background."]]];
  If[Intersection[Keys[specs],{"Metric","CovD","Manifold","Chart","PerturbationParameter","Primary","Riemann","Ricci","RicciScalar","Christoffel","Einstein","Weyl","Epsilon","DetMetric","Kretschmann","TFRicci"}]=!={},
    Return[failure["ReservedFieldKey","Field keys must not shadow managed geometry or ownership keys."]]];
  If[!DuplicateFreeQ[Lookup[Values[specs],"Head",{}]],Return[failure["DuplicateField","One source field must have one registry identity in a background. Use presentation overrides for display alternatives."]]];
  If[!AllTrue[Values[specs], AssociationQ[#] && KeyExistsQ[#,"Head"] && MemberQ[{"Scalar","Vector","Tensor","MetricPert"},Lookup[#,"Type",None]] &&
      (Lookup[#,"Type"] =!= "Tensor" || (IntegerQ[Lookup[#,"Rank",-1]] && Lookup[#,"Rank",-1]>=0))&],
    Return[failure["FieldSpecification","Every field needs a supported type and nonnegative tensor rank."]]];
  make[key_, spec_] := Module[{head, new, type, rank, slots, signs, symmetry, deps, args, print, n, dagger=Real, vanish=False, frobenius=False},
    If[!AssociationQ[spec] || !And @@ (KeyExistsQ[spec, #] & /@ {"Head", "Type"}), Return[$Failed]];
    head = spec["Head"]; type = spec["Type"]; print = resolveLabel[head,Lookup[spec, "PrintAs", InferFieldPrintAs[head]]];
    new = freshOwnedSymbol[ctx, Replace[Lookup[spec,"SymbolBase",Automatic], Automatic :> safeName[key]] <> suffix];
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
        vanish=SameQ[head@@MapThread[Times,{signs,Take[If[rank<=Length[base],base,GetIndicesOfVBundle[VBundleOfMetric[srcg],rank]],rank]}],0];
        symmetry = SymmetryGroupOfTensor[head];
        deps = DependenciesOfTensor[head] /. srcm -> m;
        If[!FreeQ[deps, s_Symbol /; ManifoldQ[s] && s =!= m], Return[$Failed]];
      ];
      args = MapThread[Times, {signs, Take[If[rank <= Length[inds], inds, GetIndicesOfVBundle[TangentBundleOfManifold[m], rank]], rank]}];
      symmetry = Switch[symmetry, "Symmetric", Symmetric[Range[rank]], "Antisymmetric", Antisymmetric[Range[rank]], None, GenSet[], _, symmetry];
      With[{hh = new, aa = args, dd = deps, ss = symmetry, pr = print, dg=dagger,fb=frobenius,vn=vanish},
        DefTensor[hh @@ aa, dd, ss, PrintAs -> pr,Dagger->dg,FrobeniusQ->fb,VanishingQ->vn]];
    ];
    If[!xTensorQ[new], Return[$Failed]];
    fields[key] = <|"Type" -> type, "OldHead" -> head, "NewHead" -> new,
      "PrintAs" -> print, "Rank" -> rank, "IndexPositions" -> signs|>;
    new
  ];
  installCovDNames[cd,ctx];
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
    owned=ToString[#,InputForm]& /@ ownedObjects[<|"Manifold" -> m, "Metric" -> g, "CovD" -> cd, "Field" -> fields, "PerturbationParameter" -> parameter|>];
    result=guard[Internal`InheritedBlock[{Undef},Unprotect[Undef];
      Undef[s_Symbol /; StringStartsQ[ToString[Unevaluated[s],InputForm],"Removed["]]:=Null;
      disposeObjects[<|"Manifold" -> m, "Metric" -> g, "CovD" -> cd, "Field" -> fields, "PerturbationParameter" -> parameter|>]]];
    owned=Select[owned,registeredNameQ];
    Return[If[result===$Failed || owned=!={},failure["PartialCreation","Creation failed and cleanup was incomplete. Inspect the remaining native definitions before retrying.",<|"RemainingNames"->owned,"Context"->ctx|>],
      failure["CreateBackground", "xAct could not create every requested object; the partial background was rolled back."]]]];
  oldgeo = allGeometry[srccd, srcg]; geo = allGeometry[cd, g];
  defaults = Join[defaults, Association@KeyValueMap[(#1 -> Lookup[#2,"PrintAs",InferFieldPrintAs[#2["Head"]]] ) &, specs],
    Association@KeyValueMap[(#1 -> If[xTensorQ[#2], InferFieldPrintAs[#2], SymbolName[#2]]) &, oldgeo]];
  rules = Join[{srcg -> g, srccd -> cd}, Thread[Values[oldgeo] -> Values[geo]],
    (# ["OldHead"] -> # ["NewHead"] & /@ Values[fields]),
    (Dagger[#["OldHead"]] -> Dagger[#["NewHead"]] & /@ Select[Values[fields],xTensorQ[#["OldHead"]] && DaggerQ[#["OldHead"]]&])];
  $BG[tag] = Join[<|"Tag" -> tag, "SymbolSuffix" -> suffix, "Context" -> ctx, "PresentationDefaults" -> defaults, "PresentationOverrides" -> labels, "Theory" -> theory, "Dimension" -> dim,
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
  installExpressionAliases[tag, suffix, $Context];
  installBackgroundObjectAliases[tag,$Context];
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
  put[tag, <|"SpecializationRules" -> Join[bg["SpecializationRules"], rules],"ActiveRuleGroups"->{}|>];invalidateResults[tag];$BG[tag]];
ClearRules[tag_String] := ReplaceRules[tag,{}];
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
BackgroundExpression[tag_String,key_String] := Module[{ex = resolve[tag,key]},
  If[FailureQ[ex], ex, PortExpression[tag,ex]]
];
(* Record the exact installed definition so deletion respects user reassignment. *)
installAlias[context_,name_,HoldComplete[value_]] := Module[{full=context<>name,owned},
  If[Names[full]==={} && AnyTrue[DeleteCases[$ContextPath,context],Names[#<>name]=!={}&],Return[$Failed]];
  owned=ToExpression[full,InputForm,Function[sym,
    If[Attributes[sym] === {} && OwnValues[sym] === {} &&
       DownValues[sym] === {} && UpValues[sym] === {} && SubValues[sym] === {} &&
       NValues[sym] === {} && FormatValues[sym] === {} && DefaultValues[sym] === {} &&
       Options[sym] === {} && Messages[sym] === {},
      sym := value; OwnValues[sym], $Failed],HoldAllComplete]];
  If[owned===$Failed,$Failed,{full,owned}]
];
installExpressionAliases[tag_,suffix_,context_] := Module[{aliases=<||>,skipped={},entry},
  Do[
    entry=With[{k=key},installAlias[context,safeName[k]<>suffix,HoldComplete[BackgroundExpression[tag,k]]]];
    If[entry===$Failed,AppendTo[skipped,key],aliases[key]=entry],
    {key,Keys@Lookup[$BG[tag]["Theory"],"Expr",<||>]}];
  put[tag,<|"ExpressionAliases"->aliases,"UnavailableAliases"->skipped|>]
];
installObjectAliases[tag_,heads_List] := Module[{b=$BG[tag],aliases,skipped,name,entry},
  aliases=Lookup[b,"ObjectAliases",<||>]; skipped=Lookup[b,"UnavailableObjectAliases",{}];
  Do[
    name=SymbolName[head];
    If[!KeyExistsQ[aliases,name],
      entry=With[{target=head},installAlias[b["AliasContext"],name,HoldComplete[target]]];
      If[entry===$Failed,AppendTo[skipped,name],aliases[name]=entry;skipped=DeleteCases[skipped,name]]],
    {head,DeleteDuplicates[heads]}];
  put[tag,<|"ObjectAliases"->aliases,"UnavailableObjectAliases"->DeleteDuplicates[skipped]|>]
];
connectionAliasHeads[rec_] := Join[{rec["Head"]},Select[Values[rec["Geometry"]],xTensorQ]];
installBackgroundObjectAliases[tag_,context_] := Module[{b=$BG[tag],geometry},
  put[tag,<|"AliasContext"->context|>];
  geometry=KeyTake[b,{"Christoffel","Riemann","Ricci","RicciScalar","Einstein","Weyl","TFRicci","Kretschmann","Epsilon","DetMetric"}];
  installObjectAliases[tag,Join[Values@KeyTake[b,{"Manifold","Metric","CovD"}],b["Indices"],
    Lookup[Values[b["Field"]],"NewHead",{}],Select[Values[geometry],xTensorQ],
    Flatten[connectionAliasHeads /@ Values@Lookup[b,"Connections",<||>]]]]
];
releaseAliases[entries_Association] := Scan[Function[entry,
  With[{owned=entry[[2]]},
    ToExpression[First[entry],InputForm,Function[sym,
      If[OwnValues[sym] === owned, OwnValues[sym]={}],HoldAllComplete]]]],Values[entries]];
ExpressionText[tag_String,key_String,format_String:"InputForm"] := Module[{expr=BackgroundExpression[tag,key]},
  If[FailureQ[expr],Return[expr]];
  Switch[format,
   "InputForm", "BackgroundExpression["<>ToString[tag,InputForm]<>", "<>ToString[key,InputForm]<>"]",
   "TeX", ToString[TeXForm[expr]],
   "TexAct", If[!MemberQ[$Packages,"xAct`TexAct`"],Quiet[Needs["xAct`TexAct`"]]];
     If[MemberQ[$Packages,"xAct`TexAct`"],xAct`TexAct`TexPrint[expr],
       failure["TexAct","Install TexAct to use this export format."]],
   "View", DisplayExpression[tag,expr],
   _,failure["ExportFormat","Choose InputForm, TeX, TexAct, or View."]]
];
ShowRules[tag_String,"Numbered"] := Module[{rules=ShowRules[tag]},
  If[FailureQ[rules],rules,MapIndexed[{First[#2],#1}&,rules]]];
UseExpression[tag_String, key_String] := Module[{ex = resolve[tag, key]}, If[FailureQ[ex], Return[ex]];
  ex = PortExpression[tag, ex]; If[FailureQ[ex], ex, ApplyRules[tag, ex]]];
UseExpression[tag_String, key_Symbol] := UseExpression[tag, SymbolName[Unevaluated[key]]];

DefineChart[tag_String, names_List] := Module[{b = background[tag], chart, coords, result},
  If[FailureQ[b], Return[b]];
  If[Length[names] =!= b["Dimension"] || !VectorQ[names, StringQ] || !DuplicateFreeQ[names],
    Return[failure["Coordinates", "Supply distinct coordinate labels matching the dimension."]]];
  If[KeyExistsQ[b, "Chart"] && ChartQ[b["Chart"]],
    Return[If[Lookup[b, "CoordinateLabels", {}] === names, b, failure["ChartExists", "The primary chart already exists. Use DefineChart[tag,name,labels,map] to add an output chart."]]]];
  chart = Symbol[b["Context"] <> "chart"];
  coords = Table[Symbol[b["Context"] <> "coord" <> ToString[n]], {n, Length[names]}];
  result = guard[With[{ch = chart, mm = b["Manifold"], nums = Range[0, b["Dimension"] - 1], vals = Through[coords[]]},
    DefChart[ch, mm, nums, vals]]];
  If[result === $Failed || !ChartQ[chart], Return[failure["DefineChart", "xCoba could not define the chart."]]];
  MapThread[Function[{s, lab}, With[{ss = s, ll = lab}, PrintAs[ss] ^= ll]], {coords, names}];
  put[tag, <|"Chart" -> chart, "Basis" -> chart, "Coordinates" -> coords, "CoordinateLabels" -> names|>]
];
(* Secondary coordinate charts are native xCoba charts on the owned manifold.
   Maps give the primary coordinates as functions of the target coordinates. *)
DefineChart[tag_String,name_String,labels_List,map_Function] := Module[
  {b=background[tag],charts,coords,values,chart,jac,det,n,created,record},
  If[FailureQ[b],Return[b]];
  If[!KeyExistsQ[b,"Chart"],Return[failure["NoChart","Define the primary chart first."]]];
  charts=Lookup[b,"AdditionalCharts",<||>]; n=b["Dimension"];
  If[name==="Primary" || KeyExistsQ[charts,name],Return[failure["ChartExists","Choose an unused chart name."]]];
  If[Length[labels]=!=n || !VectorQ[labels,StringQ] || !DuplicateFreeQ[labels],
    Return[failure["Coordinates","Supply one distinct label per dimension."]]];
  chart=freshOwnedSymbol[b["Context"],"chart"<>safeName[name]];
  coords=Table[freshOwnedSymbol[b["Context"],"coord"<>safeName[name]<>ToString[i]],{i,n}];
  With[{ch=chart,mm=b["Manifold"],nums=Range[0,n-1],xs=Through[coords[]]},
    created=guard[DefChart[ch,mm,nums,xs]]];
  If[created===$Failed || !ChartQ[chart],Return[failure["Chart","xCoba could not define this chart."]]];
  MapThread[Function[{sym,label},With[{ss=sym,ll=label},PrintAs[ss]^=ll]],{coords,labels}];
  values=guard[map@@Through[coords[]]];
  If[!VectorQ[values] || Length[values]=!=n,UndefChart[chart];Return[failure["ChartMap","Return one primary coordinate per dimension."]]];
  jac=Outer[D,values,Through[coords[]]];det=Simplify[Det[jac]];
  If[TrueQ[det==0],UndefChart[chart];Return[failure["ChartMap","The chart Jacobian is identically singular."]]];
  record=<|"Chart"->chart,"Coordinates"->coords,"Labels"->labels,"Map"->map,
    "Values"->values,"Jacobian"->jac|>;
  put[tag,<|"AdditionalCharts"->Append[charts,name->record]|>]; chart
];
chartRecord[b_Failure,_] := b;
chartRecord[b_Association,name_] := Lookup[Lookup[b,"AdditionalCharts",<||>],name,
  failure["UnknownChart","Choose a defined output chart."]];
ChartOf[tag_String,"Primary"] := ChartOf[tag];
CoordinatesOf[tag_String,"Primary"] := CoordinatesOf[tag];
ChartOf[tag_String,name_String] := Module[{rec=chartRecord[ShowBackground[tag],name]},If[FailureQ[rec],rec,rec["Chart"]]];
CoordinatesOf[tag_String,name_String] := Module[{rec=chartRecord[ShowBackground[tag],name]},If[FailureQ[rec],rec,rec["Coordinates"]]];
chartPullback[arr_,b_,rec_,indices_] := Module[{jac=rec["Jacobian"],inv,result,axis,transform},
  result=arr/.Thread[coordinateValues[b]->rec["Values"]];
  If[AnyTrue[indices,UpIndexQ],inv=Simplify[Inverse[jac]]];
  Do[transform=If[UpIndexQ[indices[[axis]]],inv,Transpose[jac]];
    result=Map[Function[slice,Dot[transform,slice]],result,{axis-1}],
    {axis,Length[indices]}];result
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
  $BG[tag]=KeyDrop[$BG[tag],"GeometryPolicy"];
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
  result = replayConnections[tag];If[FailureQ[result],Return[result]];invalidateResults[tag];
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
    replayFields[tag];replayConnections[tag]; b = $BG[tag]];
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
  invalidateResults[tag];rec
];

geometryNeeded[b_, expr_] := Module[{keys},
  keys = Select[Keys[$geometryTargets], # =!= "Metric" && !FreeQ[expr, b[#]] &];
  If[!FreeQ[expr, b["CovD"]] || AnyTrue[relativeHeads[b],!FreeQ[expr,#]&], AppendTo[keys, "Christoffel"]];
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
Options[ToComponents] = {OutputChart -> Automatic, FreeIndices -> Automatic, Components -> All, Assumptions -> Automatic,
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
  ex=ex/.Scalar[inside_]:>traceValues[inside];
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
  {b = background[tag], ex, inds, actual, basisinds, result, geometry, arr, selected, simp = OptionValue[Simplification], ass, unresolved, rec=None, chart=OptionValue[OutputChart], subset},
  If[FailureQ[b], Return[b]];
  If[!KeyExistsQ[b, "MetricMatrix"], Return[failure["NoMetricComponents", "Assign metric components before evaluating components."]]];
  If[!MemberQ[{Automatic,"Primary"},chart],rec=chartRecord[b,chart];If[FailureQ[rec],Return[rec]]];
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
  ex=expandConnections[tag,ex];If[FailureQ[ex],Return[ex]];
  ex = guard[ChangeCovD[SeparateMetric[][ex], b["CovD"], PDOfBasis[b["Chart"]]]];
  If[ex === $Failed, Return[failure["Derivatives", "The covariant derivative could not be expanded."]]];
  ex = guard[coordinateIndexify[ex, b]];
  If[ex === $Failed, Return[failure["BasisConversion", "The expression could not be converted to the chart basis."]]];
  result = prepareFieldConfigurations[tag, ex]; If[FailureQ[result], Return[result]];
  basisinds = If[UpIndexQ[#], {#, b["Basis"]}, {#, -b["Basis"]}] & /@ inds;
  selected = OptionValue[Components];
  subset=selected;
  If[rec=!=None && selected=!=All,
    If[!ListQ[selected] || !AllTrue[selected,ListQ[#] && Length[#]===Length[inds] && VectorQ[#,IntegerQ[#]&&0<=#<b["Dimension"]&]&],
      Return[failure["Components","Select zero-based coordinate-number tuples."]]];
    selected=All];
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
  If[rec=!=None,
    If[!FreeQ[arr,h_[___] /; xTensorQ[h] && !MemberQ[b["Coordinates"],h]],
      Return[failure["ChartComponents","Supply field components before changing charts."]]];
    arr=chartPullback[arr,b,rec,inds];
    ass=ass/.Thread[coordinateValues[b]->rec["Values"]];
    If[subset=!=All,arr=If[inds==={},ConstantArray[arr,Length[subset]],Extract[arr,# + 1]& /@ subset]]];
  arr = If[MemberQ[{Simplify, FullSimplify}, simp], simp[arr, Assumptions -> ass], simp[arr]];
  unresolved = DeleteDuplicates@Cases[arr, x_ /; (MatchQ[Unevaluated[x], h_[___]] && xTensorQ[Head[x]] && !MemberQ[Join[Lookup[b,"Coordinates",{}],If[AssociationQ[rec],rec["Coordinates"],{}]],Head[x]]) || MatchQ[Unevaluated[x], _?CovDQ[_][___]] || MatchQ[Unevaluated[x], _Perturbation], {0, Infinity}];
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
  roots = DeleteMissing@Join[Lookup[b, {"Manifold", "Metric", "CovD", "Chart", "PerturbationParameter"}], Lookup[Values[b["Field"]], "NewHead", {}],connectionHeads[b],Lookup[Values@Lookup[b,"AdditionalCharts",<||>],"Chart",{}],relativeHeads[b]];
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
  Scan[If[ChartQ[#],UndefChart[#]]&,Lookup[Values@Lookup[b,"AdditionalCharts",<||>],"Chart",{}]];
  If[ManifoldQ[b["Manifold"]], UndefManifold[b["Manifold"]]];
  If[ParameterQ[parameter], UndefParameter[parameter]];
  Null
];
DeleteBackground[tag_String] := Module[{b = background[tag], result, owned, external, names, remaining},
  If[FailureQ[b], Return[b]];
  owned = ownedObjects[b];
  names=ToString[#,InputForm]& /@ owned;
  external = Union[Complement[DeleteDuplicates@Flatten[VisitorsOf /@ owned], owned],externalRelativeHeads[b]];
  If[external =!= {}, Return[failure["ExternalDependents", "External xAct objects depend on this background; undefine them explicitly first.", <|"Objects" -> external|>]]];
  clearGeometry[tag];
  result = guard[Internal`InheritedBlock[{Undef},
    Unprotect[Undef];
    Undef[s_Symbol /; StringStartsQ[ToString[Unevaluated[s], InputForm], "Removed["]] := Null;
    disposeObjects[b]
  ]];
  If[result === $Failed, Return[failure["DeleteBackground", "xAct could not undefine all owned objects; the registry entry was retained."]]];
  remaining=Select[names,registeredNameQ];
  If[remaining=!={},Return[failure["PartialDeletion","Some owned definitions remain; the registry was retained.",<|"RemainingNames"->remaining|>]]];
  releaseAliases[Lookup[b,"ExpressionAliases",<||>]];
  releaseAliases[Lookup[b,"ObjectAliases",<||>]];
  KeyDropFrom[$BG, tag]; updatePrintHook[]; Null
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
validBaseOption[options_] := With[{base=Lookup[options,SymbolBase,Automatic]},base===Automatic || (StringQ[base] && base=!= "" && safeName[base]===base)];
freshOwnedSymbol[context_, base_] := Module[{name = context <> base, n = 1},
  While[Names[name] =!= {}, name = context <> base <> ToString[++n]];
  Symbol[name]
];
installCovDNames[cd_, ctx_] := With[{cc = cd, context = ctx},
  cc /: GiveSymbol[kind_Symbol, cc] := Symbol[context <> SymbolName[kind] <> SymbolName[cc]];
  cc /: GiveSymbol[Christoffel, cc, other_Symbol] := Symbol[context <> "Christoffel" <> SymbolName[cc] <> SymbolName[other]];
  cc /: GiveSymbol[Christoffel, other_Symbol, cc] := Symbol[context <> "Christoffel" <> SymbolName[other] <> SymbolName[cc]];
];
setBareBoxes[head_Symbol, label_String] := With[{hh = head, ll = label},
  hh /: MakeBoxes[hh, StandardForm] := InterpretationBox[ll, hh];
  hh /: MakeBoxes[hh, TraditionalForm] := InterpretationBox[ll, hh];
];
SetXPlorerPreferences[assoc_Association] := Module[{n = KeyTake[assoc,Keys[$notationDefaults]], p = KeyDrop[assoc,Keys[$notationDefaults]]},
  If[!validNotation[n],Return[failure["Notation","Unknown derivative style."]]];
  If[AllTrue[Values[p], validLabelQ[#] || MatchQ[#, {_String,_String}] &],
  $PresentationPreferences = p; $sessionNotation = n; updatePrintHook[]; assoc, failure["Presentation", "Defaults must be strings or connection marker pairs."]]];
RegisterTheory["Presentation", assoc_Association] := ($Theory["Presentation"] = assoc; $Theory);
BackgroundObject[tag_String, key_String] := Module[{b = background[tag]},
  If[FailureQ[b], Return[b]];
  If[KeyExistsQ[b["Field"], key], b["Field"][key]["NewHead"], getter[tag,key]]
];
SetPresentation[tag_String, assoc_Association] := Module[{b = background[tag], unknown, current, effective, objects, val,source,kind},
  If[FailureQ[b], Return[b]];
  unknown = Complement[Keys[assoc], Keys[b["PresentationDefaults"]]];
  If[unknown =!= {} || !AllTrue[Normal[assoc], Function[r, Last[r] === Automatic || If[First[r] === "CovD", MatchQ[Last[r], {_String,_String}], validLabelQ[Last[r]]]]],
    Return[failure["Presentation", "Use known object keys and string labels; CovD takes two strings.", <|"Keys" -> unknown|>]]];
  current = Join[b["PresentationOverrides"], assoc];
  current = Select[current, # =!= Automatic &];
  effective = Join[b["PresentationDefaults"], current];
  objects = Join[AssociationThread[Keys[b["Field"]], Lookup[Values[b["Field"]], "NewHead"]], KeyTake[b, Keys[b["PresentationDefaults"]]]];
  With[{cc=b["CovD"],vv=effective["CovD"]},If[CovDQ[cc],SymbolOfCovD[cc]^=vv]];
  KeyValueMap[Function[{key,head},
    val = effective[key];
    If[MemberQ[{"Christoffel","Riemann","Ricci","RicciScalar","Einstein","Weyl","TFRicci","Kretschmann"},key] && !KeyExistsQ[current,key] && KeyExistsQ[b["Theory"],"CovD"],
      source=b["Theory"]["CovD"];kind=Symbol["xAct`xTensor`"<>key];
      If[SameQ[val,GiveOutputString[kind,source]],val=GiveOutputString[kind,b["CovD"]]]
    ];
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
If[!AssociationQ[$sessionNotation],$sessionNotation=<||>];
(* PrePrint runs only when a notebook output is rendered. Keep assignments and Out raw. *)
hasGeneratedIndexQ[e_] := !FreeQ[e, i_Symbol /; StringContainsQ[SymbolName[i],"$"] && AIndexQ[i]];
(* Keep each formula in a displayed collection independent when choosing dummy names. *)
automaticView[e_List] := automaticView /@ e;
automaticView[Row[items_List, rest___]] := Row[automaticView /@ items, rest];
automaticView[Grid[items_List, rest___]] := Grid[automaticView[items], rest];
automaticView[e_] := Module[{owners,style},
  If[!FreeQ[e,_expressionView] || !MatchQ[e,_Plus|_Times|_Power|_Equal|_Scalar|_?xTensorQ[___]|_?CovDQ[_][_]|Derivative[__][_][__]],Return[e]];
  If[!FreeQ[e,Derivative|_?CovDQ],
    owners=Select[Keys[$BG],Function[t, !FreeQ[e,s_Symbol /; Context[s] === $BG[t]["Context"]]]];
    If[Length[owners]===1,
      style=Join[$notationDefaults,$sessionNotation,Lookup[$BG[First[owners]],"Notation",<||>]];
      If[style =!= $notationDefaults,Return[expressionView[e,style,First[owners]]]]]];
  If[hasGeneratedIndexQ[e],expressionView[e,$notationDefaults,None],e]
];
notebookPrint[e_] := If[$previousPrint === ScreenDollarIndices,
  With[{view=automaticView[e]},If[view === e,$previousPrint[e],view]],
  automaticView[$previousPrint[e]]
];
updatePrintHook[] := If[$PrePrint =!= notebookPrint,
  $previousPrint=If[ValueQ[$PrePrint],$PrePrint,Identity];
  $PrePrint=notebookPrint
];
validNotation[a_] := AssociationQ[a] && Complement[Keys[a], Keys[$notationDefaults]] === {} &&
  MemberQ[{"Native","MultiIndex","Fraction","Partial","Comma","Prime"}, Lookup[a,"PartialStyle","Native"]] &&
  MemberQ[{"Native","Prefix","Postfix"}, Lookup[a,"CovariantStyle","Native"]] &&
  MemberQ[{True,False}, Lookup[a,"ShowBackgroundLabel",False]];
SetNotation[tag_String, a_Association] := Module[{b=background[tag],overrides}, If[FailureQ[b],Return[b]];
  overrides=Select[Join[Lookup[b,"Notation",<||>],a],#=!=Automatic&];
  If[Complement[Keys[a],Keys[$notationDefaults]]=!={} || !validNotation[overrides],Return[failure["Notation","Unknown notation setting."]]];
  put[tag,<|"Notation" -> overrides|>]; updatePrintHook[]; $BG[tag]["Notation"]];
Options[DisplayExpression] = {PartialStyle -> Automatic, CovariantStyle -> Automatic, ShowBackgroundLabel -> Automatic};
DisplayExpression[tag_String, expr_, OptionsPattern[]] := Module[{b=background[tag],a,local},
  If[FailureQ[b],Return[b]];
  local=Select[<|"PartialStyle"->OptionValue[PartialStyle],"CovariantStyle"->OptionValue[CovariantStyle],"ShowBackgroundLabel"->OptionValue[ShowBackgroundLabel]|>,# =!= Automatic &];
  a=Join[$notationDefaults,$sessionNotation,Lookup[b,"Notation",<||>],local];
  If[!validNotation[a],Return[failure["Notation","Unknown notation setting."]]];
  expressionView[expr,a,tag]
];
expressionView /: Normal[expressionView[e_,_,_]] := e;
expressionView /: MakeBoxes[expressionView[e_,a_,tag_], StandardForm] :=
  With[{body=notationBoxes[If[hasGeneratedIndexQ[e],ScreenDollarIndices[e],e],a]},
    If[TrueQ[a["ShowBackgroundLabel"]],
      InterpretationBox[RowBox[{StyleBox[tag,FontWeight->Bold],": ",body}],e],
      InterpretationBox[body,e]]
  ];
expressionView /: MakeBoxes[expressionView[e_,a_,tag_], TraditionalForm] := MakeBoxes[expressionView[e,a,tag],StandardForm];
nativeBoxes[e_] := With[{ex=e},MakeBoxes[ex,StandardForm]];
notationBoxes[e_,a_] := Module[{orders,args,fn,n,terms,den,body,mark,ix,h=Head[e],items},
  If[(a["PartialStyle"]==="Native" || FreeQ[e,Derivative]) && (a["CovariantStyle"]==="Native" || FreeQ[e,_?CovDQ]),Return[nativeBoxes[e]]];
  If[MatchQ[e,Derivative[__][_][__]] && a["PartialStyle"]=!="Native",
    orders=List@@Head[Head[e]]; args=List@@e; fn=Head[e][[1]]; n=Total[orders];
    If[a["PartialStyle"]==="Prime" && Length[args]=!=1,Return[nativeBoxes[e]]];
    body=RowBox[{nativeBoxes[fn],"[",RowBox[Riffle[nativeBoxes /@ args,","]],"]"}];
    Return[Switch[a["PartialStyle"],
      "MultiIndex",RowBox[{SuperscriptBox[nativeBoxes[fn],RowBox[{"(",RowBox[Riffle[ToString /@ orders,","]],")"}]],"[",RowBox[Riffle[nativeBoxes /@ args,","]],"]"}],
      "Comma",SubscriptBox[body,RowBox[Prepend[Flatten[MapThread[ConstantArray[nativeBoxes[#1],#2]&,{args,orders}],1],","]]],
      "Prime",RowBox[{SuperscriptBox[nativeBoxes[fn],StringRepeat["'",n]],"[",nativeBoxes[First[args]],"]"}],
      _,terms=MapThread[If[#2===0,Nothing,RowBox[{"\[PartialD]",If[#2===1,nativeBoxes[#1],SuperscriptBox[nativeBoxes[#1],ToString[#2]]]}]]&,{args,orders}];
      den=RowBox[Riffle[terms," "]];
      If[a["PartialStyle"]==="Fraction",FractionBox[RowBox[{If[n===1,"\[PartialD]",SuperscriptBox["\[PartialD]",ToString[n]]],body}],den],
        RowBox[{RowBox[Riffle[MapThread[If[#2===0,Nothing,SubscriptBox[If[#2===1,"\[PartialD]",SuperscriptBox["\[PartialD]",ToString[#2]]],nativeBoxes[#1]]]&,{args,orders}]," "]]," ",body}]]]]
  ];
  If[MatchQ[e,_?CovDQ[_][_]] && a["CovariantStyle"]=!="Native",
    fn=Head[Head[e]]; ix=First[Head[e]]; body=notationBoxes[First[e],a];
    mark=First[SymbolOfCovD[fn]];
    Return[If[a["CovariantStyle"]==="Postfix",
      If[UpIndexQ[ix],SuperscriptBox[RowBox[{"(",body,")"}],RowBox[{mark,IndexForm[UpIndex[ix]]}]],SubscriptBox[RowBox[{"(",body,")"}],RowBox[{mark,IndexForm[UpIndex[ix]]}]]],
      RowBox[{If[UpIndexQ[ix],SuperscriptBox[Last[SymbolOfCovD[fn]],IndexForm[ix]],SubscriptBox[Last[SymbolOfCovD[fn]],IndexForm[UpIndex[ix]]]],"(",body,")"}]]]
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
  replayFields[tag];replayConnections[tag];invalidateResults[tag];Null
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
registeredNameQ[name_String] := Names[name] =!= {} && TrueQ[ToExpression[name,InputForm,objectRegisteredQ]];
objectRegisteredQ[s_] := TrueQ[xTensorQ[s] || CovDQ[s] || ChartQ[s] || MetricQ[s] || ManifoldQ[s] || ParameterQ[s]];
servantClosure[roots_] := FixedPoint[DeleteDuplicates@Join[#,Flatten[ServantsOf /@ #]]&,roots];
visitorClosure[roots_] := FixedPoint[DeleteDuplicates@Join[#,Flatten[VisitorsOf /@ #]]&,roots];
managedObjects[b_] := Join[KeyTake[b,{"Metric","CovD","Chart","Manifold","PerturbationParameter"}],
  AssociationThread[Keys[b["Field"]],Lookup[Values[b["Field"]],"NewHead"]],
  Map[#["Head"]&,Lookup[b,"Connections",<||>]]];
Options[DeletionPlan]={Cascade->False};
DeletionPlan[tag_String,key_String:"Background",OptionsPattern[]] := Module[
 {b=background[tag],obj,roots,owned,remove,external,visitors,fields,exprs,ruleHits,uses,blockers,order,geometry,groupHits,sections,dependentHeads},
 If[FailureQ[b],Return[b]];
 If[MemberQ[{"Background","Manifold"},key],
  owned=ownedObjects[b];external=Union[Complement[visitorClosure[owned],owned],externalRelativeHeads[b]];
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
 If[key==="Chart",roots=Union[roots,servantClosure[Lookup[Values@Lookup[b,"AdditionalCharts",<||>],"Chart",{}]]]];
 roots=Union[roots,Select[relativeHeads[b],Function[h,AnyTrue[roots,!FreeQ[TensorID[h],#]&]]]];
 visitors=visitorClosure[roots];
 external=Union[Complement[visitors,owned],Select[externalRelativeHeads[b],Function[h,AnyTrue[roots,!FreeQ[TensorID[h],#]&]]]];
 remove=If[TrueQ[OptionValue[Cascade]],Intersection[visitors,owned],roots];
 (* The manifold is always an owner/host, never an implicit cascade target. *)
 If[MemberQ[remove,b["Manifold"]],Return[failure["CascadeScope","Use explicit background deletion for a manifold cascade."]]];
 dependentHeads=Join[remove,First /@ Select[b["HeadRules"],MemberQ[remove,Last[#]]&]];
 exprs=Keys@Select[Lookup[b["Theory"],"Expr",<||>],Function[e,AnyTrue[dependentHeads,!FreeQ[e,#]&]]];
 sections=Keys@Select[KeyDrop[b["Theory"],{"Field","Expr","Connections","Metric","CovD","Indices","Presentation"}],Function[e,AnyTrue[dependentHeads,!FreeQ[e,#]&]]];
 groupHits=Keys@Select[Lookup[b,"RuleGroups",<||>],Function[r,AnyTrue[dependentHeads,!FreeQ[r,#]&]]];
 ruleHits=Select[Range[Length[b["SpecializationRules"]]],Function[n,AnyTrue[dependentHeads,!FreeQ[b["SpecializationRules"][[n]],#]&]]];
 blockers=Join[external,If[TrueQ[OptionValue[Cascade]],{},Complement[visitors,remove]],If[TrueQ[OptionValue[Cascade]],{},exprs],If[TrueQ[OptionValue[Cascade]],{},Join[ruleHits,sections,groupHits]]];
 order=Select[Reverse@Values[b["Field"]],MemberQ[remove,#["NewHead"]]&];order=Lookup[order,"NewHead",{}];
 order=DeleteDuplicates@Join[order,Select[remove,xTensorQ[#] && !MetricQ[#] && MasterOf[#]=!=obj&],
   Select[remove,CovDQ[#] && #=!=b["CovD"]&],If[MemberQ[remove,b["Metric"]],{b["Metric"]},{}],
   If[MemberQ[remove,Lookup[b,"Chart",None]],Join[Lookup[Values@Lookup[b,"AdditionalCharts",<||>],"Chart",{}],{b["Chart"]}],{}],Select[remove,ParameterQ],{obj}];
 order=Select[order,!MemberQ[remove,MasterOf[#]]&];
 <|"Background"->tag,"Key"->key,"Objects"->remove,"ExternalBlockers"->external,"Blockers"->blockers,
  "RegisteredExpressions"->exprs,"RegisteredSections"->sections,"RuleGroupsAffected"->groupHits,"RulePositions"->ruleHits,"Order"->order,"CanDelete"->(blockers==={})|>
];
undefOwned[o_] := Module[{master=MasterOf[o]},
 If[objectRegisteredQ[o] && master=!=Null && objectRegisteredQ[master],
   With[{mm=master,ss=o},ServantsOf[mm]^=DeleteCases[ServantsOf[mm],ss];MasterOf[ss]^=Null]];
 Which[ChartQ[o],UndefChart[o],MetricQ[o],UndefMetric[o],CovDQ[o],UndefCovD[o],xTensorQ[o],DeleteTensorValues[o];UndefTensor[o],ParameterQ[o],UndefParameter[o],True,Null]
];
Options[DeleteBackgroundObject]={Cascade->False};
DeleteBackgroundObject[tag_String,key_String,OptionsPattern[]] := Module[{b=background[tag],plan,removed,names,aliasNames,r,newb,deadKeys,exprs,remaining},
 If[FailureQ[b],Return[b]];
 plan=DeletionPlan[tag,key,Cascade->OptionValue[Cascade]];If[FailureQ[plan],Return[plan]];
 If[!TrueQ[plan["CanDelete"]],Return[failure["DeleteBlocked","Owned or external dependents block deletion.",<|"Plan"->plan|>]]];
 If[MemberQ[{"Background","Manifold"},key],Return[DeleteBackground[tag]]];
 removed=plan["Objects"];names=ToString[#,InputForm]& /@ removed;
 aliasNames=SymbolName /@ Select[removed,Head[#]===Symbol&];
 If[KeyExistsQ[b,"MetricMatrix"],clearGeometry[tag]];
 r=guard[Internal`InheritedBlock[{Undef},Unprotect[Undef];
   Undef[s_Symbol /; StringStartsQ[ToString[Unevaluated[s],InputForm],"Removed["]]:=Null;
   Scan[undefOwned,plan["Order"]]
 ]];
 remaining=Select[names,registeredNameQ];
 If[r===$Failed || remaining=!={},Return[failure["PartialDeletion","Deletion did not complete. Inspect the retained registry and actual xAct objects before retrying.",<|"RemainingNames"->remaining|>]]];
 releaseAliases[KeyTake[Lookup[b,"ExpressionAliases",<||>],plan["RegisteredExpressions"]]];
 releaseAliases[KeyTake[Lookup[b,"ObjectAliases",<||>],aliasNames]];
 newb=$BG[tag];newb["ExpressionAliases"]=KeyDrop[Lookup[b,"ExpressionAliases",<||>],plan["RegisteredExpressions"]];
 newb["ObjectAliases"]=KeyDrop[Lookup[b,"ObjectAliases",<||>],aliasNames];
 newb["UnavailableObjectAliases"]=Complement[Lookup[b,"UnavailableObjectAliases",{}],aliasNames];
 deadKeys=Keys@Select[managedObjects[newb],!objectRegisteredQ[#]&];
 newb["Field"]=Select[newb["Field"],xTensorQ[#["NewHead"]]&];
 newb["Connections"]=Select[Lookup[newb,"Connections",<||>],CovDQ[#["Head"]]&];
 newb["ConnectionComponents"]=KeyTake[Lookup[newb,"ConnectionComponents",<||>],Keys[newb["Connections"]]];
 newb["FieldComponents"]=Select[newb["FieldComponents"],xTensorQ[#["Head"]]&];
 newb["HeadRules"]=Select[newb["HeadRules"],objectRegisteredQ[Last[#]]&];
 newb["RuleGroups"]=KeyDrop[Lookup[newb,"RuleGroups",<||>],plan["RuleGroupsAffected"]];
 newb["ActiveRuleGroups"]={};
 newb["Theory"]=KeyDrop[newb["Theory"],plan["RegisteredSections"]];
 newb["SpecializationRules"]=Delete[b["SpecializationRules"],List /@ plan["RulePositions"]];
 With[{tt=Join[newb["Theory"],<|"Field"->KeyTake[Lookup[newb["Theory"],"Field",<||>],Keys[newb["Field"]]],"Connections"->KeyTake[Lookup[newb["Theory"],"Connections",<||>],Keys[newb["Connections"]]],"Expr"->KeyDrop[Lookup[b["Theory"],"Expr",<||>],plan["RegisteredExpressions"]]|>]},newb["Theory"]=tt];
 If[MemberQ[deadKeys,"Metric"],
  newb=KeyDrop[newb,Join[{"Christoffel","Riemann","Ricci","RicciScalar","Einstein","Weyl","TFRicci","Kretschmann","Epsilon","DetMetric"},{"Metric","CovD","MetricMatrix","CMetric","ComponentCovD","GeometryPolicy"}]];
  newb["GeometryState"]="AbstractWithoutMetric";
 ];
 If[MemberQ[deadKeys,"Chart"],
  Scan[If[xTensorQ[#],DeleteTensorValues[#]]&,Lookup[Values[newb["Field"]],"NewHead",{}]];
  newb["FieldComponents"]=<||>;newb["ConnectionComponents"]=<||>;
  newb=KeyDrop[newb,{"AdditionalCharts","Chart","Basis","Coordinates","CoordinateLabels","MetricMatrix","CMetric","ComponentCovD","GeometryPolicy"}]
 ];
 newb["PresentationDefaults"]=KeyDrop[newb["PresentationDefaults"],deadKeys];
 newb["PresentationOverrides"]=KeyDrop[newb["PresentationOverrides"],deadKeys];
 $BG[tag]=newb;invalidateResults[tag];
 <|"DeletedNames"->names,"BackgroundRetained"->True,"RemovedExpressions"->plan["RegisteredExpressions"]|>
];
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
ConnectionOf[tag_String,key_:Automatic] := Module[{b=background[tag],a,k},If[FailureQ[b],Return[b]];
 k=connectionKey[b,key];If[FailureQ[k],Return[k]];
 If[k==="Primary",Return[getter[tag,"CovD"]]];
 a=Lookup[Lookup[b,"Connections",<||>],k,Missing[]];
 If[AssociationQ[a],a["Head"],failure["ConnectionKey","No connection has this name."]]
];
ConnectionsOf[tag_String] := Module[{b=background[tag]},If[FailureQ[b],b,Map[#["Head"]&,Lookup[b,"Connections",<||>]]]];
AddConnection[tag_String,key_String,source_Symbol,OptionsPattern[]] := Module[
 {b=background[tag],cd,marker,from,geo,oldgeo,r,all,rec},
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
 cd=freshOwnedSymbol[b["Context"],safeName[key]<>Lookup[b,"SymbolSuffix",safeName[tag]]];installCovDNames[cd,b["Context"]];
 r=guard[With[{cc=cd,ii=First[b["Indices"]],mm=b["Manifold"],sy=marker,tor=TorsionQ[source],cu=CurvatureQ[source],fm=If[from===Null,Null,b["Metric"]],cr=(CurvatureRelations[source]=!={})},
   DefCovD[cc[-ii],{},SymbolOfCovD->sy,Torsion->tor,Curvature->cu,FromMetric->fm,CurvatureRelations->cr]]];
 If[r===$Failed || !CovDQ[cd],If[CovDQ[cd],guard[UndefCovD[cd]]];Return[failure["ConnectionCreation","xAct could not copy the connection."]]];
 geo=connectionGeometry[cd];oldgeo=connectionGeometry[source];
 KeyValueMap[Function[{name,head},If[xTensorQ[head],With[{hh=head,pr=InferFieldPrintAs[oldgeo[name]]},PrintAs[hh]^=pr];setBareBoxes[head,SymbolName[head]]]],geo];
 setBareBoxes[cd,SymbolName[cd]];
 rec=<|"Head"->cd,"OldHead"->source,"Geometry"->geo,"Torsion"->TorsionQ[cd],"Curvature"->CurvatureQ[cd],"Metric"->MetricOfCovD[cd],"SymbolOfCovD"->marker|>;
 all=Join[Lookup[b,"Connections",<||>],<|key->rec|>];
 put[tag,<|"Connections"->all,"HeadRules"->Join[b["HeadRules"],{source->cd},Thread[Values[oldgeo]->Values[geo]]]|>];
 If[KeyExistsQ[b,"AliasContext"],installObjectAliases[tag,connectionAliasHeads[rec]]];
 invalidateResults[tag];rec
];
connectionGetter[tag_,key_,property_] := Module[{cd=ConnectionOf[tag,key],g},If[FailureQ[cd],Return[cd]];
 g=connectionGeometry[cd];Lookup[g,property,failure["NonmetricCurvature","This curvature object is not defined for the selected connection."]]
];
RiemannOf[tag_String,key:(_String|_Symbol)] := connectionGetter[tag,key,"Riemann"];
RicciOf[tag_String,key:(_String|_Symbol)] := connectionGetter[tag,key,"Ricci"];
RicciScalarOf[tag_String,key:(_String|_Symbol)] := connectionGetter[tag,key,"RicciScalar"];
EinsteinOf[tag_String,key:(_String|_Symbol)] := connectionGetter[tag,key,"Einstein"];
WeylOf[tag_String,key:(_String|_Symbol)] := connectionGetter[tag,key,"Weyl"];
ChristoffelOf[tag_String,key:(_String|_Symbol)] := connectionGetter[tag,key,"Christoffel"];
TorsionOf[tag_String,key_:"Primary"] := connectionGetter[tag,key,"Torsion"];
ConnectionDifference[tag_String,key1:(_String|_Symbol),key2:(_String|_Symbol)] := Module[{b=background[tag],c1,c2,ii},If[FailureQ[b],Return[b]];
 c1=ConnectionOf[tag,key1];c2=ConnectionOf[tag,key2];If[FailureQ[c1]||FailureQ[c2],Return[failure["ConnectionKey","Select two existing connections."]]];
 ii=indicesFor[b,3];Christoffel[c1,c2][ii[[1]],-ii[[2]],-ii[[3]]]
];
connectionHeads[b_] := DeleteDuplicates@DeleteMissing@Join[Lookup[b,{"CovD"}],Lookup[Values@Lookup[b,"Connections",<||>],"Head",{}]];
relativeHeads[b_] := Module[{allowed=Join[connectionHeads[b],{PD},If[KeyExistsQ[b,"Chart"]&&ChartQ[b["Chart"]],{PDOfBasis[b["Chart"]]},{}]]},
 First /@ Select[xAct`xTensor`Private`$Christoffels,Function[r,AnyTrue[connectionHeads[b],MemberQ[r[[2]],#]&] && AllTrue[Rest[r[[2]]],MemberQ[allowed,#]&]]]
];

externalRelativeHeads[b_] := Module[{cds=connectionHeads[b],allowed,pd},
 pd=If[KeyExistsQ[b,"Chart"]&&ChartQ[b["Chart"]],PDOfBasis[b["Chart"]],None];
 allowed=Join[cds,{PD,pd}];
 First /@ Select[xAct`xTensor`Private`$Christoffels,Function[r,
   AnyTrue[Join[cds,{pd}],MemberQ[Rest[r[[2]]],#]&] && !AllTrue[Rest[r[[2]]],MemberQ[allowed,#]&]]]
];

(* General connection inputs are coefficients relative to the coordinate derivative,
   or a tensor difference from the primary Levi-Civita connection. *)
Options[SetConnectionComponents]={ReferenceConnection->"Coordinates",Assumptions->Automatic};
primaryGamma[tag_] := Module[{b=$BG[tag],ii,rr},
 If[!KeyExistsQ[b,"MetricMatrix"],Return[failure["NoMetricComponents","Assign metric components first."]]];
 rr=ComputeGeometry[tag,{"Christoffel"}];If[FailureQ[rr],Return[rr]];
 ii=indicesFor[b,3];resolveValues[ComponentArray[Christoffel[b["CovD"],PDOfBasis[b["Chart"]]][{ii[[1]],b["Basis"]},{-ii[[2]],-b["Basis"]},{-ii[[3]],-b["Basis"]}]]]
];
connectionGamma[tag_,rec_] := If[rec["Reference"]==="Coordinates",rec["Values"],rec["Values"]+primaryGamma[tag]];
storeConnection[tag_,key_,rec_] := Module[{b=$BG[tag],cc=ConnectionOf[tag,key],ii,tensor,vals,r},
 vals=connectionGamma[tag,rec];If[FailureQ[vals],Return[vals]];
 ii=indicesFor[b,3];tensor=Christoffel[cc,PDOfBasis[b["Chart"]]][{ii[[1]],b["Basis"]},{-ii[[2]],-b["Basis"]},{-ii[[3]],-b["Basis"]}];
 If[Head[tensor]===Times && First[tensor]===-1,tensor=-tensor;vals=-vals];
 r=guard[Block[{$CVVerbose=False},DeleteTensorValues[Head[tensor]];AllComponentValues[tensor,vals]]];
 If[r===$Failed,failure["ConnectionValues","xCoba could not store the connection coefficients."],Null]
];
replayConnections[tag_] := Module[{b=$BG[tag],r},
 r=KeyValueMap[storeConnection[tag,#1,#2]&,Lookup[b,"ConnectionComponents",<||>]];
 If[AnyTrue[r,FailureQ],First@Select[r,FailureQ],Null]
];
SetConnectionComponents[tag_String,key_String,input_,OptionsPattern[]] := Module[
 {b=background[tag],cc,vals,ref=OptionValue[ReferenceConnection],ass,rec,gamma,n,coords,res,mat,curv,r,old},
 If[FailureQ[b],Return[b]];
 cc=ConnectionOf[tag,key];If[FailureQ[cc],Return[cc]];
 If[key==="Primary",Return[failure["PrimaryConnection","Set the primary connection through the metric matrix."]]];
 If[!KeyExistsQ[b,"MetricMatrix"],Return[failure["NoMetricComponents","Define coordinates and metric components first."]]];
 If[!MemberQ[{"Coordinates","Primary"},ref],Return[failure["ConnectionReference","Choose Coordinates or Primary."]]];
 vals=profile[input,b];n=b["Dimension"];
 If[Dimensions[vals]=!={n,n,n},Return[failure["ConnectionDimensions","Use an array with slots {upper output, lower derivative, lower input}."]]];
 ass=Replace[OptionValue[Assumptions],Automatic:>Lookup[b,"Assumptions",True]];
 rec=<|"Values"->vals,"Reference"->ref|>;gamma=connectionGamma[tag,rec];
 If[!TorsionQ[cc] && arrayZeroCheck[gamma-Transpose[gamma,{1,3,2}],ass]["Status"]=!="Passed",Return[failure["ConnectionTorsion","The supplied coefficients violate the declared zero torsion."]]];
 coords=coordinateValues[b];
 If[MetricOfCovD[cc]=!=Null,
  mat=b["MetricMatrix"];
  res=Table[D[mat[[i,j]],coords[[k]]]-Sum[gamma[[l,k,i]] mat[[l,j]]+gamma[[l,k,j]] mat[[i,l]],{l,n}],{k,n},{i,n},{j,n}];
  If[arrayZeroCheck[res,ass]["Status"]=!="Passed",Return[failure["ConnectionMetricCompatibility","Metric compatibility must be verified for this declared metric connection."]]]
 ];
 If[!CurvatureQ[cc],
  res=Table[D[gamma[[d,j,c]],coords[[i]]]-D[gamma[[d,i,c]],coords[[j]]]+Sum[gamma[[d,i,l]]gamma[[l,j,c]]-gamma[[d,j,l]]gamma[[l,i,c]],{l,n}],{i,n},{j,n},{c,n},{d,n}];
  If[arrayZeroCheck[res,ass]["Status"]=!="Passed",Return[failure["ConnectionCurvature","Flatness must be verified for this declared flat connection."]]]
 ];
 old=Lookup[b,"ConnectionComponents",<||>];
 put[tag,<|"ConnectionComponents"->Join[old,<|key->rec|>]|>];
 r=replayConnections[tag];If[FailureQ[r],put[tag,<|"ConnectionComponents"->old|>];replayConnections[tag];Return[r]];
 invalidateResults[tag];rec
];
ConnectionMatrixOf[tag_String,key_String] := Module[{b=background[tag],r},If[FailureQ[b],Return[b]];
 If[key==="Primary",Return[primaryGamma[tag]]];
 r=Lookup[Lookup[b,"ConnectionComponents",<||>],key,Missing[]];
 If[AssociationQ[r],connectionGamma[tag,r],failure["ConnectionValues","No coefficients have been assigned to this connection."]]
];
(* Coordinate connection coefficients acquire the Hessian of the coordinate map. *)
ConnectionMatrixOf[tag_String,selector_,OutputChart->name_] := Module[
  {b=background[tag],gamma,rec,jac,coordinates,indices,hessian},
  If[FailureQ[b],Return[b]];
  gamma=ConnectionMatrixOf[tag,selector];If[FailureQ[gamma] || MemberQ[{Automatic,"Primary"},name],Return[gamma]];
  rec=chartRecord[b,name];If[FailureQ[rec],Return[rec]];
  jac=rec["Jacobian"];coordinates=Through[rec["Coordinates"][]];
  hessian=Table[D[jac[[i,j]],coordinates[[k]]],{i,Length[jac]},{j,Length[jac]},{k,Length[jac]}];
  indices=indicesFor[b,3];
  Simplify[chartPullback[gamma,b,rec,{indices[[1]],-indices[[2]],-indices[[3]]}]+Inverse[jac].hessian]
];
connectionKretschmann[tag_,cc_] := Module[{b=$BG[tag],key,gamma,n,coords,r,lower,mat,inv,flat},
 key=First@Keys@Select[b["Connections"],#["Head"]===cc&];
 gamma=ConnectionMatrixOf[tag,key];If[FailureQ[gamma],Return[gamma]];
 n=b["Dimension"];coords=coordinateValues[b];mat=b["MetricMatrix"];inv=SparseArray[Inverse[mat]];
 (* xAct convention R[-i,-j,-k,l] with a coordinate reference derivative. *)
 r=Table[$RiemannSign(-D[gamma[[l,j,k]],coords[[i]]]+D[gamma[[l,i,k]],coords[[j]]]-
   Sum[gamma[[l,i,q]]gamma[[q,j,k]]-gamma[[l,j,q]]gamma[[q,i,k]],{q,n}]),{i,n},{j,n},{k,n},{l,n}];
 lower=Table[Sum[mat[[l,q]] r[[i,j,k,q]],{q,n}],{i,n},{j,n},{k,n},{l,n}];flat=Flatten[lower];
 flat . KroneckerProduct[inv,inv,inv,inv] . flat
];

expandConnections[tag_,expr_] := Module[{b=$BG[tag],extra,ex=expr,pd,missing,used,gs},
 pd=PDOfBasis[b["Chart"]];extra=KeyDrop[Lookup[b,"Connections",<||>],"Primary"];
 used=Keys@Select[extra,Function[r,!FreeQ[ex,r["Head"]] || AnyTrue[Values[r["Geometry"]],!FreeQ[ex,#]&] || AnyTrue[relativeHeads[b],(!FreeQ[ex,#] && !FreeQ[TensorID[#],r["Head"]])&]]];
 missing=Complement[used,Keys@Lookup[b,"ConnectionComponents",<||>]];
 If[missing=!={},Return[failure["ConnectionValues","Assign coefficients for every independent connection used in this calculation.",<|"Connections"->missing|>]]];
 Do[With[{cc=extra[key]["Head"]},
   If[MetricOfCovD[cc]=!=Null,
    ex=guard[EinsteinToRicci[TFRicciToRicci[WeylToRiemann[ex,cc],cc],cc]];
    ex=ex/.With[{kh=Kretschmann[cc]},HoldPattern[kh[]]:>connectionKretschmann[tag,cc]];
   ];
   ex=guard[ChangeCovD[ChangeTorsion[ChangeCurvature[ex,cc,pd],cc,pd],cc,pd]]
 ],{key,used}];
 guard[Fold[BreakChristoffel[#1,#2,pd]&,ex,relativeHeads[b]]]
];
Options[CheckConnection]={Assumptions->Automatic};
CheckConnection[tag_String,key_String,OptionsPattern[]] := Module[{b=background[tag],g,cc,n,mat,coords,tor,compat,ass},
 If[FailureQ[b],Return[b]];cc=ConnectionOf[tag,key];If[FailureQ[cc],Return[cc]];
 g=ConnectionMatrixOf[tag,key];If[FailureQ[g],Return[g]];
 n=b["Dimension"];mat=b["MetricMatrix"];coords=coordinateValues[b];ass=Replace[OptionValue[Assumptions],Automatic:>Lookup[b,"Assumptions",True]];
 tor=$TorsionSign(g-Transpose[g,{1,3,2}]);
 compat=Table[D[mat[[i,j]],coords[[k]]]-Sum[g[[l,k,i]]mat[[l,j]]+g[[l,k,j]]mat[[i,l]],{l,n}],{k,n},{i,n},{j,n}];
 <|"Connection"->key,"TorsionFree"->arrayZeroCheck[tor,ass],"MetricCompatible"->arrayZeroCheck[compat,ass],
   "IdentityScope"->If[key==="Primary","Levi-Civita checks also available through CheckBackground","General connection: no metric Bianchi or Ricci-symmetry assumption"]|>
];
ReplaceRules[tag_String,rules_List] := Module[{b=background[tag]},If[FailureQ[b],Return[b]];
 If[!AllTrue[rules,MatchQ[#,_Rule|_RuleDelayed]&],Return[failure["Rules","Supply a list of rules."]]];
 put[tag,<|"SpecializationRules"->rules,"ActiveRuleGroups"->{}|>];invalidateResults[tag];rules
];
RemoveRules[tag_String,positions_List] := Module[{b=background[tag]},If[FailureQ[b],Return[b]];
 If[!DuplicateFreeQ[positions] || !VectorQ[positions,IntegerQ[#]&&1<=#<=Length[b["SpecializationRules"]]&],Return[failure["RulePositions","Use distinct one-based positions from ShowRules."]]];
 ReplaceRules[tag,Delete[b["SpecializationRules"],List /@ positions]]
];
SetRuleGroup[tag_String,name_String,rules_List] := Module[{b=background[tag],a},If[FailureQ[b],Return[b]];
 If[!AllTrue[rules,MatchQ[#,_Rule|_RuleDelayed]&],Return[failure["Rules","Supply a list of rules."]]];
 a=Join[Lookup[b,"RuleGroups",<||>],<|name->rules|>];put[tag,<|"RuleGroups"->a|>];
 If[MemberQ[Lookup[b,"ActiveRuleGroups",{}],name],ActivateRuleGroups[tag,b["ActiveRuleGroups"]]];a
];
ShowRuleGroups[tag_String] := Module[{b=background[tag]},If[FailureQ[b],b,Lookup[b,"RuleGroups",<||>]]];
ActivateRuleGroups[tag_String,names_List] := Module[{b=background[tag],a,r},If[FailureQ[b],Return[b]];
 a=Lookup[b,"RuleGroups",<||>];
 If[!VectorQ[names,StringQ] || !DuplicateFreeQ[names] || Complement[names,Keys[a]]=!={},Return[failure["RuleGroups","Select existing distinct group names in desired first-match order."]]];
 r=Flatten[Lookup[a,names],1];ReplaceRules[tag,r];put[tag,<|"ActiveRuleGroups"->names|>];r
];
RemoveRuleGroup[tag_String,name_String] := Module[{b=background[tag],a,names},If[FailureQ[b],Return[b]];
 a=Lookup[b,"RuleGroups",<||>];If[!KeyExistsQ[a,name],Return[failure["RuleGroups","Unknown rule group."]]];
 put[tag,<|"RuleGroups"->KeyDrop[a,name]|>];names=DeleteCases[Lookup[b,"ActiveRuleGroups",{}],name];
 If[MemberQ[Lookup[b,"ActiveRuleGroups",{}],name],ActivateRuleGroups[tag,names]];Null
];
SaveResult[tag_String,key_String,value_] := Module[{b=background[tag]},If[FailureQ[b],Return[b]];
 put[tag,<|"SavedResults"->Join[Lookup[b,"SavedResults",<||>],<|key->value|>]|>];value
];
ResultOf[tag_String,key_String] := Module[{b=background[tag]},If[FailureQ[b],b,
 Lookup[Lookup[b,"SavedResults",<||>],key,failure["ResultInvalidated","The result is missing or was invalidated by a mathematical change."]]]];

(* Portable managed recipes require the original source xAct definitions to remain alive. *)
recipeObjects[b_] := Join[managedObjects[b],KeyTake[b,{"Christoffel","Torsion","Riemann","Ricci","RicciScalar","Einstein","Weyl","TFRicci","Kretschmann","Epsilon","DetMetric"}],
 Association@Flatten@KeyValueMap[Function[{key,rec},KeyValueMap[("Connection:"<>key<>":"<>#1 -> #2)&,rec["Geometry"]]],Lookup[b,"Connections",<||>]]];
ReconstructionData[tag_String] := Module[{b=background[tag],inputs},If[FailureQ[b],Return[b]];
 inputs=Association@KeyValueMap[Function[{key,fs},key -> (KeyDrop[#,"Head"]& /@ Select[Values[b["FieldComponents"]],#["Head"]===fs["NewHead"]&])],b["Field"]];
 Join[KeyTake[b,{"Theory","Signature","SymbolSuffix","CoordinateLabels","Coordinates","MetricMatrix","Assumptions","SpecializationRules","RuleGroups","ActiveRuleGroups","PresentationOverrides","Notation","ConnectionComponents"}],
 <|"RecipeVersion"->1,"OriginalTag"->tag,"ChartMaps"->Map[KeyTake[#,{"Labels","Map"}]&,Lookup[b,"AdditionalCharts",<||>]],"Objects"->recipeObjects[b],"Indices"->b["Indices"],"FieldInputs"->inputs,
  "RelativeHeads"->relativeHeads[b]|>]
];
RecreateBackground[tag_String,recipe_Association] := Module[{b,r,old,new,rules,coords,inputs,source,result,relative},
 If[KeyExistsQ[$BG,tag],Return[failure["BackgroundExists","Choose an unused tag or delete the old background first."]]];
 If[Lookup[recipe,"RecipeVersion",None]=!=1 || !AssociationQ[Lookup[recipe,"Theory",None]],Return[failure["Recipe","Supply ReconstructionData captured before deletion."]]];
 relative=Lookup[recipe,"RelativeHeads",{}];
 If[AnyTrue[relative,(!FreeQ[Lookup[recipe,"SpecializationRules",{}],#] || !FreeQ[Lookup[recipe,"RuleGroups",<||>],#])&],
  Return[failure["RecipeScope","Reconstruction of rules on relative-connection tensor heads is not supported; rewrite them using named connections first."]]];
 b=Block[{$Theory=recipe["Theory"]},CreateBackground[tag,SymbolSuffix->If[tag===Lookup[recipe,"OriginalTag",None],Lookup[recipe,"SymbolSuffix",Automatic],Automatic],MetricSignature->Lookup[recipe,"Signature",Automatic],Presentation->Lookup[recipe,"PresentationOverrides",<||>]]];
 If[FailureQ[b],Return[b]];
 If[KeyExistsQ[recipe,"CoordinateLabels"],r=DefineChart[tag,recipe["CoordinateLabels"]];If[FailureQ[r],Return[r]]];
 result=KeyValueMap[DefineChart[tag,#1,#2["Labels"],#2["Map"]]&,Lookup[recipe,"ChartMaps",<||>]];
 If[AnyTrue[result,FailureQ],Return[First@Select[result,FailureQ]]];
 b=$BG[tag];old=recipe["Objects"];new=recipeObjects[b];
 rules=Thread[Values@KeyTake[old,Intersection[Keys[old],Keys[new]]] -> Values@KeyTake[new,Intersection[Keys[old],Keys[new]]]];
 rules=Join[rules,Thread[recipe["Indices"]->b["Indices"]]];
 If[KeyExistsQ[recipe,"Coordinates"],rules=Join[rules,Thread[recipe["Coordinates"]->b["Coordinates"]]]];
 If[KeyExistsQ[recipe,"MetricMatrix"],
  r=SetCMetricSystem[tag,recipe["MetricMatrix"]/.rules,Assumptions->(Lookup[recipe,"Assumptions",True]/.rules)];If[FailureQ[r],Return[r]]
 ];
 inputs=Lookup[recipe,"FieldInputs",<||>];
 result=KeyValueMap[Function[{key,records},
   source=recipe["Theory"]["Field"][key]["Head"];
   Map[Function[rec,SetFieldComponents[tag,source,rec["Values"]/.rules,IndexPositions->rec["IndexPositions"],PerturbationOrderLabel->Replace[rec["Order"],None->1]]],records]
 ],inputs];
 If[AnyTrue[Flatten[result],FailureQ],Return[First@Select[Flatten[result],FailureQ]]];
 result=KeyValueMap[SetConnectionComponents[tag,#1,#2["Values"]/.rules,ReferenceConnection->#2["Reference"]]&,Lookup[recipe,"ConnectionComponents",<||>]];
 If[AnyTrue[result,FailureQ],Return[First@Select[result,FailureQ]]];
 put[tag,<|"RuleGroups"->(Lookup[recipe,"RuleGroups",<||>]/.rules),"SpecializationRules"->(Lookup[recipe,"SpecializationRules",{}]/.rules),
   "ActiveRuleGroups"->Lookup[recipe,"ActiveRuleGroups",{}],"Notation"->Lookup[recipe,"Notation",<||>]|>];
 updatePrintHook[];$BG[tag]
];

(* Public convenience forms accept source symbols and owned copied symbols. *)
SetNotation[tag_String,rules__Rule] := SetNotation[tag,Association[(If[Head[First[#]]===Symbol,SymbolName[First[#]],First[#]] -> Last[#])& /@ {rules}]];
SetXPlorerPreferences[rules__Rule] := SetXPlorerPreferences[Association[(If[Head[First[#]]===Symbol,SymbolName[First[#]],First[#]] -> Last[#])& /@ {rules}]];
SetXPlorerPreferences[] := SetXPlorerPreferences[Association[]];
connectionKey[b_Association,selector_] := Module[{keys},
 If[selector===Automatic || selector==="Primary",Return["Primary"]];
 If[StringQ[selector],Return[If[KeyExistsQ[Lookup[b,"Connections",<||>],selector],selector,failure["ConnectionKey","Unknown connection name."]]]];
 keys=Keys@Select[Lookup[b,"Connections",<||>],#["Head"]===selector || Lookup[#,"OldHead",None]===selector&];
 If[Length[keys]===1,First[keys],failure["ConnectionKey","Select a registered source connection or a connection belonging to this background."]]
];
RegisterTheory["Connection",source_Symbol,opts___Rule] := With[{key=SymbolName[source],head=source},RegisterTheory["Connection",key,head,opts]];
AddConnection[tag_String,source_Symbol,opts:OptionsPattern[]] := AddConnection[tag,SymbolName[source],source,opts];
Options[SetPresentation]={PrintAs->Automatic};
SetPresentation[tag_String,object:(_Symbol|_String),opts:OptionsPattern[]] := Module[{b=background[tag],key,objects,candidates,heads},
 If[FailureQ[b],Return[b]];
 If[Complement[First /@ Flatten[{opts}],{PrintAs}]=!={},Return[failure["PresentationOptions","Use PrintAs for the object label."]]];
 If[StringQ[object],key=object,
  objects=Join[AssociationThread[Keys[b["Field"]],Lookup[Values[b["Field"]],"NewHead"]],KeyTake[b,Keys[b["PresentationDefaults"]]]];
  heads=DeleteDuplicates@Join[{object},Last /@ Select[b["HeadRules"],First[#]===object&]];
  candidates=Keys@Select[objects,MemberQ[heads,#]&];
  If[Length[candidates]=!=1,Return[failure["PresentationObject","Select a registered source field/geometry symbol or its owned copy."]]];
  key=First[candidates]
 ];
 SetPresentation[tag,Association[key->OptionValue[PrintAs]]]
];
SetConnectionComponents[tag_String,selector_Symbol,input_,opts:OptionsPattern[]] := Module[{b=background[tag],key},
 If[FailureQ[b],Return[b]];key=connectionKey[b,selector];If[FailureQ[key],key,SetConnectionComponents[tag,key,input,opts]]];
ConnectionMatrixOf[tag_String,selector_Symbol] := Module[{b=background[tag],key},
 If[FailureQ[b],Return[b]];key=connectionKey[b,selector];If[FailureQ[key],key,ConnectionMatrixOf[tag,key]]];
CheckConnection[tag_String,selector_Symbol,opts:OptionsPattern[]] := Module[{b=background[tag],key},
 If[FailureQ[b],Return[b]];key=connectionKey[b,selector];If[FailureQ[key],key,CheckConnection[tag,key,opts]]];

RegisterTheory[args___] := failure["Registration", "Unsupported registration arguments."];

updatePrintHook[];
End[];
EndPackage[];

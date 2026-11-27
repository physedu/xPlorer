# Using xPlorer — beta.13-dev.30

The principal worked guide is xPlorer_Workflow.nb. Start a fresh Mathematica kernel with xAct installed; keep the notebook beside Paclet/ and evaluate its ordinary Get cell. ScalarTheory.wl is an optional source recipe, not a dependency of the notebook.

## Responsibilities and defaults

Mathematica supplies expression evaluation, differentiation, simplification and notebook boxes. xTensor defines abstract mathematical objects and their algebra; xPert expands perturbations; xCoba handles bases and component values. Xplorer copies registered theories onto isolated manifolds, transports expressions, coordinates component inputs and manages the lifetime of owned data.

No configuration is needed for the native notation and primary Levi-Civita workflow. There is no global active background. Give every operation its tag, and use the tensor heads and indices returned for that background. Abstract indices are not coordinate labels. CoordinatesOf returns scalar heads; Through[CoordinatesOf[tag][]] applies each to an empty argument list.

RegisterTheory stores existing definitions, expressions and metadata. It does not solve field equations, impose boundary conditions or automatically enforce the Assumptions/Conditions registry entries. Each new background stores a snapshot; later registrations do not silently change older backgrounds.

## Identity and appearance

| Concept | Example | Meaning |
| --- | --- | --- |
| Source symbol | phi | Existing source xAct object |
| Registry key | "phi" | Lookup name, optionally explicit |
| Copied symbol | private-context phiSchwarzschild1 | Independent actual xAct identity |
| Print label | m or M1 | Presentation, not identity |

PrintAs is inherited automatically. Define phi with PrintAs -> "m", then register it normally to inherit m. RegisterTheory["Field", phi, PrintAs -> "M1"] optionally overrides that label. These are alternatives, not instructions to register one source head under several keys.

For later or background-local changes:

```wl
CreateBackground["Study", Presentation -> <|"phi" -> "M1"|>];
SetPresentation["Study", "Metric", PrintAs -> "q"];
SetPresentation["Study", "phi", PrintAs -> SubscriptBox["M","1"]];
SetPresentation["Study", "phi", PrintAs -> Automatic];
SetPresentation["Study", "Metric" -> "q", "phi" -> "P", "CovD" -> {"|", "D"}];
PresentationOf["Study"]
BackgroundObject["Study", "phi"]
```

Supported presentation keys include field keys, Metric, CovD and primary geometry names. CovD takes the two native connection marker strings; other labels are strings or supported native box structures. Native function-based source labels are resolved by xAct before copying. Indices inherit the source PrintAs; CreateBackground's Indices option selects alternative index labels. Coordinate labels are supplied to DefineChart. Choose abstract index labels at background creation. For convenient typing, assign {muDemo,nuDemo}=BackgroundIndices["NamingExample",2]; these are Latin-letter aliases of the actual owned indices and preserve their Greek display. Clear your aliases after deleting the background.

The native CovD marker pair is {postfix separator, prefix symbol}, for example {"|","D"}. Use PrintAs for one object, or pass several registered string keys as rules in the same SetPresentation call. The association form remains an advanced alternative. SetXPlorerPreferences sets presentation defaults for future backgrounds; RegisterTheory["Presentation", assoc] sets theory defaults. Background overrides take precedence. SetPresentation changes owned heads only and accepts Automatic to restore defaults. Current background settings do not mutate the source. For connection-specific labels, pass SymbolOfCovD when registering or adding that connection. Full InputForm, Context and SymbolName remain available; bare head display uses interpreted short names and indexed tensors use xAct notation.

PrettyExp[expr, opts], expr // PrettyExp, expr // PrettyExp[tag], expr // PrettyExp[opts], and PrettyExp[tag, expr, opts] create optional interpreted views. Unique owned background identity is inferred when possible; otherwise session defaults apply, and explicit tags override inference. No mathematical reverse transport occurs. Normal returns expr, and copying its boxes retains expr. It is a view, not a new tensor. PartialStyle selects Native, MultiIndex, Fraction, Partial, Comma or Prime; Prime only changes single-argument derivatives. CovariantStyle selects Native, Prefix or Postfix. ShowBackgroundLabel adds a label. SetNotation[tag, CovariantStyle -> "Postfix"] supplies background defaults; explicit call options win. SetNotation[tag, CovariantStyle -> Automatic] removes that override. SetXPlorerPreferences[PartialStyle -> "Fraction", CovariantStyle -> "Prefix"] sets session defaults and replaces the previous session preferences. SetXPlorerPreferences[] clears session preferences, not existing local overrides or existing printed labels. The precedence is explicit PrettyExp options, then background notation, then session defaults, then native defaults. These settings never reorder derivatives or change global derivative definitions. Arithmetic composition now delegates to native Mathematica formatting while custom derivative boxes preserve the original expression. ExpressionText[expr, "TeX"] exports the calculated expression using presentation boxes (or the explicit PrettyExp view's style), without the optional background caption. ExpressionText[tag,key,"TeX"] exports a registered abstract formula. Native TeX conversion may still use bracketed function arguments or array-like tensor index layouts; use TexAct for specialist tensor typesetting. InputForm remains replay code, not a standalone serialization. MetricMatrixOf[tag] returns the original covariant matrix in the primary managed chart; use ToComponents with OutputChart for other coordinate systems. Native CTensor has array in its first argument and signed bases in its second. No front-end screenshots are part of the automated headless checks.

## Registration and inspection

Define native tensors before registering them. No legacy positional type argument is supported.

```wl
RegisterTheory["Field", phi, Name -> "matter"];
RegisterTheory["Fields", {A,F}];
RegisterTheory["Parameter", m];
RegisterTheory["Lagrangian", "Gravity" -> Lgrav];
RegisterTheory["Lagrangians", {"Matter" -> Lmatter, "Total" -> Ltotal}];
RegisterTheory["Expression", "ScalarEq" -> eq];
ShowTheory[]
ShowTheory["Fields"]
TheoryValue["Lagrangians","Matter"]
```

Name selects the key and default symbol base; SymbolBase can override the latter, and PrintAs changes appearance only. Sector groups items without changing the mathematics. Registering a named right-hand side preserves its source alias; anonymous formulas require an explicit Head string. No implicit sum of Lagrangians. TheorySnapshot[] returns raw restorable data, distinct from ShowTheory's native overview. Qualified expression keys are {section,key} or explicit BackgroundExpression[tag,section,key]. Existing backgrounds retain their own theory snapshot.

## Connections and components

```wl
DefCovD[DD[-a], {}, Torsion -> True, SymbolOfCovD -> {"|","D"}];
RegisterTheory["Connection", "Affine", DD];
CreateBackground["Study"];
ConnectionOf["Study"]
ConnectionOf["Study", "Affine"]
RiemannOf["Study", "Affine"]
```

The empty second argument to DefCovD adds no extra bundles; xAct infers the source tangent bundle from a. Primary is the registered metric's Levi-Civita connection. AddConnection can copy a source connection onto an existing background. A source connection has one representation per background, preventing ambiguous transport. ConnectionDifference[tag, key1, key2] returns the native tensor with background indices. Nonmetric connections have no native RicciScalar/Einstein/Weyl getters; requesting these returns Failure.

Independent coefficients are supplied after chart and metric components:

```wl
SetConnectionComponents[tag, "Affine", coefficients];
SetConnectionComponents[tag, "Affine", difference, ReferenceConnection -> "Primary"];
ConnectionMatrixOf[tag, "Affine"]
CheckConnection[tag, "Affine"]
```

Array order is {upper output, lower derivative, lower input}, representing Gamma^i_(j k). Pure Function inputs receive coordinate scalars. Coordinates means coefficients relative to the chart's partial derivative; Primary means a tensor difference from the metric derivative. Other reference names are currently rejected. A metric alone does not determine the independent connection. Declared zero torsion, zero curvature and metric compatibility must be verifiable before assignment; undecidable conditions produce Failure rather than accepting inconsistent data. CheckConnection reports torsion and metric-compatibility residuals. Its general-connection checks do not impose Levi-Civita Bianchi identities or Ricci symmetry.

ToComponents selects the appropriate copied objects through transport, then expands the selected derivatives/curvatures using xAct. FreeIndices determines axis order. Components selects zero-based coordinate tuples. StrictComponents rejects unresolved tensor data; chart coordinate scalars are resolved inputs. Field keys cannot shadow reserved geometry/ownership keys. Source and background expressions are accepted, but mixing their indices directly before transport is invalid xAct usage.

### Variance and native CTensor output

SetFieldComponents[tag,A,values] defaults to the source slot configuration; IndexPositions -> {1} supplies upper vector components and {-1} lower components. Mixed and higher-rank configurations use one sign per slot. The supplied configuration is preserved when the metric changes; derived configurations are recomputed.

```wl
ToComponents[tag,A[a]]
ToComponents[tag,A[a],Output -> "CTensor"]
ToComponents[tag,g[-a,-b],OutputChart -> "Cylindrical"]
```

Output defaults to "Array". "CTensor" uses native xCoba CTensor with signed bases matching the ordered abstract free indices, including a named output chart. Requires a complete resolved positive-rank zero-weight tensor, not selected tuples or scalar results. Native xCoba may simplify a zero CTensor. The returned object is a snapshot, not a live linked field. Native changes of basis require native registered transformations. Secondary managed chart maps currently use a Jacobian pullback rather than native SetBasisChange.

### Native xCoba interoperability

CreateBackground defines actual xAct objects. Use BackgroundObject[tag,"Manifold"], BackgroundObject[tag,"Metric"], ConnectionOf[tag], ChartOf[tag] and the copied tensor/index aliases. You can define a native chart or basis, use MetricInBasis, MetricCompute, AllComponentValues, DefBasis, SetBasisChange, ToBasis and ToCTensor directly. See Examples/NativeXCoba.wl and Tests/15_NativeInterop.wl for verified cases. BasisColor is native presentation, not a metric or tensor property. There is no new xPlorer general-basis API.

**Boundary:** native-only chart/value assignments are not registered by xPlorer. Managed ToComponents expects a managed primary chart and metric; it uses abstract expressions, not arbitrary pre-based external expressions. External modifications of managed values do not update the registry, geometry cache, saved results or profile records. ClearComputedValues and managed setters may restore declared managed inputs and discard native edits; use one owner for each managed assignment. Native-only work remains available; no automatic synchronization is claimed. External dependents can block deletion; inspect DeletionPlan, undefine external objects explicitly. CMetricOf, ComponentCovDOf and ExprMatrixOf were removed because they duplicated BackgroundObject/ConnectionOf/ToComponents.

### Named field profiles

```wl
RegisterProfile[tag,"Current"];
RegisterProfile[tag,"Radial",phi,Function[{t,r,th,p},r^2]];
RegisterProfile[tag,"Radial",A,{1,0,0,0},IndexPositions->{1}];
ActivateProfile[tag,"Radial"];
ShowProfiles[tag]
RemoveProfile[tag,"Radial"];
```

RegisterProfile[tag,name] captures currently assigned managed field inputs; the explicit field form validates and stores without activation. Repeated calls under one name add or replace field/order entries. ActivateProfile overlays those entries, retaining unspecified fields/orders and geometry, and invalidates managed saved results. RemoveProfile deletes only stored inputs, not current values. Registration does not invalidate results. Managed profile records are included in reconstruction; chart deletion clears them and deletion of referenced owned objects drops affected profiles. Assignment attempts restore the previous managed inputs on failure; if restoration fails a structured failure reports the incomplete state. External native edits are not preserved by replay. No arbitrary native kernel snapshot or rollback guarantee.

## Rules, results and going back

AddRules appends to the active rules and ReplaceAll uses the first match. ReplaceRules replaces that list. RemoveRules removes one-based list positions. ClearRules removes active rules. None changes a source constant's value.

SetRuleGroup stores a named list; ShowRuleGroups inspects it. ActivateRuleGroups replaces the active list with the chosen groups in order. Editing/removing an active group refreshes active rules. Adding, replacing or selectively removing active rules detaches that list from named groups. Stored inactive groups remain available until explicitly removed.

ComputeGeometry reuses compatible native geometry data. ClearComputedValues clears derived geometry and restores declared metric, field and connection inputs. Mathematical changes replay declared inputs and invalidate saved results. SaveResult/ResultOf is an optional managed store: invalidation is conservative at the whole-background level. Display-only changes preserve it. Ordinary Mathematica variables are not automatically updated. No speedup factor is claimed.

## Cleanup and ownership

| Operation | Effect |
| --- | --- |
| ClearFieldComponents[tag, fieldOrKey] | Removes one field's assigned/derived values; keeps its definition |
| ClearComputedValues[tag] | Discards derived geometry; restores declared inputs |
| UnregisterTheory[section, key] | Removes registration; keeps original xAct objects |
| ClearTheory[] | Clears current registry only |
| DeletionPlan[tag, key] | Previews owned objects, blockers and removal order |
| DeleteBackgroundObject[tag, key] | Truly undefines the selected owned object/family |
| DeleteBackground[tag] | Removes the whole owned background |

Cascade -> True permits tracked dependents within the chosen background. It does not authorize deletion of external/shared source objects. The default blocks dependents, including registered expressions and stored rule groups. To delete the primary Levi-Civita connection, delete its Metric family. Generated curvature servants are removed with their owner. Chart deletion clears coordinate data and permits chart recreation. Metric deletion can retain an abstract manifold and fields without metric geometry; component requests then fail clearly. DeleteBackground still cleans that partial study.

Xplorer follows native dependencies and collapses auto-removed servant families. xAct's chart-specific metric determinant may need detaching from its live metric master before true chart removal. This is restricted to managed owned objects after dependency preflight. Partial failure is reported with the registry retained; transactional rollback is not promised. ReconstructionData captures a managed recipe, and RecreateBackground rebuilds it under an unused tag while the original source xAct definitions remain alive. For example, recipe = ReconstructionData[tag]; DeleteBackground[tag]; RecreateBackground[tag, recipe] restores declared metric, field and connection inputs, presentation and rules with fresh owned symbols. It does not restore derived caches or saved results. Capture the recipe before deletion. Rules on relative-connection tensor heads are explicitly rejected during reconstruction; arbitrary custom definitions and kernel undo are outside this API. Arbitrary notebook variables, custom definitions and untracked expressions are outside the managed dependency graph.

## Supported scope

| Feature | Current scope |
| --- | --- |
| Source geometry | One real zero-weight metric and its Levi-Civita derivative; integer dimension >= 2 |
| Bundles/charts | One real tangent bundle, managed primary chart and additional output charts; native external bases possible |
| Fields | Scalars, vectors, fixed-rank tensors and a metric perturbation; slots and native symmetry inherited |
| Native field metadata | PrintAs, standard conjugation, Frobenius and vanishing behavior; supported dependencies translated |
| Independent derivatives | Ordinary tangent-bundle derivatives, with/without torsion and curvature; metric reference may be the theory metric |
| Rejected configurations | Density fields, graded/projected/orthogonal field definitions, extra manifold/bundle dependencies, weighted-basis or extended derivatives |
| User definitions | Arbitrary DownValues/UpValues, custom xAct extensions and source geometric relationships are not cloned automatically |
| Validation environment | WL 15.0.1 Linux x86-64 and official xAct 1.3.0 |

Not every option exposed by xAct is implemented. Unsupported registration options and unsupported mathematical scopes must fail explicitly. Definition-time errors may still require inspection of the reported partial state. Conjugate tensor transport is tested abstractly; independent component input for conjugate heads is not provided as a separate API. Source scalar functions and constants used in component profiles remain shared inputs rather than independent registered tensor fields.

The relative-connection dependency helper and native label resolver use isolated xAct 1.3.0 internals. Other xAct versions and front-end appearance require verification. Native xAct output conventions remain native; Xplorer's notebook stylesheet adds no fixed colors.

## Installation

Get works directly without installation. For a traditional application, use Install.wl or name the Paclet folder xPlorer and place it in FileNameJoin[{$UserBaseDirectory,"Applications"}], then use Needs["xPlorer`"] in a fresh kernel. The Kernel/init.m loader points to the single package source in Paclet/.

PacletInfo.wl declares a kernel extension using the same source. PacletDirectoryLoad["/path/to/xPlorer/Paclet"] followed by Needs["xPlorer`"] activates a development directory. Tools/BuildPaclet.wl uses the native CreatePacletArchive directly on the prepared Paclet directory, without PacletBuild staging. xAct must be installed separately; it is not bundled or automatically downloaded by the package.

Tests/RunTests.wl runs the historical groups 01-12. For all current bounded groups use Tests/RunGroup.wl in separate fresh kernels with the selected group name (including Registration, RegistrationGeometry, TheoryInspection, NativeInterop, ProfilesAndCTensor, FieldExtensions and SecondaryChartNative). Tests/PacletBuildTests.wl tests deterministic builder failures without installing a package. Tests/WorkflowTests.wl runs actual input boxes from the principal notebook in a fresh kernel. The principal notebook is the source of truth. The historical 88-input Tools builder cannot overwrite it. See BETA13_PROGRESS.md and BETA13_PLAN.md for current execution evidence and limitations.

## Inferred background and theory information (dev.11–12)

```wl
RegisterTheory["Title", "Massive scalar field"];
RegisterTheory["Description", "A real scalar field on curved spacetime."];
RegisterTheory["Assumptions", Element[m, Reals] && m >= 0];
RegisterTheory["Conditions", "Fixed metric variation."];
ShowTheory[]
```

Title and description are optional strings. Assumptions and conditions are recorded information; pass mathematical assumptions to the operation using them. ShowTheory displays this information above geometry, omits empty optional collections and shows sector counts and keys. Metadata remains available for explicit inspection.

```wl
EabSchw // ToComponents // MatrixForm
EabSchw // ToComponents[Output -> "CTensor"]
ToComponents["Schwarzschild", Eab]
```

Background inference uses owned symbol identities. Owner-free or multi-background expressions require an explicit tag. A zero or simplified-away owned expression cannot identify its background. Chart display labels are presentation-only; the actual xCoba chart identity remains private and independent.

## Extending existing backgrounds (dev.15)

Register a native source field, then `AddField["Minkowski", A]` to copy only that field. Existing metrics, charts and managed values are retained; other snapshots and registered formulas are not synchronized. Adding a registered metric perturbation also installs its native xPert relationship. `SetFieldComponents[AM[-aM], {1,2,3,4}]` or `SetFieldComponents[hM[LI[2],-aM,-bM], ConstantArray[0,{4,4}]]` infer the background, variance and order. The expression must use distinct owned abstract indices; component assignments use the primary chart. Only Assumptions is an additional option for this overload. `gM[aM,bM] // PerturbOn[2] // ToComponents` computes a variation, not a truncated Taylor series. `PerturbOn[2, Output -> "Components", OutputChart -> "Cylindrical"]` can combine the calculation and chart conversion. Secondary chart assignments and primary-chart promotion are not implemented. Optional `Examples/EinsteinScalar.wl` uses native xTras VarL with a scalar Lagrangian (no extra determinant factor).

## Reconstruction and native value ownership (dev.16)

ReconstructionData now preserves the managed display-index input and old identities of secondary charts and coordinate heads. RecreateBackground maps these to the new background when restoring managed rules and records. Older recipes without the new metadata cannot recover the missing identities or index customization. Source xAct definitions must remain alive; cached results and arbitrary external definitions are not saved.

If a native xCoba assignment deliberately replaces a managed scalar, record the resolved primary-chart value before saving a managed recipe:

```wl
nativeValue = ToValues[phiM[]];
SetFieldComponents[phiM[], nativeValue];
```

This explicit operation uses the normal managed assignment interface. For a tensor first obtain a resolved primary-chart array with its known slot variance through native xCoba. Native edits outside the integrated dev.18 input signatures below can be lost when replay restores declared inputs. No general native snapshot or arbitrary rollback is promised.

OutputChart remains a choice of output coordinates, not a change of the primary chart. Native MetricInBasis and MetricCompute can compute geometry in a secondary chart after supplying its metric; the study in Tests/18_SecondaryChartNative.wl verifies a cylindrical Christoffel coefficient. Native secondary assignments are not synchronized into the managed recipe. Primary promotion is a deferred design, particularly because of inverse coordinate maps, independent connections and stored rules/profiles.

Build with Tools/BuildPaclet.wl or the separate installer notebook. The builder validates the complete distributable payload and returns Failure if a real archive was not produced. In the remote kernel directory loading and traditional application loading pass, but Java archive compression is restricted. Verify archive build and installation locally before distribution.

## Integrated native xCoba operations (dev.18)

```wl
MetricInBasis[gSchw, matrix, Assumptions -> domain]
MetricCompute[gSchw, {"Ricci", "Einstein"}]
ComponentValue[phiSchw[], u[rSchw]]
AllComponentValues[ASchw[-aSchw], {v[rSchw],0,0,0}]
AllComponentValues[hSchw[LI[2],-aSchw,-bSchw], perturbationMatrix]
ToValues[ASchw[{0,ChartOf["Schwarzschild"]}]]
DeleteTensorValues[ASchw]
```

Here rSchw is the actual coordinate scalar, e.g. CoordinatesOf["Schwarzschild"][[2]][]. MetricInBasis shorthand accepts a full matrix, a diagonal list or a Function yielding a full matrix. Explicit native MetricInBasis with a literal full matrix or diagonal list and the signed primary basis is also managed when $CVReplace is True. The authoritative stored metric is covariant; contravariant input is inverted. Native rule-array return and Inverse/CVSimplify options are supported within this scope. MetricCompute shorthand takes managed target names or All.

Complete literal arrays with explicit primary-chart basis indices also register inputs when $CVReplace is True. Scalar ComponentValue and full DeleteTensorValues on a managed field no longer need Managed -> True. A legacy marker remains available during development. For an individual component, the integrated write path requires an existing complete source record in the same primary-chart variance; it updates the record from the actual native array and invalidates affected head rules. It does not choose a new authoritative variance or fill unspecified entries with zero.

ToValues checks requested explicit primary-chart component configurations, including those in sums and lists. It can calculate the requested variance using native ChangeComponents and reuse native rules when their fingerprints match. The general abstract expression path and selected high-rank components still use the existing ToComponents expansion path. Direct native ChangeComponents runs with an internal calculation guard so its derived array writes are not recorded as physical inputs. Replays are scoped to affected field heads; a metric change still conservatively restores recorded fields. The fingerprints are metadata, not copies of numerical tensors. No eager calculation of all 2^rank combinations and no arbitrary rank cutoff. A single native read may currently prepare a complete requested variance.

Most extensions are owned-head UpValues. ToValues adds one conditional rule to its native list-dispatch signature to cover compound expressions; the original four rules are retained, and unrelated expressions follow the original path. This is a scoped extension, not a second tensor engine. Standard native queries, scalar assignment return rules, CVReplace behavior for scalar and existing recorded source-component writes, and explicit array return rules are preserved in the tested cases. The shorthand returns managed reports as before. No global interception of all xAct methods is claimed.

**Current boundaries:** new incomplete individual-component assignments, assignments to other variances without a complete source record, external/secondary bases, nonliteral native metric input and CVReplace=False metric writes, unintegrated native MetricCompute forms (see dev.19 below), derivative-only edits, RuleToSet state, and native chart/basis creation or destruction are not fully synchronized with the managed registry. Such inputs may remain native-only and can be lost when replay restores declared inputs. Do not mix independent authoritative input configurations. The native read integration only prepares registered complete primary-chart fields. Existing managed setters remain available. No change to archive construction or xTras dependency.

A possible future scoped native-experiment mode is deferred until these integration boundaries are resolved. It must warn that managed records are frozen, restrict the scope to a named background, and distinguish managed replay from arbitrary kernel rollback.

## Native MetricCompute coherence (dev.19)

For a managed primary-chart metric, the native explicit-chart `MetricCompute` signature, including explicit `Zero` torsion, is integrated. It delegates to xCoba with the original target specifications/options and returns the native result (`Null` on success). Complete known geometry groups covered by the native dependency request are recognized by subsequent managed requests. Before a managed request is treated as cached, the corresponding native tensor-value groups must still exist. If an xCoba ReportCompute pointer cache remains after a native rule group is deleted, only that missing group's pointer-cache entry is cleared; native xCoba reconstructs it when requested. This is a version-specific adapter using xCoba 1.3.0's private CacheKeySymbolic, signedbases and Depends functions. It detects missing groups, not arbitrary manual edits inside a surviving group, and does not guarantee policy consistency for mixed native simplification options. Secondary-chart computations, nonzero torsion, arbitrary geometry reads and direct metric-component edits are not yet integrated. No new public command.

## Lazy native geometry reads (dev.20)

`ToValues`, `ComponentValue[expression]` and `AllComponentValues[expression]` now prepare the requested standard native primary-chart geometry when its complete rule group is absent. This includes the primary metric, its chart determinant, the native primary/coordinate Christoffel difference, Ricci, RicciScalar, Einstein, Weyl, Kretschmann and the three standard Riemann configurations. The requested indices must identify the primary basis, or the head must be one of the known rank-zero geometry objects. No automatic chart conversion or alternative geometry variance is implied. ComponentValue/AllComponentValues retain native query returns; compound ToValues retains its native selector and simplification function. The native field variance path is shared by these three readers. Raw TensorValues does not trigger a calculation. The native completeness check uses xCore FoldedRule groups, expected coordinate-tuple count and absence of independent identity rules; it does not prove correctness of arbitrary manual substitutions or support every RuleToSet state. A single conditional global rule is added to each one-argument component reader; native rules remain installed. Native geometry dependencies are delegated to MetricCompute, using the active managed simplification policy. No eager calculation of all geometry or all tensor configurations.

## Selective metric-update invalidation (dev.21)

Managed field input fingerprints are recorded from the actual native rule groups after assignment/replay, and remain runtime metadata rather than part of ReconstructionData. A repeated identical managed assignment does not rewrite matching native sources or invalidate cached results. If a native input group was removed or altered outside the integrated write path, a deliberate repeat assignment restores its declared managed value. Changing the metric preserves all unchanged authoritative field groups, including distinct LI perturbation orders with different source variances, and deletes their non-source ValIDs without recomputing them. Uncertain/missing source groups fall back to replay of only the relevant head. Non-source derivative/basis groups are conservatively invalidated; independent connection records still replay and exact metric re-assignment still uses the previous conservative path. Native xCoba ValIDs include LI labels: field variance fingerprints now also include these labels, fixing deletion detection for a cached perturbation order. No new public command or duplicate numerical tensor cache.

## Native metric-component assignment and repeat inputs (dev.22)

For a complete managed metric in its primary chart, `ComponentValue[g[{i,-chart},{j,-chart}], value]` or the two-upper-index form updates the managed covariant metric record. The native assignment is staged on a localized metric symbol using Internal`InheritedBlock; the actual resulting complete matrix is validated through the existing managed metric path. This preserves native symmetry and CVReplace semantics and rejects a singular candidate before installing it. A contravariant candidate is inverted. Existing native return rules are preserved on success; Failure is returned on invalid input. This is not arbitrary kernel rollback or a promise to restore side effects of user-defined functions. An exact repeated managed metric assignment with identical assumptions and matching fingerprints of the lower/upper native groups skips geometry invalidation and revision changes; an explicit new geometry/policy request is still honored. Successful native inverse computation refreshes the state only when the source is known. Unsupported edits to the source are not silently adopted by repeat metric assignment. No automatic synchronization of other charts, mixed-index metric edits, derivative-only inputs, CTensor metric operations or every RuleToSet state is implied. Identically vanishing xTensors skip managed component hooks and retain their native zero definition.

## Nonstandard native geometry variance and derivative invalidation (dev.23)

A primary-chart native reader may request a different variance of a known geometry head. xPlorer chooses an available native standard source (prefer a previously valid conversion), computes a native source only if needed, and delegates the index transformation to ChangeComponents. Cached fingerprints refer to native source, target and metric groups; no separate numerical tensor cache is used. Known native imploded DMetric, DDMetric and CDRiemann heads participate in lazy primary-chart queries when already defined. Metric invalidation also discovers associated symbolic heads from native ReportCompute entries and known chart derivative heads, and deletes their obsolete values without undefining the tensors. The adapter is tied to native xCoba 1.3.0 cache metadata; general derivative expressions, unregistered chart/basis maps, independent connections and arbitrary manual geometry edits are not yet fully integrated. A single native component query may still prepare a full requested variance.


## Sparse native component assignments (dev.24)

Ordinary native ComponentValue can record individual primary-chart components of registered positive-rank fields, including LI orders, in one declared input variance per field/order. Unknown slots remain symbolic, not zero. Canonical tuples hold only assigned physical values; xCoba keeps its native rules. Dependent symmetry rules and identity placeholders generated by reads do not affect sparse input fingerprints. ToValues prepares an individual same-variance sparse component with native ComponentValue, including antisymmetric/symmetric LI partners. Full replacement arrays replace sparse records. Metric changes, reconstruction, clearing calculated values and profile snapshots/restoration preserve the sparse records. A conflicting variance is rejected rather than silently interpreted as new input. The existing ChangeComponents path can still prepare a full target variance on a single cross-variance request. No arbitrary secondary-chart/derivative writes, partial deletion via DeleteTensorValues, general set-state synchronization or automatic completeness promotion is claimed.

For example, after defining the chart and metric, `ComponentValue[A[{0,-chart}], u[r]]` records only the supplied component. `ToValues[A[{1,-chart}]]` remains symbolic until data or mathematical relations determine it. A native symmetry counterpart can be read with ToValues without supplying it separately. The same mechanism supports distinct LI[n] orders. Use actual background-owned heads and coordinate heads. Use a complete AllComponentValues assignment to change the authoritative variance. CheckBackground reports incomplete fields in its Checks/AssignedFields entry. The sparse record can be captured with RegisterProfile and restored with ActivateProfile. No implicit zero filling.


## Selected component reads (dev.25)

A concrete primary-chart field-component query in another variance (native ToValues/ComponentValue, including complete or sparse input and distinct LI orders) separates only the changed indices with native SeparateMetric, substitutes the requested coordinate tuple, traces the resulting dummy indices with native TraceBasisDummy, resolves native rules, and stores the result through ComponentValue. No full target array is built for a single field query; symmetry-equivalent source groups reuse native ComponentValue. Individual canonical target fingerprints refer to the current native source, metric and target value, not a second tensor array. Repeated reads reuse matching stamps; metric/field edits and deleted or altered native target rules are detected. Full basis requests or complete coordinate-array requests still use ChangeComponents and the existing full-variance stamps. Direct primary-chart ToComponents selections also use this path; sparse full same-variance reads generate required native symmetry rules. No rank cutoff or new public API. The general compound ToComponents expansion and geometry/secondary-chart conversion paths are not optimized by this checkpoint. The actual work for a non-diagonal metric may still grow with the number of contracted indices; fingerprints have a cost, and no universal speedup or wall-clock benchmark is claimed.
For example, `ToValues[T[{0,chart},{1,-chart},{2,-chart},{3,-chart}]]` requests just that component of a registered rank-four field. `ToComponents[tag,T[a,-b,-c,-d],Components->{{0,1,2,3}}]` can use the same path for a direct primary-chart field. A full `ToValues[ComponentArray[T[{a,chart},{-b,-chart},{-c,-chart},{-d,-chart}]]]` remains a complete request. Unassigned sparse source components remain symbolic, including in transformed expressions. A source change invalidates affected native derived groups, not independent backgrounds.


## Held native field component input (dev.26)

HeldComponentValue now integrates literal owned primary-chart field expressions in native Rule state (scalar, positive-rank, complete or sparse and distinct LI orders). Owned-head UpValues preserve the native HoldFirst attribute and DownValues; dispatch uses the actual native HeldComponentValue operation, not a substitution with evaluating ComponentValue. The guard checks held literal syntax and only accepts a field expression that evaluates identically. Use With to insert the actual owned head and basis into a held call; do not silently evaluate aliases or computed arguments. Any tensor with native Set-state ValIDs is deliberately outside this integration. Sparse replay uses Identity for CVSimplify because stored inputs are already actual native values; captured held scalar/complete records carry ExactNativeValues for replay and reconstruction. Complete-field component writes are staged before updating records, rejecting incomplete candidates without corrupting the source, and an exact repeat can restore an externally altered source. Native rule, list of rules and paired-list ComponentValue writes already dispatch correctly. Held metric/geometry writes and reads, derivatives, secondary charts, partial deletion of complete field inputs, DeleteTensorValues group deletion, and RuleToSet/SetToRule/WithSetValues synchronization remain open. No new public command.

To inject the actual owned head and chart into a held call without evaluating the held component prematurely:

```wl
With[{head = BackgroundObject["N", "A"], chart = ChartOf["N"]},
  HeldComponentValue[head[{0, -chart}], 7]
]
```

A held query of the raised component can use the same literal-head pattern. With inserts the evaluated owned symbols before HoldFirst acts. In native Set state or unsupported held expressions, xPlorer intentionally leaves native behavior alone; it does not promise to capture those writes in a reconstruction recipe. Use the existing managed setters for controlled inputs in that case, after restoring Rule state.


## Removing native field input components and groups (dev.27)

A native DeleteTensorValues call identifying the exact registered primary-chart authoritative field group, in Rule state, removes that input record and invalidates its dependent values; a ValID delegates through the native dispatch. Derived-only group deletion remains native and leaves the input record/revision intact. Existing replay conservatively rebuilds the affected field head and recorded dependents, including surviving LI orders, rather than promising to preserve every native cache on that head. ComponentValue[component,Null] and supported literal HeldComponentValue removal now downgrade a complete field input to a sparse record of remaining independent components; an unknown component remains symbolic, not zero. Removing the last sparse value removes the record. The existing stage/replay path still rejects unsupported self-referential incomplete edits. Sparse tuples must be expressed in their record's declared variance: if native ToCanonical interchanges opposite-variance slots, retain a representative in the declared input variance with its correctly signed value; mixed-variance edits deduplicate by native canonical identity. No custom permutation engine or new public command. Earlier affected mixed-variance sparse records may have stored incorrect tuples; no automatic recovery of original input is possible from those records, so reassign the affected field inputs from the original expressions. Native Set-state transitions, held metric/geometry, derivative/secondary-chart input deletion, and general native chart/basis and independent connection lifecycle remain open.

```wl
(* For the actual owned field A and primary chart ch: *)
ComponentValue[A[{0, -ch}], Null]
(* Remaining complete-array input becomes sparse if a value was removed. *)
DeleteTensorValues[A, {{-ch}}]
(* Deletes the recorded source group if it is the authoritative one. *)
```

Use the actual native ValID from TensorValIDs when a symmetry group or LI order needs exact selection. Removing a derived group does not remove the authoritative field record. Profiles are explicit snapshots and can intentionally restore previously saved inputs. Reassign earlier mixed-variance sparse inputs from their original expressions if affected by the previous tuple-order bug.


## Native Set-state and read-only evaluation (dev.28)

```wl
RuleToSet[A]
(* Evaluate already stored components directly; no managed mutations. *)
SetToRule[A]
(* Resume managed component calculation and input editing. *)
```

Native read-only RuleToSet/SetToRule round trips and WithSetValues arithmetic remain native and preserve the original Rule-state source stamp and managed revision in the tested case. Correct the previous unqualified StateOfValID reference: xCoba 1.3.0 implements this as xAct`xCoba`Private`StateOfValID, not xPlorer`Private`StateOfValID. A native HeldComponentValue write on an evaluative Set component was observed to emit TensorValues::invalid (numeric argument). Do not pretend Set-state writes are normal Rule-state inputs. Return Failure["NativeSetState",...] with native ValIDs for literal owned held field accesses and managed operations that require Rule-state source data; reject before replay, metric replacement, geometry computation, field deletion, recipe export or component calculation. Native direct evaluation and read-only transitions are unchanged; no global overrides of RuleToSet, SetToRule or WithSetValues. Background-wide calculations are conservatively guarded, field setters guard affected dependencies, and another background remains independent. Explicit SetToRule is required before managed mutations. Direct Set assignments, arbitrary held/nonliteral calls, arbitrary native mutations inside WithSetValues and their synchronization remain unsupported. This is a safe boundary, not full Set-state interoperability.


## Held native metric edits and geometry reads (dev.29)

```wl
With[{head = gN, chart = ChartOf["N"]},
  HeldComponentValue[head[{0, -chart}, {0, -chart}], -4]
]
```

Use the actual owned metric head (for example gN) if retrieving it through your own workflow. For curvature, use the actual native Ricci/Christoffel symbol; a Christoffel constructor can be a compound head and must not be silently evaluated by a held query. Literal owned primary-chart HeldComponentValue metric edits use the same staged validation and authoritative covariant matrix as ordinary native metric edits, with native held value semantics, CVSimplify bypass on held input, and native CVReplace behavior. Authoritative managed metric matrices are installed/restored exactly (ambient component CVSimplify is not reapplied); geometry calculation retains its configured simplification policy. A single conditional HeldComponentValue read DownValue parallels the existing native read integration, recognizing literal owned geometry heads and primary-chart component indices without changing HoldFirst, and allowing lazily created native geometry heads. Unrelated or compound held heads and nonliteral indices are left native. This is intentionally a scoped global read dispatch, not a second geometry engine; native HeldComponentValue's original rules remain. Tested Ricci and alternate variance, Ricci scalar, Christoffel actual native symbol (GiveSymbol), DMetric/DDMetric, inverse metric, Set-state blocking, external tensors and reconstruction. Preparation loop failures now return from Module explicitly (ordinary Return inside Do was swallowed), tested by injecting failures in all three routes. Derived geometry writes, nonliteral held input, arbitrary native Set-state writes, secondary-chart and independent connection lifecycle remain outside this checkpoint.


## Chart family lifecycle (dev.30)

```wl
DeletionPlan["N", "Chart", Cascade -> True]
DeleteBackgroundObject["N", "Chart", Cascade -> True]
```

This removes the primary and secondary chart family and resets chart-dependent inputs; it is not an individual secondary chart deletion. Use DeleteBackground for complete disposal. Recognize the coordinate partial derivatives of every registered managed chart (not just the primary) as owned derivative heads when classifying relative Christoffel tensors. Full background deletion now undefines only masterless owned relative tensors directly and leaves native Christoffel servants to their owning derivative destructor. Existing chart-family deletion via DeleteBackgroundObject[tag,"Chart",Cascade->True] works after native secondary geometry, retains the primary abstract connection and allows recreation. Actual external derivative dependencies remain blockers. Direct UndefChart/UndefBasis calls on registered chart symbols return an explicit ChartLifecycle failure instead of leaving registry, cached values and recipes dangling; internal managed destructors bypass the owned-head guard. A chart is also a native mapping, so UndefBasis is not its correct destructor. Partial managed object deletion preflights Set state and restores surviving metric inputs exactly, refreshing native metric fingerprints. Standalone removal of one secondary chart, native SetBasisChange/coordinate map integration, and native foreign bases remain open. No new public command.

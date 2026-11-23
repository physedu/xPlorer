# Using xPlorer

The principal worked guide is xPlorer_Workflow.nb. Start a fresh Mathematica kernel with xAct installed; keep the notebook beside xPlorer.wl and evaluate its ordinary Get cell. ScalarTheory.wl is an optional source recipe, not a dependency of the notebook.

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

PrintAs is inherited automatically. Define phi with PrintAs -> "m", then register it normally to inherit m. RegisterTheory["Field", "Scalar", phi, PrintAs -> "M1"] optionally overrides that label. These are alternatives, not instructions to register one source head under several keys.

For later or background-local changes:

```wl
CreateBackground["Study", Presentation -> <|"phi" -> "M1"|>];
SetPresentation["Study", <|"Metric" -> "q", "phi" -> SubscriptBox["M","1"]|>];
SetPresentation["Study", <|"phi" -> Automatic|>];
PresentationOf["Study"]
BackgroundObject["Study", "phi"]
```

Supported presentation keys include field keys, Metric, CovD and primary geometry names. CovD takes the two native connection marker strings; other labels are strings or supported native box structures. Native function-based source labels are resolved by xAct before copying. Indices inherit the source PrintAs; CreateBackground's Indices option selects alternative index labels. Coordinate labels are supplied to DefineChart. Native PrintAs can also be set on an individual returned index or coordinate using With to insert its actual symbol; PrintAs holds its argument, so PrintAs[alias] does not inspect the aliased symbol automatically.

SetXPlorerPreferences sets presentation defaults for future backgrounds; RegisterTheory["Presentation", assoc] sets theory defaults. Background overrides take precedence. SetPresentation changes owned heads only and accepts Automatic to restore defaults. Current background settings do not mutate the source. For connection-specific labels, pass SymbolOfCovD when registering or adding that connection. Full InputForm, Context and SymbolName remain available; bare head display uses interpreted short names and indexed tensors use xAct notation.

DisplayExpression[tag, expr, opts] creates an optional interpreted view. Normal returns expr, and copying its boxes retains expr. It is a view, not a new tensor. PartialStyle selects Native, MultiIndex, Fraction, Partial or Prime; Prime only changes single-argument derivatives. CovariantStyle selects Native, Prefix or Postfix. ShowBackgroundLabel adds a label. SetNotation supplies background defaults; explicit call options win. These settings never reorder derivatives or change global derivative definitions. No front-end screenshots are part of the automated headless checks.

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
| Bundles/charts | One real tangent bundle and one chart per background |
| Fields | Scalars, vectors, fixed-rank tensors and a metric perturbation; slots and native symmetry inherited |
| Native field metadata | PrintAs, standard conjugation, Frobenius and vanishing behavior; supported dependencies translated |
| Independent derivatives | Ordinary tangent-bundle derivatives, with/without torsion and curvature; metric reference may be the theory metric |
| Rejected configurations | Density fields, graded/projected/orthogonal field definitions, extra manifold/bundle dependencies, weighted-basis or extended derivatives |
| User definitions | Arbitrary DownValues/UpValues, custom xAct extensions and source geometric relationships are not cloned automatically |
| Validation environment | WL 15.0.1 Linux x86-64 and official xAct 1.3.0 |

Not every option exposed by xAct is implemented. Unsupported registration options and unsupported mathematical scopes must fail explicitly. Definition-time errors may still require inspection of the reported partial state. Conjugate tensor transport is tested abstractly; independent component input for conjugate heads is not provided as a separate API. Source scalar functions and constants used in component profiles remain shared inputs rather than independent registered tensor fields.

The relative-connection dependency helper and native label resolver use isolated xAct 1.3.0 internals. Other xAct versions and front-end appearance require verification. Native xAct output conventions remain native; Xplorer's notebook stylesheet adds no fixed colors.

## Installation

Get works directly without installation. For a traditional application, name the downloaded folder xPlorer and place it in FileNameJoin[{$UserBaseDirectory,"Applications"}], then use Needs["xPlorer`"] in a fresh kernel. The Kernel/init.m loader points to the single root package source.

PacletInfo.wl declares a kernel extension using the same source. PacletDirectoryLoad["/path/to/xPlorer"] followed by Needs["xPlorer`"] activates a development directory. Tools/BuildPaclet.wl can build a paclet archive with PacletTools. xAct must be installed separately; it is not bundled or automatically downloaded by the package.

Tests/RunTests.wl runs package checks. Tests/WorkflowTests.wl runs actual input boxes from the principal notebook in a fresh kernel. Tools/build_notebook.py rebuilds the notebook from editable English cells and cached native boxes; run Tools/MakeInputBoxes.wl after changing code cells. See VALIDATION.md for actual results and limitations.

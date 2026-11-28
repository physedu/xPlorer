# Research note: native Rule/Set interoperability

Date: 2026-11-28. Independent investigation requested by the maintainer. Tested develop revision [33c75d2](https://github.com/physedu/xPlorer/commit/33c75d21538f1e13af98dc4e8c7c00d3cc86000c), package blob f59754a5a7743d0a651268cff0fbff89923399f7, Wolfram Language 15.0.1 Linux, xAct 1.3.0, xCoba 0.8.6, portable xPerm. No package implementation changes or new public API.

## Purpose

RuleToSet, SetToRule and WithSetValues already belong to xCoba. Native Rule storage allows deferred substitution; Set stores evaluative component definitions. The user can elect to introduce computed values early, e.g. for repeated arithmetic or large perturbation expressions. This is independent of DSolve/NDSolve and is not required for numerical integration. xPlorer should preserve native behavior and explore a bounded, scientifically useful enhancement only if the measured benefit justifies it.

Sources: supplied xCoba.nb, sections 5.3.3, 5.5.0 and 5.5.2 (actual source and examples inspected); [J. M. Martin-Garcia, xAct forum, 2010](https://groups.google.com/g/xact/c/wNXsIGHg6YY). The forum recommends precomputing geometry then choosing when its values enter the expression. It points to KerrNewmanExamples.nb; that notebook was not directly inspected in this investigation. Native source shows that WithSetValues saves tensor/state pairs, converts by whole tensor head and restores only after normal expression evaluation, rather than tracking each individual ValID with cleanup on abnormal exit.

## Current behavior and new experimental evidence

The existing Tests/32_NativeSetState.wl documents tested native round trips, ordinary reads, and explicit rejection of managed operations while affected native ValIDs are in Set state. The guard is deliberately conservative, since evaluated arguments can destroy component identity and assumptions of the managed bookkeeping. It does not redefine the three native transition functions.

Fresh standalone experiments on two independent four-dimensional backgrounds (One: flat-spatial FLRW with a(t)=t; Two: Minkowski), two covariant vector fields VA and VB:
- RuleToSet on a managed field's actual ValID made its known coordinate component evaluate automatically; SetToRule restored explicit substitution. The existing managed ToComponents call correctly returned Failure["NativeSetState",...] while a Set group was active.
- The contraction VA^a VB_a on One was 38/t^2-2t with the profiles below. Native Set reads worked and the other background's VA^a VA_a remained 28.
- A temporary prototype converting only original Set ValIDs back to Rule, running the existing read path, then restoring those original Set ValIDs returned the same contraction, kept the data revision, and preserved mixed states {Set,Rule}. Tested normal completion, Throw and Abort; the prototype retained the original state in those cases. This is feasibility evidence, not a fully validated implementation or a performance optimization.
- **Native WithSetValues hazards:** with one tensor already in mixed {Set,Rule} state, a normal temporary evaluation left {Rule,Rule}. With Throw from an initially Rule group, the group remained Set; with Abort, both initially Rule groups remained Set. These are native behavior in this version, not xPlorer defects. Do not blindly delegate all scoped evaluation to WithSetValues or globally patch that function.
- The prototype uses Internal`WithLocalSettings as an experiment only; this undocumented Wolfram primitive is not yet a production choice. The existing guards remain unchanged; never disable them merely to admit evaluated Set arguments.

## Timing experiment: prepared native component expressions

All profiles and required variances were populated before timing. The compared operations are evaluation of the same prepared symbolic component array via ToValues, native Set direct evaluation with conversions performed outside the timer, and native WithSetValues including conversions for initially Rule groups. RepeatedTiming requested 0.4 seconds per measurement. One run per array size; absolute times are illustrative, not a cross-machine benchmark or an end-to-end ToComponents speedup.

| Prepared expression | ToValues | Already Set | WithSetValues including transitions |
| --- | ---: | ---: | ---: |
| 16 symmetric vector-product entries | 6.469 ms | 0.063 ms | 1.212 ms |
| 256 entries of Ricci times two vectors | 31.889 ms | 0.825 ms | 6.464 ms |

Direct Set results were SameQ to ToValues results in both cases. The temporary method was about 5x faster than ToValues for these prepared-array evaluations, but this measures substitution/arithmetic, not building arrays, expanding abstract derivatives, computing geometry or performing an entire scientific calculation. The native scoped method's mixed-state and abnormal-exit hazards still apply. The experiment did not measure memory or confirm that the timed scoped result is identical in every expression case; normal scoped arithmetic and restoration were checked separately. No production performance claim.

## Reproduction snippets (fresh kernel, xAct installed, xPlorer source from tested revision)

```wl
DefManifold[ProbeM,4,{aa,bb,cc,dd,ee,ff,ii,jj}];
DefMetric[-1,gg[-aa,-bb],CDa];
DefTensor[VA[-aa],ProbeM];
DefTensor[VB[-aa],ProbeM];
RegisterTheory["Metric",gg];
RegisterTheory["CovD",CDa];
RegisterTheory["Indices",{aa,bb,cc,dd,ee,ff,ii,jj}];
RegisterTheory["Fields",{VA,VB}];
CreateBackground["One",SymbolSuffix->"O"];
CreateBackground["Two",SymbolSuffix->"T"];
DefineChart["One",{tt[],xx[],yy[],zz[]}];
DefineChart["Two",{tt[],xx[],yy[],zz[]}];
MetricInBasis[ggO,DiagonalMatrix[{-1,ttO[]^2,ttO[]^2,ttO[]^2}]];
MetricInBasis[ggT,DiagonalMatrix[{-1,1,1,1}]];
AllComponentValues[VAO[-aaO],{ttO[],2,3,4}];
AllComponentValues[VAT[-aaT],{1,2,3,4}];
AllComponentValues[VBO[-aaO],{2,3,4,5}];
ch=ChartOf["One"];
state[v_]:=xAct`xCoba`Private`StateOfValID[v];
states[h_]:=state/@TensorValIDs[h];
up=ToComponents["One",VA[aa],StrictComponents->True];
reference=ToComponents["One",VA[aa]VB[-aa],StrictComponents->True];
ids=TensorValIDs[VAO];
RuleToSet[First[ids]];
states[VAO]
ToComponents["One",VA[aa]VB[-aa]]
WithSetValues[VAO[{0,-ch}]+VAO[{1,-ch}],VAO]
states[VAO]
Scan[SetToRule,Select[TensorValIDs[VAO],state[#]===Set&]];
```

Prototype for a managed read with preexisting Set values (not production code):
```wl
SetAttributes[readInRule,HoldFirst];
readInRule[expr_,heads_]:=Module[
 {setIds=Select[Flatten[TensorValIDs/@heads],state[#]===Set&],r},
 Internal`WithLocalSettings[
  Scan[SetToRule,setIds],
  r=expr,
  Scan[RuleToSet,setIds]];
 r
];
RuleToSet[First[TensorValIDs[VAO]]];
before=states[VAO];
r=readInRule[ToComponents["One",VA[aa]VB[-aa],StrictComponents->True],{VAO}];
{SameQ[r,reference],SameQ[before,states[VAO]]}
CheckAbort[readInRule[Abort[],{VAO}],Null];
SameQ[before,states[VAO]]
Scan[SetToRule,Select[TensorValIDs[VAO],state[#]===Set&]];
```

Timing the prepared products (ensure all relevant groups are Rule before starting):
```wl
ricciArr=ToComponents["One",Ricci[CDa][-aa,-bb],StrictComponents->True];
rh=Ricci[CovDOfMetric[ggO]];
rawR=Table[rh[{i,-ch},{j,-ch}] VAO[{k,-ch}] VBO[{l,-ch}],
 {i,0,3},{j,0,3},{k,0,3},{l,0,3}];
refR=ToValues[rawR];
First[RepeatedTiming[ToValues[rawR],0.4]]
First[RepeatedTiming[With[{held=rawR},WithSetValues[held,{rh,VAO,VBO}]],0.4]]
RuleToSet[rh];RuleToSet[VAO];RuleToSet[VBO];
resR=rawR;
First[RepeatedTiming[rawR,0.4]]
SetToRule[rh];SetToRule[VAO];SetToRule[VBO];
SameQ[refR,resR]
```

The first vector benchmark used the 4x4 array Table[VAO[{i,-ch}] VBO[{j,-ch}]+VAO[{j,-ch}] VBO[{i,-ch}],{i,0,3},{j,0,3}]. One initial curvature run used an incorrect derivative alias and terminated; the corrected run retrieved CovDOfMetric[ggO] and completed. No incomplete run was counted as a curvature measurement.

## Decision and bounded next work

Evidence justifies adding a small optional interoperability/performance investigation to Phase 3 of the active beta plan, after the two pending mathematical defects. It is not a new P0 or unconditional release blocker.

1. Preserve the native commands and test ordinary managed read-only component evaluation after a user's native RuleToSet. Explore a localized per-ValID restoration approach with no global modifications of native transitions. Only support cases where the original state, authoritative source data and other backgrounds demonstrably remain intact; otherwise preserve the current explicit diagnostic. Managed mutations in Set state and arbitrary native assignments remain unsupported.
2. Independently test temporary Set evaluation only after native component preparation, at the appropriate substitution/contraction stage. Select exact already-known owned ValIDs; preserve mixed states, unknown sparse components, perturbation LI orders, geometry/field cache state and isolation, including Throw/Abort cleanup. Never convert all tensors indiscriminately or change the default before correctness evidence.
3. Compare full wall time and memory for complete ToComponents workflows (scalar/vector/tensor, curved geometry, higher-order perturbation or repeated curvature contractions), with transition overhead and fresh/warm cache distinctions. Compare actual mathematical results against existing paths; benchmark without changing physical assumptions. A small prepared-array speedup alone is insufficient to adopt the optimization.
4. Implement only a small safe integration if evidence demonstrates practical benefit; otherwise document the tested native workflow and close the optional task. No public API addition, permanent Set-state policy, new cache or universal rollback is required.

## Follow-up — full-workflow prototype after Phase 2 (2026-11-28)

Package revision [07090af](https://github.com/physedu/xPlorer/commit/07090afaf21af4244892eaf240ca0d6ae10c7ada), source blob 90cef340400e8fbcac7fb5b6a3d3514f97db8daa. Separate fresh kernels, Wolfram 15.0.1 Linux, xAct 1.3.0, portable backend. No production code change.

A temporary local source copy replaced only the final prepared-array trace/resolve call in ToComponents with a scoped conversion of the exact native Rule ValIDs associated with tensor symbols in that array. The prototype keeps native TraceBasisDummy and ToValues, and restores original groups on exit. This is a feasibility experiment, not a supported adapter. The patch was applied only inside the evaluator's temporary directory.

The test uses flat-spatial FLRW with a(t)=t, a covector VA_a=(t,2,3,4), and metric perturbation h_11=t^2, second order input zero. A separate Minkowski background is a positive control. Each workload was run after ClearComputedValues (cold), then RepeatedTiming[expr,0.5] (warm), then MaxMemoryUsed[expr] (reported allocation peak). These are single-run exploratory measurements from separate kernels, not statistically robust performance guarantees.

| Complete operation | Baseline cold ms | Prototype cold ms | Baseline warm ms | Prototype warm ms | Baseline peak bytes | Prototype peak bytes |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Vector norm | 31.498 | 28.757 | 17.155 | 21.089 | 66928 | 82904 |
| Ricci contraction | 136.280 | 125.218 | 43.314 | 36.424 | 90480 | 112272 |
| Second inverse metric variation | 672.938 | 545.794 | 676.006 | 523.229 | 338304 | 360800 |

All three analytic checks passed with and without the prototype: -t^2+29/t^2, 58/t^4 and DiagonalMatrix[{0,2/t^2,0,0}]. The data revision and source field records remained unchanged across warm runs, no Set groups leaked in the inspected metric, field and geometry heads, and the independent Minkowski norm remained 28. The measured warm-time reduction is about 16% for Ricci contraction and 23% for the second variation; vector norm was about 23% slower. All reported allocation peaks increased. This does not justify enabling Set conversion indiscriminately.

Prototype core (temporary package copy only):

```wl
SetAttributes[probeSetPrepared,HoldFirst];
probeSetPrepared[expr_,input_] := Module[{heads,ids,out},
 heads=DeleteDuplicates@Cases[input,s_Symbol /; xTensorQ[s],{0,Infinity},Heads->True];
 ids=Select[DeleteDuplicates@Flatten[TensorValIDs /@ heads],
   xAct`xCoba`Private`StateOfValID[#]===Rule&];
 Internal`WithLocalSettings[
  Scan[RuleToSet,ids],
  out=Block[{$insideManagedCalculation=True},expr],
  Scan[SetToRule,ids]];
 out];
(* Experimental replacement of final prepared-array evaluation only: *)
arr = guard[probeSetPrepared[resolveValues[traceValues[arr]],arr]];
```

### Read-only compatibility: remaining reason not to enable automatically

A broader test used the metric, Ricci tensor, complete vector, sparse vector and metric perturbations (LI orders 1 and 2). It selected the first ValID per head and converted to Set, leaving a mixed state {Set,Rule,Set,Rule,Set,Set,Rule,Set}. A guarded scoped read prototype converted these exact groups back to Rule and required nativeMetricCurrentQ and nativeInputCurrentQ for every authoritative input before calculation. The guard declined all four reads, restoring the original states even on Abort; the other background was unaffected.

The follow-up isolated the cause: before conversion, all fingerprints matched; after RuleToSet followed by SetToRule, the metric fingerprint and perturbation LI[2] fingerprint no longer matched, despite the vector, Ricci, inverse perturbation and sparse field component results all being SameQ to baseline on manual Rule restoration. The other input fingerprints matched. The state round trip was exact, but raw native rule-group representation was not fingerprint-equivalent. This does not prove a native value error; it establishes that automatic state restoration cannot yet certify authoritative inputs by the current stamps. Do not ignore or overwrite fingerprints blindly, especially when users may have actually changed Set definitions. The existing explicit transition path remains usable in tested read-only cases.

**Decision:** the bounded experiment is complete for the beta roadmap. Do not ship the temporary optimization or broaden automatic managed reads in Set state in this beta candidate. Keep explicit native RuleToSet/SetToRule and the existing diagnostic. If researcher demand warrants it, revisit semantic state verification and targeted opt-in optimization after publication; test more workloads, sparse/LI/metric input identities, abnormal exit and cold/warm memory with repeated trials. This is a future improvement, not a mathematical release blocker.

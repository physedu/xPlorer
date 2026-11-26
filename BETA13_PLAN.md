# beta.13 consolidation plan — 2026-11-26

Author-approved direction: xPlorer complements xAct; native xTensor/xCoba/xPert/xTras remain usable on actual owned objects. Keep convenience functions. Do not duplicate xCoba basis machinery unless a concrete need is demonstrated. No main merge or release.

## Work sequence
- [x] Revalidate dev.4 (registration, inspection, notebook, banner).
- [x] Remove redundant CMetricOf, ComponentCovDOf, ExprMatrixOf and migrate callers; retain MetricMatrixOf, BackgroundObject, ConnectionOf.
- [x] Replace old reverse-transport PrettyExp with safe interpreted presentation (formerly DisplayExpression); remove duplicate public DisplayExpression; support expr // PrettyExp, expr // PrettyExp[tag], expr // PrettyExp[options], explicit form PrettyExp[tag,expr,options]. Infer unique owner; ownerless/ambiguous expressions use session defaults unless tag explicit. Preserve original expression via Normal and InterpretationBox, do not modify heads or indices. Retain SetNotation (background partial/covariant style), SetPresentation (labels), SetXPlorerPreferences (session). Do not implement inverse transport implicitly.
- [x] Retain and test ToBasisOf, ToValuesOf, ChristoffelOf, TorsionOf, ReplaceRules, ClearBackgrounds, ComputeOnSet. Guard missing basis.
- [x] Native interoperability regression and example: native DefChart/MetricInBasis/ComponentValue after CreateBackground; separately managed primary chart plus external DefBasis/SetBasisChange/ToBasis; verify variance, values, primary results, dependency-safe deletion and colors. Do not assume native edits update managed registry. Document mixing limitations; only implement synchronization after a demonstrated safe contract.
- [x] Evaluate named profile sets (multiple fields, stored variance, activation, atomic rollback, cached geometry reuse); implement only if validated. Existing SetFieldComponents replaces current profile.
- [x] Evaluate native ToCTensor integration (possible Output -> "CTensor"); preserve current array default, rank, basis, variance, reject partial arrays/unsupported inputs. No redundant API without need.
- [x] Migrate actual notebook and tests, API guide, README/version/paclet/citation; retain native Mathematica boxes.
- [x] Build dev.6 paclet in Mathematica Desktop (author's Windows build).
- [x] Implement clean staging builder and verify its staging/failure handling remotely.
- [ ] Verify clean builder success, Desktop paclet installation/loading and rendering.
- [x] Full regression on immutable commits, report actual results.
- [ ] Release readiness, including real Desktop check; no main merge or release.

Known risks: additional charts currently use Jacobian pullback for output, not native basis change registrations; external modifications can desynchronize MetricMatrix/FieldComponents/geometry cache; external dependencies may prevent deletion. Basis color is presentation only. Ordinary tangent tensors supported, spinors not implied. Do not promise all external xCoba combinations work without tests.

Historical evidence in BETA13_PROGRESS.md and API_AUDIT.md. Each completed task must record commit and evidence; deferred design is not implementation.

## Execution checkpoint: dev.6

- dev.4 validated; dev.5 consolidated API, dev.6 adds profiles and CTensor. Source commit 7c374a6e7b8f4e05724e4c8747a2d0b9605afd67 (blob b2f1640adcb22bea55c42866798fd0706c4a2474). See BETA13_PROGRESS.md for exact test commits.
- Eight historical regression groups 288/288 executions (including repeats), 45/45 registration, 23/23 inspection, 20/20 native interop, 33/33 profiles/CTensor. Actual notebook 119/119 inputs, 66/66 expected checks, 7/7 stages.
- RegisterProfile supports direct input and capture of current managed values; activation overlays fields/orders, not all-field replacement. No separate active profile flag. ShowProfiles and RemoveProfile inspect/remove stored data. Geometry cache reused; reconstruction remaps named records. Managed restoration is attempted on assignment error; catastrophic native failure/rollback not fault-injected.
- Output -> "CTensor" supports complete resolved positive-rank zero-weight tensor arrays, in primary or selected output chart. Default Array unchanged. Native xCoba handles changes of basis. No managed general-basis API and no automatic synchronization of external native edits: the native-only chart workflow deliberately remains unmanaged. Do not assume every mixed native operation is safe.
- Native example in Examples/NativeXCoba.wl and canonical notebook new examples; API guide and metadata updated. Historical validation/Tools sources remain historical.
- Traditional temporary application installation and double-Get banner confirmed. Actual .paclet archive still fails explicitly due Java SecurityException; GUI check pending. Keep main unchanged.

## Desktop build follow-up

Author screenshot confirms the original dev.6 builder returned Success and created an archive on Windows. Clean staging builder commit 5df780b6c681423fb807add826b709425098931d changes tooling only, not package payload or version. Remote staging no longer emits excluded-development-file warnings; missing-input and cleanup checks pass. Archive compression remains blocked remotely. Preserve the existing author-built archive, verify installation and payload before attaching it to a future release. No main merge or release.

## Presentation follow-up: dev.7

Author Desktop output confirms dev.6 loads and shows the banner. Replaced the styled title with native xAct-style printed lines (source 1b5b23ba75ca776a55a51520f83723a9d20bc226). Tested double Get, inspection 25/25 and actual notebook 119/119, 66/66 results, 7/7 stages at cba6f0b4dd2c40df5cce40019cb0b57dcfa35882. Mathematics unchanged. Desktop dev.7 visual/build/install check remains pending; no release or main merge.

## Public-facing startup text (dev.8)

The author requested a permanent scientific package welcome message suitable for public distribution, without development-specific instructions, promotional wording or repository link. Final source commit 84ee5a291fad25af77299dabdfa1c105fc2e8a4d, metadata synchronized at 12e5bedf49511c74233ec578df1692831f10efdf. Version remains dynamically read from $XPlorerVersion; the text does not assume a final release number. Plain xAct-style lines describe abstract theory reuse on independent geometric backgrounds, tensor-expression transport, component calculations, dependencies, copyright, GPL v3-or-later and warranty disclaimer. AboutXPlorer[] returns the same content. Remote double-Get test at 12e5bedf49511c74233ec578df1692831f10efdf prints the banner once; inspection 25/25, including plain strings, no styles/hyperlinks or GitHub in the banner. Mathematical source unchanged; full notebook last rerun on dev.7. Desktop visual review pending. No release or main merge.

## Workflow review following author Desktop feedback (2026-11-26, dev.8)

The reported missing EabSchw was reproduced exactly by creating Schwarzschild before registering Eab, then calling CreateBackground with the existing tag. Current theory contains Eab, old snapshot does not, alias stays unassigned and qualified BackgroundExpression returns ExpressionKey Failure. A newly created background includes the expression and alias. This reproduces the symptoms, but the author's actual kernel history is not known. Preserve existing snapshot semantics, add immediate notebook checks and explain fresh kernel/recreation. A regression in Tests/13_Registration.wl (6a7aec667534703deddd81306386846fb6a0109d) passed 50/50; five new assertions distinguish old vs new snapshots. The registration API remains unchanged; uniform singular/plural names proposed for discussion only.

Canonical notebook commit 93047330dffa06d7e807095a3acd79ac5ce185e0: replace misleading NamingExample Schw suffix by Demo and demonstrate Greek abstract indices via Indices; simplify curvature demonstration, remove Context/With inspection; compare real Prefix/Postfix and Native/Fraction views; show Eab registration result, check snapshot and alias immediately, restore field/metric/derivative labels visibly, verify massless equation has no free indices and matches transported boxPhi. Nine malformed compound cells were found by holding parsed input; regenerated and corrected all, including three remaining trailing-semicolon cells. An intermediate notebook commit had truncated generated boxes; repaired before final validation. Workflow runner detects malformed compounds and nested Failure. Final remote execution at 97837d5aa92b27b6d1d622ca98b3a70ca266f848: 119/119 inputs, 68/68 expected results, 8/8 stages, zero malformed compound cells, parse failures, warnings or unexpected failures. Greek labels stage passed. Massless contraction and Eab snapshot checks passed. Package source and version unchanged; no release or main merge. Desktop visual review and confirmation of user's original Eab issue still pending.

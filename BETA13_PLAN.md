# beta.13 consolidation plan — 2026-11-26

Author-approved direction: xPlorer complements xAct; native xTensor/xCoba/xPert/xTras remain usable on actual owned objects. Keep convenience functions. Do not duplicate xCoba basis machinery unless a concrete need is demonstrated. No main merge or release.

## Work sequence
- [ ] Revalidate dev.4 (registration, inspection, notebook, banner).
- [ ] Remove redundant CMetricOf, ComponentCovDOf, ExprMatrixOf and migrate callers; retain MetricMatrixOf, BackgroundObject, ConnectionOf.
- [ ] Replace old reverse-transport PrettyExp with safe interpreted presentation (formerly DisplayExpression); remove duplicate public DisplayExpression; support expr // PrettyExp, expr // PrettyExp[tag], expr // PrettyExp[options], explicit form PrettyExp[tag,expr,options]. Infer unique owner; ownerless/ambiguous expressions use session defaults unless tag explicit. Preserve original expression via Normal and InterpretationBox, do not modify heads or indices. Retain SetNotation (background partial/covariant style), SetPresentation (labels), SetXPlorerPreferences (session). Do not implement inverse transport implicitly.
- [ ] Retain and test ToBasisOf, ToValuesOf, ChristoffelOf, TorsionOf, ReplaceRules, ClearBackgrounds, ComputeOnSet. Guard missing basis.
- [ ] Native interoperability regression and example: native DefChart/MetricInBasis/ComponentValue after CreateBackground; separately managed primary chart plus external DefBasis/SetBasisChange/ToBasis; verify variance, values, primary results, dependency-safe deletion and colors. Do not assume native edits update managed registry. Document mixing limitations; only implement synchronization after a demonstrated safe contract.
- [ ] Evaluate named profile sets (multiple fields, stored variance, activation, atomic rollback, cached geometry reuse); implement only if validated. Existing SetFieldComponents replaces current profile.
- [ ] Evaluate native ToCTensor integration (possible Output -> "CTensor"); preserve current array default, rank, basis, variance, reject partial arrays/unsupported inputs. No redundant API without need.
- [ ] Migrate actual notebook and tests, API guide, README/version/paclet/citation; retain native Mathematica boxes. Desktop rendering and archive install require verification.
- [ ] Full regression on immutable commits, report actual results, no release until validated.

Known risks: additional charts currently use Jacobian pullback for output, not native basis change registrations; external modifications can desynchronize MetricMatrix/FieldComponents/geometry cache; external dependencies may prevent deletion. Basis color is presentation only. Ordinary tangent tensors supported, spinors not implied. Do not promise all external xCoba combinations work without tests.

Historical evidence in BETA13_PROGRESS.md and API_AUDIT.md. Each completed task must record commit and evidence; deferred design is not implementation.

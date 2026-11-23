# Design decisions

## Required behavior

- Optional personalization. Existing straightforward calls remain useful without preference setup.
- Presentation precedence: explicit call > background override > theory override > general preference > effective inherited native presentation. This precedence applies only where the API supports the relevant level.
- Mathematical properties have their own validated definition/copy rules. A style preference never changes torsion, signature, symmetry or dependencies.
- No global SetOptions or permanent native xAct naming overrides. Prefer scoped definitions on owned symbols; test cleanup.
- Separate actual symbol, registry key and displayed form. A field phi may use key "phi" and display m. An explicit key "Scalar1" is optional and unrelated to changing the display to M1.
- Contexts isolate objects; normal output should be legible while full identity remains inspectable. Short names must handle duplicate tags, recreation and collisions without relying on labels alone.
- A background is an independent managed collection, not a global mode. Existing background snapshots do not silently change when a theory item is later registered.
- Preserve native tensor objects and user mathematical expressions. Presentation views are not computational replacements. PrettyExp-style comparison views must explain any mapping back to source objects.
- Clear rules, clear field data, invalidate caches, unregister and undefine are different operations with explicit names and effects.
- Ownership is explicit. Imported/source xAct objects are external by default. Never assume registration grants permission to destroy them.
- Default deletion protects dependents; optional bounded cascade and preview do not imply a confirmation prompt for every operation.
- Saved managed recipes may reconstruct objects; arbitrary user variables are not globally repaired and kernel undo is not promised.
- Retain a primary connection to preserve simple calls; general connection calculations require adequate independent data and valid identities.
- English ASCII deliverables and theme-inherited notebook styles. Chat may remain Spanish.

## Baseline observations, not new features

The local 14.0.0-beta.2 source uses private numbered background contexts, supports one metric/Levi-Civita pair per background, and defaults field presentation to the source SymbolName rather than its effective native PrintAs. Full inheritance and multiple-connection integration remain planned. Existing DeleteBackground follows native dependencies and protects external visitors. ClearTheory removes the registry, not all source xAct definitions. Selective public rule removal is planned.

RegisterTheory is HoldAll: an Association stored in a variable may need lexical insertion (for example With) rather than a bare variable argument. Preserve and test supported forms instead of assuming evaluation behavior.

Prior naming-hook and PrintAs experiments are feasibility evidence only. They do not prove full integration of binary connection naming, components, ownership or every native option.

## Implementation decisions still to resolve with evidence

- Exact public API names for overrides, inspection, deletion plans, connections and rule groups.
- Naming/escaping scheme and scoped bare-head box formatting.
- Supported native property matrix, complex conjugation, density weights, multiple bundles and derivative display behavior.
- Dependency graph representation, invalidation strategy and partial-failure recovery.
- Distribution layout and application/paclet metadata.

Choose routine reversible details autonomously; record rationale and compatibility impact. Ask only for material unresolved scope choices. Do not describe illustrative future syntax as an implemented API.

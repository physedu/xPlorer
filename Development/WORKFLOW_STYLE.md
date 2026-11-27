# Workflow editorial rules

Maintainer's requirements (27 November 2026). Apply these before editing either public scientific notebook. These are editorial acceptance criteria, not optional suggestions.

## Prose and layout

- Use English and the native Mathematica notebook stylesheet; inherit theme colors.
- Write coherent, short paragraphs with one purpose each. Use a real blank paragraph break (two newline characters in TextData or separate Text cells) when changing topic. Do not concatenate several distinct explanations into a dense text block or merely rely on window wrapping.
- Explain a function immediately before the input that uses it. Introduce the physical question first, then the relevant syntax, then the interpretation of a non-obvious result.
- Use inline code styling for function names, options and typed aliases, following the current API Examples notebook. Avoid long, dense inventories of options in prose.
- Keep the Introduction open, the main numbered scientific sections closed, and their subsections open. Installation and removal belong in xPlorer_Install.nb; scientific notebooks offer only Needs or Get.
- Use one independent operation per Input cell. Do not collect independent examples or results in lists, Column, Row, Grid, or compound input cells merely for display. Necessary mathematical lists (indices, component arrays, rules, arguments) remain lists. MatrixForm is appropriate for component arrays.
- Preserve native xAct/Wolfram syntax and readable, theme-independent mathematical output. Use short typed symbols with Greek PrintAs where appropriate (e.g. w with omega). Prefer native boxes for newly authored scientific inputs, consistent with the API reference.

## Scientific teaching

- The older extended Workflow supplied by the maintainer and the current API Examples notebook are the pedagogical references. Preserve the narrative: derive once, register, inspect and retrieve, reuse abstract expressions on independent backgrounds, specialize with rules, then calculate components.
- Teach the distinctions between typed aliases, lookup keys and printed labels. Demonstrate SetXPlorerPreferences, SetNotation, SetPresentation and PrettyExp only when they genuinely improve a complete scientific expression. Show the difference in actual output, not merely a different option or a one-term toy expression. Explain that BackgroundLabel selects a marker and ShowObjectLabels enables visibility; a new session preference call replaces the previous defaults.
- Demonstrate rules on meaningful expressions and show that another background remains unaffected. Keep components straightforward with DefineChart, MetricInBasis, ComponentValue and ToComponents. Place perturbations immediately after the component calculation section. Move exhaustive variations and lifecycle details to API Examples.
- Keep the introductory tutorial concise; do not turn it into the full API reference. Never sacrifice clarity simply to reduce the cell count.

## Acceptance

- Review prose paragraph by paragraph and the output of examples against the current API notebook and maintainer's reference.
- Run the actual Workflow inputs in a fresh kernel; check mathematical results and StandardForm box differences for presentation examples. A kernel test is not a substitute for Desktop visual review.
- Keep tests and this document on develop. Synchronize reviewed public notebooks in main and the curated ZIP; do not change the scientific package merely to rewrite a tutorial. Record what was actually tested and what remains pending.

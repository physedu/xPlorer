# HANDOFF.md - Cross-Agent Context Handoff

> **Rule:** Every agent (Antigravity, Codex CLI, etc.) must **read this file at the start** of any task and **update it at the end**, following [AI_RULES.md](AI_RULES.md) and [AGENTS.md](AGENTS.md).

## Current Status
- **Last updated:** 2026-11-25
- **Agent:** Antigravity
- **Local checkout:** `main` @ `a3b4574` (*Document agreed beta.13 registration and naming design*, `2026-11-25 16:21:07 UTC`) — contains **14.0.0-beta.12** plus beta.13 design in [DECISIONS.md](DECISIONS.md).
- **Remote active dev branch:** `origin/beta13-registration-dev` @ `516d7db` (*Mark beta.13 branch experimental and link validated checkpoint*, `2026-11-25 16:51:56 UTC`) — contains **14.0.0-beta.13-dev.2** (`BETA13_PROGRESS.md`, `Tests/13_Registration.wl`, `Examples/Beta13_Proca.wl`).

## Context from ChatGPT (Chronological Summary & GitHub Comparison)
Two ChatGPT exports cover the full evolution and match the current GitHub state:
1. **Chat 1 — *Mejorar y terminar Xplorer* (`2026-11-06 17:17` – `2026-11-25 15:47`):**
   - Evolved the codebase from `xPlorer_v13.wl` -> `v14` (`beta.2`) -> `beta.7` (tag `v14.0.0-beta.7` @ `f91015b`: `PrintAs` inheritance, readable contexts/heads, `DisplayExpression`/`SetNotation`, multiple connections, `DeletionPlan`/`DeleteBackgroundObject`, `ReconstructionData`/`RecreateBackground`, `SaveResult`/`ResultOf`, paclet/application layout) -> `beta.9`–`beta.11` (auto aliases like `EabSchw`, two charts on Minkowski with `OutputChart`, `ScreenDollarIndices` enabled automatically, one-instruction-per-line didactic notebook, theme-inherited light/dark styles, `boxes$` fix, interactive `Input` cells) -> **`beta.12`** (merged to `main` via PR `#2` `05b0b40`: `CreateBackground` auto-assigns suffixed notebook aliases like `gSchw`, `CDSchw`, `phiSchw`, `aSchw`; 115 workflow cells, 250 package tests reported in chat).
   - At `2026-11-25 15:33–15:47`, agreed on the breaking `beta.13` redesign direction (captured in [DECISIONS.md](DECISIONS.md) @ `a3b4574`): remove legacy positional field syntax, infer metadata from xAct, use `Name` / `SymbolBase` / `PrintAs`, add `Lagrangians` & `Expressions` collections, and add cross-cutting `Sector` metadata.
2. **Chat 2 — *Diseñar beta13 de xPlorer* (`2026-11-25 16:29` – `2026-11-25 16:52`, most recent):**
   - Finalized `beta.13` registration design: native `xTensor` inspection (`SlotsOfTensor`, `SymmetryGroupOfTensor`, `DependenciesOfTensor`, `WeightOfTensor`, `Dagger`, `PrintAs`), `HoldAll`/`HoldComplete` RHS symbol preservation (`"Gravity" -> Lgrav` -> `LgravSchw`; `Head -> "Ltotal"` required for anonymous formulas), `TheorySector`, automatic `xPert` `DefMetricPerturbation` detection, and zero-weight Lagrangian checks.
   - Implemented **14.0.0-beta.13-dev.1 / dev.2** on GitHub branch **`origin/beta13-registration-dev`** (`b5d3de6`..`516d7db`), matching the exact state on GitHub:
     - `Tests/13_Registration.wl`: 45/45 registration/lifecycle + 37/37 registration/Schwarzschild (49 distinct assertions, after fixing `FindFreeIndices` `HoldFirst` with `With`).
     - `Examples/Beta13_Proca.wl`: Einstein-Proca Schwarzschild test (`A_t = r^2`, residual `{0,0,0,0}`).
   - **Still open on `beta13-registration-dev`:** migrating `xPlorer_Workflow.nb` (still beta.12), updating `API_GUIDE.md`, `ScalarTheory.wl`, legacy 196-assertion regression, `ShowTheory[]` public logical view, and validating density/extra-bundle rejection, full perturbations, FLRW, and additional connections.

## Local Changes
- Created [AI_RULES.md](AI_RULES.md) with the mandatory `HANDOFF.md` read/update protocol, the rule to always commit and push validated work, and the local Wolfram 15.0.1 invocation path.
- Created [AGENTS.md](AGENTS.md) linked to `AI_RULES.md` and `HANDOFF.md`.
- Updated this `HANDOFF.md` with the chronological ChatGPT synthesis and GitHub branch comparison.

## Tests & Verification
- Verified `git branch -a` and `git log --all` in `d:\Projects\Dev\xPlorer`; read `DECISIONS.md` on `main` and `BETA13_PROGRESS.md` on `origin/beta13-registration-dev`.
- Verified local Wolfram Language `15.0.1` (`D:\Archivos de programa\Wolfram Research\Wolfram\15.0\wolfram.exe`) with `xAct` (`xTensor 1.3.0`, `xPerm 1.2.4` + MinGW) and `xPlorer.wl` loading. Full package/notebook regression suites have not yet been rerun locally here.

## Blockers / Open Questions
- Local working tree is on `main` (`beta.12`), whereas active `beta.13` code lives on `origin/beta13-registration-dev` (`516d7db`).

## Concrete Next Step
1. To continue `beta.13` implementation, switch to `beta13-registration-dev` (and bring `AGENTS.md`, `AI_RULES.md`, `HANDOFF.md` if desired), read `BETA13_PROGRESS.md` and `DECISIONS.md`, and proceed with `ShowTheory[]` public view, notebook migration (`xPlorer_Workflow.nb`), and local Wolfram/xAct regression testing.

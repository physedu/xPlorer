# AI_RULES.md - Shared Rules Across AI Agents

This file defines the mandatory continuity rules for any AI coding agent working in this repository (**Antigravity**, **Codex CLI**, etc.) and is linked from [AGENTS.md](AGENTS.md).

## Mandatory Handoff Protocol ([HANDOFF.md](HANDOFF.md))

1. **At the start of every task (mandatory):**
   - Read [HANDOFF.md](HANDOFF.md) and [AGENTS.md](AGENTS.md) before editing files or making repository changes.
   - Check `git status`, current branch, and recent commits so you work against the real repository state.
   - For package or notebook tasks, also read [PROGRESS.md](PROGRESS.md), [DECISIONS.md](DECISIONS.md), and [DEVELOPMENT_PLAN.md](DEVELOPMENT_PLAN.md).

2. **During the task:**
   - Preserve user changes and follow repository standards (including English ASCII prose for delivered package/notebook sources).
   - Never fabricate test results, environment checks, or progress.

3. **At the end of every task (mandatory):**
   - Update [HANDOFF.md](HANDOFF.md) before finishing, recording:
     - **Date and agent used** (Antigravity, Codex CLI, ChatGPT, etc.).
     - **Goal and summary of changes** (files created/modified).
     - **Checks/tests actually run** and their exact results (or what remains unverified).
     - **Key decisions, blockers, or open questions**.
     - **Concrete next step** so the next agent can resume seamlessly without losing context.
   - **Always save work to Git / GitHub:** commit and push validated changes (including `HANDOFF.md`, code, tests, and docs) on the active working branch after each meaningful block or task so nothing is lost when switching agents or sessions. Never rewrite history or use `push --force`, and keep experimental work off `main` until validated. If a push fails, keep the local commit and document the pending push in `HANDOFF.md`.

## Local Wolfram / xAct Execution Note (Windows)
- On this machine, `wolframscript` may point to a stale `14.3` path. Run Wolfram Language **15.0.1** with **xAct 1.3.0** directly via:
  `"D:\Archivos de programa\Wolfram Research\Wolfram\15.0\wolfram.exe" -noprompt -run ...` (or `-script ...`).

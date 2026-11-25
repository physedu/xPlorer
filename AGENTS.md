# AGENTS.md - Agent Instructions for xPlorer

> **Mandatory Continuity Rule ([AI_RULES.md](AI_RULES.md)):** Always read [AI_RULES.md](AI_RULES.md) and [HANDOFF.md](HANDOFF.md) **at the start** of every task, and always update [HANDOFF.md](HANDOFF.md) **at the end** of every task so the user can switch between **Antigravity** and **Codex CLI** without losing context.

## At Task Start
1. Read [AI_RULES.md](AI_RULES.md) and [HANDOFF.md](HANDOFF.md) first.
2. Check `git status`, current branch, and recent commits.
3. Read [PROGRESS.md](PROGRESS.md), [DECISIONS.md](DECISIONS.md), [DEVELOPMENT_PLAN.md](DEVELOPMENT_PLAN.md), and [IMPLEMENTATION_PROMPT.md](IMPLEMENTATION_PROMPT.md) before modifying package code, tests, or notebooks.

## During Task Execution
- Preserve existing user edits and commits; never rewrite history or force-push.
- Follow the project constraints in [DEVELOPMENT_PLAN.md](DEVELOPMENT_PLAN.md) and [IMPLEMENTATION_PROMPT.md](IMPLEMENTATION_PROMPT.md) (English ASCII for delivered package/notebook prose, separate tests, honest reporting of tested vs. untested environments).

## At Task End
1. Update [HANDOFF.md](HANDOFF.md) per [AI_RULES.md](AI_RULES.md) with date, agent used, summary of changes, actual verification results, open blockers/questions, and the concrete next step.
2. When completing a significant validated milestone, update [PROGRESS.md](PROGRESS.md), [DECISIONS.md](DECISIONS.md), or [CHANGELOG.md](CHANGELOG.md) as appropriate.

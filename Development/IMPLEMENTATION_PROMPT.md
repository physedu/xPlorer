Current checkpoint: 14.0.0-beta.7 implements stages 1-7 within the documented supported scope. Read PROGRESS.md first and resume only remaining work; do not automatically reimplement completed stages.

# Resume and implementation instruction

Work autonomously on physedu/xPlorer. First read DEVELOPMENT_PLAN.md, DECISIONS.md and PROGRESS.md at the current repository head. These files are the detailed specification and recovery record. Inspect the real source and preserve newer user changes; do not assume an attachment is the latest version. Resume the next incomplete stage rather than repeating completed work.

Implement the agreed seven-stage plan: baseline compatibility; inherited presentation and readable names; optional notation; dependency-aware cleanup/deletion; multiple abstract connections; general connection components, rule management and invalidation; final applied notebook and distribution. The documents define requirements, acceptance criteria and limits. Resolve routine implementation choices and record them; ask only when an unresolved decision materially changes scope or compatibility.

Keep the simple Get workflow and existing useful calls. Personalization must be optional with coherent defaults. Preserve source xAct presentation automatically where supported and permit explicit overrides. Separate display from mathematical properties and do not modify unrelated xAct behavior globally. Do not silently ignore unsupported options or claim compatibility without evidence.

Use small development tests and meaningful regressions per stage. Validate default behavior as well as advanced options. Fix failures before layering dependent features. Record the actual environment, results and limitations, distinguishing previous evidence from newly executed checks. Do not claim front-end rendering or performance gains without testing them.

Deliver the package and one principal didactic notebook, executed end to end, with technical tests kept separately. Preserve the physicist's abstract-theory-to-background-to-components narrative on Minkowski, Schwarzschild and FLRW, with explanations alongside each function. Explain Xplorer, xAct and Mathematica responsibilities in context. Avoid complicated startup cells and visible test dashboards. Use English ASCII text, native mathematical boxes and theme-inherited colors.

GitHub commits and pushes for this development are authorized. After every important completed and validated block, update the plan/decisions/progress as needed, create a descriptive commit and push it. Preserve earlier versions through Git history and tag validated version milestones appropriately; beta versions remain beta. Do not create a release for every minor edit. Never rewrite history or force-push. Do not upload secrets, temporary files or unnecessary bulky results. If pushing fails, retain a local commit and state the pending action.

Every checkpoint must allow another session to resume from the repository if the conversation stops or tokens run out. Keep progress updates brief, avoid regenerating the full notebook after every small change, and prioritize correctness, simple default use and efficient context consumption. Continue through the authorized plan without asking permission at every stage.

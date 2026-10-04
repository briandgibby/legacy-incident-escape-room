# Working on Legacy Incident Escape Room

## Start and preserve context

Read `SESSION_CONTINUITY.md`, the relevant PRD/spec sections, and the next implementation slice before changing anything. Inspect the working tree. Preserve existing uncommitted work; never reset, stash, delete, or overwrite it without explicit authorization. Current code and verification establish what exists; label future ideas as proposals. `HANDOFF.md` is historical context, not the current task list.

## Product intent and invariants

Build a fun, thought-provoking, educational escape-room game about real debugging and an oppressive workplace. Players should discover memorable, unsettling lessons through evidence, choices, and consequences. Educational effectiveness and lasting impact are hypotheses to test with players, not claims to assume.

The tone is dystopian absurdism. Escaping an ordinary level means earning the right to go home for the night. After every completed shift/stage, the player can quit or continue employment into the next workday's level, regardless of repair/refusal route. Refusing an assignment is distinct from resigning. Multiple endings are required; their exact conditions and resignation aftermath remain open. Indubitably, a fictional job/networking app, conveys fear that a quitting black mark will harm prospects and helps explain choosing to return. Its interactivity and specific consequences remain open.

Focus current delivery on the established story. Pirates-style retirement/accomplishment scoring is deferred; a later puzzle-pack product is only a conditional possibility. The next authorized implementation session establishes the first level's connected break room, elevator area, and long corridor to the exit. Follow `docs/CONTINUATION_PROMPT.md` and the spatial slices in the plan; settle consequential layout/elevator behavior before implementing it. Physical access does not itself implement nightly release or campaign endings.

Preserve the user's envisioned candidate ending: smoking-gun evidence including murder reaches fictional authorities, Rifkin closes, and the publicly celebrated player faces unemployment and rejection by similarly abusive employers, subtly questioning the personal cost. This is one proposed ending, with conditions and alternatives unresolved. Successful exposure still changes events; do not silently undo the shutdown or present fictional hiring practices as real-world facts.

Teaching how to construct a program is an explicit product goal, beyond syntax and repairing bugs. Proposed lessons should connect requirements, examples, responsibilities, incremental implementation, verification, and change. Evaluate understandable behavior and justified choices; do not impose one architecture as universally best or make construction exercises an undisclosed requirement of the refusal route.

Initially teach players who can write basic code but need help organizing programs. Defer absolute beginner lessons until the core game's functional skeleton provides a baseline. The exact baseline and curriculum still need decisions.

Optional practice mode is under feasibility investigation: players would create environments and build/run real apps outside the story using the game's reference and guidance. Preserve the distinction between research, a runnable proof, and approved delivery. Project folders and package environments do not establish OS isolation. Runtime, app types, persistence, preview, and practice assistance remain undecided; this investigation authorizes no installations or gameplay implementation.

Preserve meaningful repair and refusal routes. Both must let players escape the first post-tutorial scenario; refusal must not require repairing the code. Each route supplies distinct notable puzzle clues and evidence of company crimes, with gameplay and narrative consequences. Required clues for a chosen route cannot depend on taking the opposite route. Exact mechanisms remain subject to the living specification.

Open the game with the character signing an employment agreement and an NDA whose absurdly abusive terms use reassuring corporate language. The refusal route's physical records subtly connect employee murders to threats to break NDAs and expose the company. Preserve the distinction between accepted story facts and player discoveries; do not automatically explain these clues. Signing is a fictional game action, not real player consent.

Early employee-messenger rumors establish suspicion before confirmation. Preserve the inherited-login first mission and IT's wipe/personal-account handoff before mission two. The messenger only appears outside Panopticon's view until its actual coverage is decided. Keep the core story consistent across difficulty-specific Joel personas; distinguish employee allegations from established story facts.

The incident repository is intentionally broken. Never turn its starting puzzle into passing production code as routine maintenance. Players fix their sandbox. The helper offers evidence, questions, and explanations; it must not write or reveal the solution.

The apparent LLM helper is Dantalion, intentionally named for the Ars Goetia demon. The player uses a very limited fictional free subscription; completing investigative tasks is a prerequisite for earning credits and refreshing allowance. Exact quotas and qualifying milestones remain design decisions; the name does not authorize a real AI service or new dependency.

## Minimal-change engineering

- Solve only the requested problem with the smallest correct change. Preserve behavior outside scope.
- Follow existing architecture, patterns, naming, dependencies, and control flow. Extend the closest existing implementation.
- Add no abstractions, layers, frameworks, dependencies, configuration, generalized utilities, compatibility shims, or broad refactors unless required or the existing design makes the change impossible.
- Handle edge cases supported by requirements, reproducible failures, existing contracts/tests, or demonstrably reachable states. Trust enforced types, validation, constraints, and documented invariants.
- Investigate the affected code, closest analogue, and relevant tests; stop once evidence is sufficient. Ask one focused question when uncertainty materially affects public behavior, architecture, dependencies, or scope. Otherwise state the simplest consistent assumption.
- Before materially expanding beyond the affected module, adding a dependency, or creating a public abstraction, explain why the smaller approach is insufficient and wait for approval.
- Avoid unrelated cleanup, hardening, migrations, and performance work. Use a brief plan for straightforward work. Create no planning documents, worktrees, commits, or other artifacts unless requested or genuinely necessary.

## Test-driven delivery

For new behavior and bug fixes, write a focused test, run it, and observe failure for the intended reason. Implement the smallest passing change. Refactor locally only when needed and safe; rerun relevant regression checks. Cover requested behavior and credible regressions, without impossible-state matrices or duplicate coverage. Never discard existing user work to reconstruct a test-first history.

These are practical applications of [Kent Beck's TDD cycle, explained by Martin Fowler](https://martinfowler.com/bliki/TestDrivenDevelopment.html), and [Fowler's YAGNI guidance](https://martinfowler.com/bliki/Yagni.html): test the next needed behavior, keep changes small, and defer speculative capabilities. These are paraphrases, not quotations.

Documentation and visual assets need appropriate review and visual checks, not meaningless tests. Existing gameplay checks run from the repository root:

```powershell
godot --headless --path godot --script res://tests/gameplay_integration.gd
godot --headless --path godot --script res://tests/surveillance_integration.gd
```

Keep integration checks isolated from player saves. Prove solvability in a disposable sandbox. Starting-state `npm test` and `npm run simulate` failures in `incident_repo` are expected puzzle behavior, not regressions.

## Documentation responsibilities

Keep these documents useful and proportional to the change:

- `docs/PRD-legacy-incident-escape-room.md`: WHY, intended audience, outcomes, scope, and learning goals in plain language. Update when these change.
- `docs/PRS-legacy-incident-escape-room.md`: HOW, technical behavior, interfaces, state, constraints, and acceptance checks. Distinguish verified implementation, accepted requirements, proposals, and open questions.
- `docs/decisions/`: consequential HOW/WHY choices, sources, alternatives, and consequences. Recorded ADRs are immutable: never edit, renumber, or delete them, including status corrections. Record changes or reversals in a new numbered ADR referencing the predecessor; update the index and living specification to show the effective decision. Do not invent approval.
- `docs/IMPLEMENTATION_PLAN.md`: phased vertical slices, each delivering a playable behavior with relevant validation. Update affected slices as requirements change.
- `SESSION_CONTINUITY.md`: concise current state, next action, blockers, and recent verification. Keep only useful recent session entries and references to durable detail.

Use stable requirement IDs when linking requirements, slices, and checks. Retain the current desktop stack unless an authorized change requires otherwise; `docs/GODOT_SETUP.md` documents setup.

## Finish and learn

After a slice, identify one evidence-backed process improvement, try it in the next slice, and retain or revise it if useful. Avoid ritual paperwork. Work is complete when requested behavior works, relevant checks pass, and the diff contains no unrelated changes. Report what changed, verification and limits, and what intentionally stayed unchanged; update only the documents affected.

# Session Continuity

Last updated: 2026-10-04 (America/New_York).

## Resume here

Documentation through the building continuation was committed and pushed to `origin/main` as `d7b454f`. The subsequent elevator/dogs/movement documentation remains uncommitted and was preserved. Spatial slices 0.2–0.4 are now implemented and verified in the working tree; no commit or push was made. Read [AGENTS.md](AGENTS.md), the [product specification](docs/PRS-legacy-incident-escape-room.md), [ADR-0021](docs/decisions/0021-bounded-elevator-transfer-and-first-level-layout.md), and the [phase plan](docs/IMPLEMENTATION_PLAN.md).

Next action: settle the separate D-17 controller contract before slice 0.5 and dog-evasion tuning. The user completed the office → break room → elevator → lower corridor → exit and return with mouse/keyboard and confirmed it worked. Reported elevator doorway texture fighting is corrected in the rebuilt asset; restart the open game to load it. D-15's bounded layout/transfer is recorded in ADR-0021. Choose the elevator puzzle under D-16 before 3.2a; the maintenance-exception sequence remains proposed. If caught, return to the corridor entrance and restore the snack if used; retry clocks and other state details remain open. The secret movement room, retirement scoring, campaign outcomes, and practice delivery remain outside this spatial implementation.

## Accepted direction

- The game should be fun, thought-provoking, and educational. Players and the development process should improve through evidence, experiments, and reflection.
- Explicitly teach how to construct a computer program, beyond syntax or fixing a provided bug. Start with players who write basic code but struggle with program structure. Defer absolute beginner lessons until the core game's functional skeleton provides a baseline; curriculum, first exercise, and exact baseline remain open.
- Investigate optional practice outside the story: player-created environments for real apps, using game documentation and guidance. This authorizes a feasibility investigation, not an implementation or selected runtime.
- Keep the first-person, unsettling Rifkin Software office, real coding incidents, unseen Joel, and Panopticon pressure.
- Dystopian absurdism: each ordinary escape earns going home for the night; the next workday is the next shift/level. Refusing the assignment is distinct from resigning.
- Several endings are required. After every completed shift/stage, the player can quit or continue employment, on either repair or refusal route. Controls, outcome conditions, and post-quit reporting remain open.
- Focus on the established story. Pirates-style retirement/accomplishment scoring is deferred; a later puzzle-pack product is only a conditional possibility. The connected break room, bounded descending elevator, and long exit corridor now establish the spatial baseline; puzzles and nightly release remain later work.
- The refusal route descends through an elevator puzzle to a dog-guarded exit corridor. A reserved break-room snack is an alternative to movement evasion. If caught, return to the corridor entrance and restore the snack if used; exact puzzle, snack, dog, and remaining retry details are open.
- Movement should resemble Quake 3 Arena, with strafe jumping for acceleration. A later secret room uses jump pads and progressively harder defrag-style movement courses. Enormous rooms within the building's narrow footprint are deliberate surreal architecture. This optional movement minigame is distinct from real-app practice.
- Indubitably, a fictional job/networking app, conveys career pressure: the character fears quitting's black mark will hurt future prospects. Exact interactivity and consequences remain open.
- Preserve the envisioned candidate ending: smoking-gun wrongdoing/murder evidence reaches fictional authorities and closes Rifkin; the public hero then loses income and is rejected by similarly abusive employers, subtly wondering about the personal cost. This is not the sole or fully specified ending.
- Provide viable **repair and refusal** escape routes. Each reveals different notable puzzle clues and evidence of the company's crimes. Refusal does not require repairing the incident.
- Open with the character signing an employment agreement and an NDA with absurdly abusive terms expressed as nicely as possible. Refusal-route physical records subtly connect murders of employees to threats to violate their NDAs and go public. These are accepted author-level story facts; player discovery stays gradual.
- Suspicion begins in old employee-group messages during mission one: coworkers discuss missing employees and unusual turnover. The employee-established messenger seems outside Panopticon's view, but its exact observation limits remain open.
- The first workstation retains someone else's logged-in accounts. Before mission two, IT wipes it and finally gives the player personal work email access and credentials. Wipe disclosure, scope, and notebook retention are not decided.
- Joel differs by difficulty while the core story remains the same. Easiest: talented, overbearing senior engineer, vocal AI disdain, consequences for Panopticon-detected helper use. Hardest: incompetent nepotism hire guarding his privilege, with rumors of unwanted advances toward women and elevated female-staff turnover. Medium persona and exact penalties remain open.
- The apparent LLM helper is Dantalion, intentionally named after the Ars Goetia demon. The player relies on a very limited free subscription; investigative tasks are a prerequisite for earning credits and refreshing usage. Quotas and exact milestones remain open; no real AI integration is authorized.
- Separate plain-language product purpose from technical behavior. Record durable why/how decisions in immutable ADRs.
- Use TDD for behavior changes, manageable vertical slices, and an evidence-based process review after each slice.
- The borrowed drive is a promising design direction. Its exact behavior is not approved. Teach manual notebook responsibility in the tutorial and stop automatically identifying important clues afterward. Keep hints optional and technical reference neutral.

Accepted decisions/directions: ADR-0001 through ADR-0020 in the [index](docs/decisions/README.md). ADR-0012 accepts exploration only; ADR-0014 records a candidate ending; ADR-0015 settles multiple endings/quitting; ADR-0016 defers retirement scoring; ADR-0017 scopes the building session; ADR-0018 clarifies refusal descent and dogs/snack; ADR-0019 records movement/surreal-room direction; ADR-0020 chooses local caught-player retry and snack restoration. ADR-0021 records the agent's implemented layout choice within that authorization.

## Current implementation

Gameplay baseline: `c243f21`; current HEAD is documentation commit `d7b454f` on `main`. Existing uncommitted documentation was preserved during the spatial implementation below. Current code/assets and checks establish the implemented state.

- One checkout incident uses real JavaScript tests and a production replay. Its shipped source deliberately fails the migrated coupon case.
- Panopticon reacts to workstation and room actions with alerts, eyes, and sounds. It does not yet enforce detection consequences or support bypasses.
- Clues currently mark themselves discovered when opened. There is no manual notebook, complete escape outcome, capped workload progression, or searchable technical reference.
- Agreement signing and the new physical disclosure/murder records are requirements, not implemented content.
- Employee messenger, IT handoff, difficulty personas, and helper-detection sanctions are also unimplemented.
- Nightly shift release/next-day campaign progression, Indubitably, resignation outcomes, and the candidate exposure ending are unimplemented.
- The existing helper remains a fixed local hint ladder. Dantalion branding, usage limits, and task refresh are not implemented.
- The workstation supports editing supplied incident code, not a dedicated construction curriculum or general test/file authoring surface.
- Practice has no implementation. The batch runner blocks until exit; a long-running app needs owned execution and stop/log/preview controls. Incident copies reset on startup, so practice storage must be separate. Docker CLI `29.6.2` was observed, but the `desktop-linux` engine connection failed; no container was started or image downloaded.
- The incident clock continues in the room and after deployment acceptance. Expiry does not prevent solving. Existing score penalizes elapsed time, hints, and tests and rewards opened clues.
- The north staff door opens once into a modest break room and upper elevator lobby. Matching static cabs provide one 6 m descent/return with a brief fade, preserving view/horizontal position and clearing velocity. The lower landing connects to a 52 m by 3.6 m corridor and solid recognizable exit. Camera far range is 90 m. No shift/route outcome follows arrival.
- Movement remains fixed-speed WASD with gravity and mouse look; no jumping, strafe acceleration, or jump pads exist. Elevator puzzle gates, inventory/snack, dogs, and the secret movement room are absent. The existing GLB/mesh-name collision and local raycast pattern handles the new spaces without another framework.
- Stack: Godot 4.7 standard/GDScript, local Node ES modules/`node:test`, SQL evidence, and existing Python/Blender assets. Node is unpinned; observed local version is `v25.9.0`. The `godot` alias was unavailable in this shell. Use existing setup/launcher guidance before future engine checks.

## Open decisions

The specification tracks D-01 through D-17. D-15's spatial choice is implemented and verified by scripted traversal, rendered views, and the user's successful manual round trip. D-16 covers the elevator puzzle, dog/snack behavior and recovery beyond the accepted local retry; D-17 covers controller tuning/teaching and later movement courses. Other established gates remain in the spec. Resolve only gates relevant to the slice being built.

“Release Pending,” voluntary-shift record edits, the specific disclosure/management/death documents, and sample NDA wording remain proposed content. Company murders in retaliation for threatened NDA breaches and public disclosure are accepted story facts. Victim identities, individual perpetrator, methods, and precise chronology remain undecided. Neither route needs the opposite route's exclusive clues. Collecting every record cannot gate escape. Optional fuller-investigation goals and route switching remain undecided.

Proposed medium Joel: once-capable engineer turned insecure manager, relying on dashboards and approvals while protecting his image. Private AI use and a capped review consequence are suggestions, not accepted facts. Strongest mode's harassment allegations remain rumors; do not automatically equate them with the murder explanation. Keeping a fixed persona per run, separate from workload tiers, is also a proposal.

Accepted Dantalion task category: investigation. Proposed credit model: accessible milestones restore a capped allowance without resetting hint progression or surveillance records. Exact limits, repetition credit, and handoff/difficulty persistence remain open. Unrelated Dantalion chores are outside the selected initial model. Avoid a loop where the task required to earn help is the puzzle the player needs help solving.

Proposed construction method: requirements/examples, responsibility boundaries, one runnable slice, test-first implementation, and a later change to expose design consequences. This curriculum is unaccepted. The developer's TDD requirement does not itself prove player learning. Direct construction practice must not become mandatory incident repair on the refusal route.

Indubitably's first readable interaction, numeric career mechanics, applications, choice controls, rejection copy, and home presentation are unchosen. Quitting is available after every completed stage regardless of route/evidence; no forced return follows resignation. Several endings are required, but their identities and post-quit reporting remain open. Smoking-gun proof/authority-driven shutdown define the candidate exposure ending; evidence sufficiency and chronology remain D-14. Nightly exit and resignation eligibility require neither final exposure nor all crime records. No real job platform or authority is contacted.

Pirates!/Pirates! Gold retirement inspiration is now deferred under ADR-0016. Preserve the authored story, multiple endings, and post-stage quitting without designing a retirement assessment. Do not use the current incident score as a campaign-ending contract. Heroic exposure can still coexist with poor hiring prospects in the candidate ending.

Practice research recommendation: first prove one local JavaScript web app with a container-backed runtime, separate durable project/data storage, explicit run/stop, and a real preview. Backend and app type remain unaccepted. Browser Node is an alternative; embedding, native-addon compatibility, licensing, and offline boot need proof. Direct host execution or Python package isolation does not establish OS confinement. Practice assistance is undecided; Dantalion credits still require investigation unless a successor decision changes it. No runtime benchmark or executable prototype exists.

## Session record

### 2026-10-03 — Discussion and documentation

- Briefly inspected the current office, Panopticon, incident, hints, scoring, and integration tests without altering them.
- Compared linked incident/escape play, work-as-stealth-cover, and bureaucratic loopholes. Recommended a linked loop with discoverable rule exceptions.
- User requested the documentation set and chose both escape routes with distinct puzzle and crime evidence.
- Created the requested project guidance, requirements, technical specification, ADRs, phase plan, and this continuity file. Existing `HANDOFF.md` remains historical setup context.
- Cross-document review added a bypass/recovery tutorial slice and removed a compulsory-note condition. It clarified that optional fuller-investigation goals cannot override independent escape routes.
- Verification: documentation links, capability coverage, decision statuses, and change scope reviewed. No engine or incident tests were run for this documentation-only change. No commits, dependencies, or gameplay/assets changes were made.
- Process lesson: preserve uncertainty explicitly instead of encoding proposals as accepted mechanics. Revisit this practice after the first implemented slice.

### 2026-10-03 — NDA opening and retaliatory murders

- User established agreement signing at the opening and subtle refusal-route physical clues about employees murdered after threatening NDA breaches and public disclosure.
- Added ADR-0005 without changing earlier ADRs. Updated product guidance, G-10, the specification, and plan slices 1.0 and 3.2. Kept exact clauses and evidence objects proposed.
- Verification: local document links, G-01 through G-10 coverage, unchanged earlier ADR hashes, and code/asset scope checked. No gameplay tests, implementation, dependencies, or commits.
- Design lesson: distinguish a story fact known to its authors from an inference the player earns through evidence. Next: refine the opening agreement text and signing interaction.

### 2026-10-03 — Messenger breadcrumbs, IT handoff, and Joel variants

- User chose suspicion first through old employee-group messages, then a workstation wipe and personal accounts before mission two.
- User defined easiest and hardest Joel personalities with a shared underlying story, leaving medium Joel and penalties for discussion.
- Added ADRs 0006/0007 and G-11/G-12; updated the specification and vertical slices for reading messages, the handoff, and one persona variation. Proposed medium Joel remains unaccepted.
- Verification: document links, requirement coverage, prior ADR hashes, and documentation-only scope checked. No gameplay tests, implementation, dependencies, or commits.
- Design lesson: apparent privacy, actual observation coverage, and irreversible evidence loss need separate explicit contracts. Next: choose medium Joel and discuss the messenger/wipe rules.

### 2026-10-03 — Dantalion's free-plan allowance

- User named the apparent LLM Dantalion and specified a very limited free subscription whose usage resets through completed tasks.
- Added ADR-0008 and G-13; refined G-07 and added a vertical hint-use/exhaustion/task-refresh slice. Quotas, task type, and exact rules remain proposals. No real AI service is implied.
- Verification: document links, G-01 through G-13 coverage, prior ADR hashes, and documentation-only scope checked. No gameplay tests, implementation, dependencies, or commits.
- Design lesson: preserve a reachable way to earn help before its corresponding bottleneck, and review scarcity together with surveillance consequences. Next: choose the reset-task model.

### 2026-10-03 — Investigation-earned credits and construction learning

- User accepted investigation as the prerequisite for Dantalion credits and made teaching program construction an explicit goal.
- Added ADRs 0009/0010, refined G-13, and added G-14 plus a scoped construction/change exercise slice. Curriculum and exact credit mechanics remain proposals.
- Verification: document links, requirement coverage, prior ADR hashes, and documentation-only scope checked. No gameplay tests, implementation, dependencies, or commits.
- Design lesson: successful debugging is not sufficient evidence of program-design understanding; test transfer through a changed requirement. Next: choose the learner's starting skill level.

### 2026-10-03 — Initial audience and practice feasibility

- User chose basic coders as the initial audience, deferring beginner fundamentals until the core skeleton supplies a baseline, and requested a real-app practice-mode spike.
- Added immutable ADRs 0011/0012, G-15, D-12, the [research report](docs/spikes/2026-10-03-practice-mode-feasibility.md), and a conditional practice slice. Researched primary runtime sources and inspected existing editor/runner/reset behavior.
- Read-only Docker version probe found the CLI but no reachable engine. No container, app, prototype, download, or gameplay test was run. Runtime and in-game preview remain unproven. Verification passed for 19 documents, 62 local links, capability coverage, formatting, unchanged prior ADR hashes, and no tracked-code changes.
- Design lesson: a copied folder, package environment, isolated runtime, and full virtual machine make different promises. Choose the first app type before committing to infrastructure. Next: decide the practice app scope.

### 2026-10-04 — Planning depth and remaining choices

- User asked which decisions remain and whether to plan every level now. Reviewed the current scope and decision gates without inspecting additional game code.
- Recommendation: outline campaign learning/revelation beats now, detail the tutorial and one complete scenario, and refine later puzzles after observing the core loop. This recommendation remains unaccepted.
- Next question: define early mission escape versus permanent campaign escape, so independent repair/refusal routes and the IT handoff form a coherent progression. Practice scope remains open. No new ADR or implementation decision.
- Verification: continuity-only update; earlier ADRs and gameplay files remain untouched. No gameplay tests are appropriate for this discussion record.

### 2026-10-04 — Dystopian shifts, Indubitably, and exposure aftermath

- User established nightly release/next-day shifts, dystopian absurdism, and Indubitably career pressure explaining continued attendance. User envisioned a shutdown ending with lost income and rejection after public heroism.
- Added immutable ADRs 0013/0014, G-16/G-17, D-13/D-14, and affected shift/interlude/Indubitably plan details. Retained the finale as a candidate and kept nightly release distinct from resignation and campaign completion.
- Verification passed: 21 documents, 68 local links, capability coverage, formatting, unchanged prior ADR hashes, and no tracked-code changes. Independent review found no consequential contradictions. No gameplay tests, dependencies, or commits.
- Design lesson: a shift's local victory and the wider employment trap can both have lasting consequences. Next: decide quitting agency, then develop the first shift's concrete loop.

### 2026-10-04 — Several endings and post-stage resignation

- User chose several endings and a genuine option to quit after every stage. Added immutable ADR-0015, refined G-16/G-17 and D-13/D-14, and added one scoped resignation/continuation slice.
- Shift completion, employment choice, and ending outcome remain separate. Quitting availability is accepted; consequences, ending conditions, and reporting after quitting remain open.
- Verification passed: 22 documents, 71 local links, capability coverage, formatting, unchanged prior ADR hashes, and no tracked-code changes. No gameplay tests, dependencies, or commits.
- Design lesson: career pressure can motivate continued employment while resignation remains actionable. Next: decide whether retained evidence can still be reported after quitting.

### 2026-10-04 — Pirates-inspired accomplishments and epilogues

- User suggested Pirates!/Pirates! Gold retirement as an inspiration and asked how to translate it. Verified the original Gold manual's retirement model through its publisher-distributed PDF.
- Recorded three proposed assessment approaches and a recommendation in the PRD/spec, preserving multiple endings and the candidate exposure aftermath. No scoring formula, assessment model, or new ADR was accepted.
- Verification passed for affected-document links, formatting, proposal labeling, and no tracked-code changes. Existing ADRs were untouched. No gameplay tests, dependencies, or commits.
- Design lesson: accumulated accomplishments can shape several consequences without implying one universally better moral/career outcome. Next: choose departure/disclosure agency before defining outcome conditions.

### 2026-10-04 — Story-first wrap-up and building continuation

- User deferred Pirates-style retirement scoring, retained the original story outline, authorized commit/push, and requested a new-session prompt to build the first level's break room, elevator, and long exit corridor.
- Added immutable ADRs 0016/0017, G-18/D-15, spatial slices 0.2–0.4, and the [continuation prompt](docs/CONTINUATION_PROMPT.md). Multiple endings and post-stage quitting remain intact. Layout/elevator circulation is the next focused choice; other mechanics stay in their later slices.
- Verification passed: 25 documents, 82 local links, requirement coverage, formatting, all 17 ADR/index entries, all 15 previous ADR hashes unchanged, and no gameplay/asset changes. Independent review found no actionable contradictions. No runtime tests were run for documentation. Commit/push results are reported in the session response and can be verified through Git history.
- Process lesson: inspect passage geometry before planning door behavior; the existing service door hides a solid wall. Next session must validate a real opening and complete walking route, then retain a concrete improvement from that slice.

### 2026-10-04 — Refusal descent, dogs, movement, and impossible space

- User developed a descending elevator puzzle for the refusal path, dog-guarded exit corridor, and reserved break-room snack as an alternative to movement evasion. Button-order code remains a proposed mechanism. User selected corridor-entrance retry and snack restoration if caught.
- User reiterated Quake 3 Arena-like strafe-jump acceleration and a later secret room with escalating jump-pad/defrag-style courses. Huge interiors within a narrow exterior are intentional. Added ADRs 0018–0020, G-19/G-20, D-16/D-17, and separate controller/encounter/later-room slices; updated the continuation prompt to stop re-asking whether the elevator descends.
- Current player code has no jump/air-acceleration logic; no dog/snack/elevator/minigame behavior exists. Inspected only relevant local surfaces and the original Quake movement source. No gameplay, asset, dependency, commit, or push changes in this discussion.
- Verification passed: 28 documents, 91 local links, formatting, G-01 through G-20 coverage, 20 ADR/index entries, and all 17 earlier ADR hashes unchanged. Independent review found one stale open recovery question; narrowed it to remaining clock/state and wasted-snack details. No runtime tests were needed for this documentation change.
- Design lesson: local recovery makes movement experiments practical while the snack keeps refusal viable without advanced movement. Keep required evidence equally reachable through both encounter alternatives. Next: choose the elevator puzzle approach, then refine its feedback/clues before its dependent slice.

### 2026-10-04 — Operative first-level building

- Built the real north staff passage, furnished break room, upper/lower elevator cabs, lower landing, and long exit corridor in the existing Blender/GLB workflow. ADR-0021 records the bounded transfer; earlier ADRs and preexisting uncommitted documents were preserved.
- TDD: the capsule first failed to pass the used staff door; after that passed, elevator activation failed to pause/descend. Both now pass, including the complete return to the workstation. A typed-array ray comparison error discovered in regression logs was fixed with an Area3D guard.
- Verification: Godot 4.7 import; headless building, gameplay, and surveillance checks; Forward+ rendered building round trip, all passed with clean final engine logs. Reviewed nine first-person captures and four new Blender previews. Rendering in the redirected test sandbox needed empty shader-cache directories prepared there; no player save files were copied or changed.
- Limits: traversal was scripted, not a manual mouse/keyboard playtest. Travel is a fade between fixed cabs; the exit remains solid. Movement, incident code, puzzle/encounter mechanics, and shift/campaign outcomes stay unchanged. No dependencies, commits, or pushes.
- Retained process improvement: review floor extents and text orientation before export. This found a 4 cm threshold crack and a reversed break-room sign; applying the same seam/clearance review to the elevator/corridor joins avoided another asset rebuild. Next: manual controls review, then D-17's controller contract.

### 2026-10-04 — Manual playtest and elevator surface correction

- The user completed the mouse/keyboard round trip and confirmed functionality, reporting only texture fighting near the elevator door. Removed coplanar floor strips and steel/paint sidewall joins at both entrances by trimming three geometry definitions; controls and travel behavior remain unchanged.
- Rebuilt the Blender source, GLB, and affected previews, then imported them into Godot. Previously overlapping floor and jamb surfaces measured zero overlap afterward. Reviewed four targeted Forward+ views; building, gameplay, and surveillance integration checks all passed with clean logs and isolated saves.
- The open manual-playtest instance must restart to load the rebuilt geometry; the user has not yet retested the visual correction. No dependencies, commits, or pushes.
- Process lesson: collision clearance alone does not prove a clean visual join. Review visible floor and double-sided wall faces for coplanar overlap alongside passage clearance. Next: settle D-17's controller contract.

Keep future entries concise: what changed, why, decisions, checks and their actual results, remaining risks, one lesson, and the next action. Durable detail belongs in linked documents, not repeated transcripts.

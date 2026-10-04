# Legacy Incident Escape Room — Product Specification

Last updated: 2026-10-04. Status: living technical specification, with proposed gameplay clearly labeled.

This is the **how** document. The [PRD](PRD-legacy-incident-escape-room.md) explains the purpose and player outcomes. The [implementation plan](IMPLEMENTATION_PLAN.md) sequences the work. This document does not authorize implementation.

## 1. Scope and governing decisions

Extend the existing desktop game through one complete shift before adding more incident packs. Capability IDs `G-01` through `G-20` refer to the PRD; G-15 is an authorized research direction, G-17 requires multiple endings while retaining a candidate exposure outcome, G-18 establishes the building/refusal-path direction, G-19 requires Quake-style movement, and G-20 describes a later movement minigame. Ordinary level escape means going home for the night, followed by a choice to quit or continue. Continued employment starts the next workday's shift. The accepted IT handoff applies to continuation toward mission two; it does not authorize creating an additional incident pack in this session.

Governing decisions:

- [ADR-0001](decisions/0001-product-purpose-and-player-agency.md): educational purpose, atmosphere, and player agency.
- [ADR-0002](decisions/0002-documentation-and-test-driven-delivery.md): documentation boundaries, TDD, and vertical delivery.
- [ADR-0003](decisions/0003-retain-current-desktop-stack.md): retain the existing stack and architecture.
- [ADR-0004](decisions/0004-repair-and-refusal-evidence-routes.md): viable repair and refusal routes with distinct puzzle clues and crime evidence.
- [ADR-0005](decisions/0005-nda-onboarding-and-retaliatory-murder-evidence.md): fictional agreement signing at the opening and subtle physical evidence of murders after threatened NDA disclosures.
- [ADR-0006](decisions/0006-first-mission-messenger-rumors-and-it-handoff.md): suspicion-first employee messages, inherited accounts, and the IT wipe before mission two.
- [ADR-0007](decisions/0007-difficulty-specific-joel-personas.md): difficulty-specific Joel personalities with a shared core story.
- [ADR-0008](decisions/0008-dantalion-free-plan-and-task-earned-usage-reset.md): Dantalion's very limited fictional free plan and task-earned usage resets.
- [ADR-0009](decisions/0009-investigation-earned-dantalion-credits.md): investigative tasks are the prerequisite for earning Dantalion credits.
- [ADR-0010](decisions/0010-teach-program-construction-through-play.md): explicitly teach program construction beyond syntax and bug repair.
- [ADR-0011](decisions/0011-initial-audience-and-deferred-beginner-lessons.md): start with basic coders who need help with structure; defer beginner instruction until the core baseline.
- [ADR-0012](decisions/0012-explore-optional-practice-mode.md): investigate optional environments for real player-built apps outside story mode; technology and delivery remain unapproved.
- [ADR-0013](decisions/0013-dystopian-absurdism-and-shift-based-escapes.md): dystopian absurdism; ordinary escape ends a work shift and permits going home before the next day's return.
- [ADR-0014](decisions/0014-indubitably-career-pressure-and-candidate-exposure-ending.md): Indubitably career-pressure direction and the envisioned exposure/shutdown ending; exact mechanics remain open.
- [ADR-0015](decisions/0015-multiple-endings-and-post-shift-resignation.md): several endings and the option to quit after every completed stage, regardless of repair/refusal route.
- [ADR-0016](decisions/0016-story-first-scope-and-deferred-retirement-scoring.md): focus current delivery on the established story; defer Pirates-style retirement scoring and conditional puzzle-pack ideas.
- [ADR-0017](decisions/0017-first-level-operative-building-expansion.md): next-session construction of the operative first-level break room, elevator area, and long exit corridor.
- [ADR-0018](decisions/0018-refusal-descent-and-guard-dog-alternatives.md): refusal descends through an elevator puzzle to guard dogs, with reserved snack or movement alternatives; mechanisms remain open.
- [ADR-0019](decisions/0019-quake-style-movement-and-impossible-practice-space.md): Quake-style strafe-jump acceleration and a later secret jump-pad room with deliberately impossible interior scale.
- [ADR-0020](decisions/0020-local-guard-dog-retry-and-snack-restoration.md): being caught returns the player to the corridor entrance and restores the snack if used.

**Current** describes the inspected `c243f21` gameplay baseline plus the spatial implementation verified on 2026-10-04 and committed as `53279f4`. **Required** describes an explicit user requirement or governing decision. **Proposed** describes an implementation or narrative recommendation awaiting a decision. A requirement's presence does not mean it has been built.

## 2. Architecture and stack

Current responsibilities, serving G-01, G-02, and G-07:

| Location | Responsibility |
| --- | --- |
| `godot/project.godot`, `godot/office.tscn` | Godot 4.7 standard project, first-person office entry scene, Forward+ renderer. |
| `godot/scripts/office_player.gd` | Movement and mouse look. |
| `godot/scripts/office_room.gd` | Physical interactions, workstation transition, notices, and room observation. |
| `godot/scripts/main.gd` | Workstation UI, editor, clues, hints, clock, score, and runner invocation. |
| `godot/scripts/panopticon.gd` | Reactive and random terminal alerts, eye states, and sound. |
| `godot/tools/level_runner.mjs` | Node command bridge for status, tests, simulation, and deployment validation. |
| `godot/levels/night_shift_checkout/level.json` | Incident content, objectives, clues, hints, timer, and sandbox file list. |
| `godot/levels/night_shift_checkout/incident_repo/` | Real JavaScript ES modules, `node:test`, fixtures, simulated API, and SQL evidence. |
| `scripts/build-rifkin-office.py`, `assets/blender/` | Existing Python/Blender office asset workflow. |

Required: extend these responsibilities and existing signals before considering new modules. Do not introduce an event framework, general quest engine, database, backend service, or additional runtime for this slice. Any dependency or architectural expansion follows the approval rule in `AGENTS.md`.

Node currently comes from PATH. The observed local runtime on 2026-10-03 was `v25.9.0`; this is not a supported-version decision. The package has no Node version pin. Select and verify the scenario's supported runtime before shipping its reference documentation. The `godot` alias was unavailable in this shell; the existing launcher and setup document describe a Windows fallback. Building, gameplay, and surveillance integration checks passed using the installed Godot 4.7 console executable on 2026-10-04.

## 3. Content and state

Current: `level.json` contains five named clue entries and a five-step hint ladder. The workstation keeps discovered clue IDs, hint use, test count, and elapsed time in memory. Opening a clue marks it discovered. There is no agreement-signing opening, player-written notebook, route completion state, surveillance penalty state, workload progression, employee messenger, IT handoff, or difficulty-persona selection.

Required/proposed state additions serve G-01 through G-08, G-10 through G-13, and G-16/G-17:

| State | Minimum contract | Status |
| --- | --- | --- |
| Incident validation | Real tests and production replay determine repair acceptance. | Current contract to preserve. |
| Escape outcome | Track departure home for the current shift independently of deployment success, employment status, and campaign conclusion. Refusal can succeed with the incident unresolved. | Required, ADRs 0004/0013. |
| Route evidence | Each route exposes distinct puzzle clues and distinct crime evidence. A route provides its own necessary escape information. | Required, ADR-0004. |
| Opening agreements | Present an employment agreement and NDA, then track the character's in-world signing before normal incident play. | Required, ADR-0005; state representation proposed. |
| Inherited workstation | Mission-one access includes prior logged-in accounts and archived employee-group messages; IT replaces these with the player's own accounts before mission two. | Required, ADR-0006; retention scope open. |
| Difficulty persona | Associate the chosen difficulty with its Joel presentation and reviewed behavior, preserving the core story. | Required, ADR-0007; selection and medium persona open. |
| Dantalion allowance | Track limited remaining assistance and grant credits/refresh allowance only through qualifying investigative tasks. | Required, ADRs 0008/0009; unit, quota, and exact milestones open. |
| Notebook entries | Only player actions create excerpts or notes. Preserve entries across workstation transitions during a run. | Manual recording required; exact format proposed. |
| Observation and bypass | Identify the observation channel, affected station/area, and whether the bypass suppresses its gameplay consequence. | Proposed technical model for G-02/G-03. |
| Posted rule | Identify its scope, effective time, exception, and consequence in readable content. | Proposed content representation for G-04. |
| Assignment tier | Represent a finite workload tier with declared deadline and promotion criteria. | Capped progression required; values undecided. |
| Reference entry | Identify language/runtime/library version, topic, text, and ordinary examples. | Proposed representation for G-08. |
| Shift transition | Completing an ordinary level gets the player home; choosing continued employment starts the next workday's shift. | Required structure, ADRs 0013/0015; numbering and retained state open. |
| Employment choice | Offer resignation after every completed stage on both routes, separately from shift completion. Its aftermath follows the reviewed ending/choice rules. | Required eligibility, ADR-0015; controls and consequences open. |
| Indubitably content | Fictional career/job content communicates fear of quitting's black mark and return motivation. | Required story direction, ADR-0014; interactions and representation proposed. |
| Campaign conclusion | Distinguish ending outcomes from nightly release. Provide multiple endings and preserve exposure/shutdown plus employment aftermath as a candidate. | Multiple endings required, ADR-0015; candidate exposure ADR-0014; exact gates open. |

Keep this state in its existing owning script or level content. A dedicated file is justified only by the implemented slice. Notebook persistence across application restarts, route switching, and cross-scenario evidence carryover remain open decisions. Do not build a general save system for these unspecified behaviors.

## 4. Gameplay behavior and example scenario

### First-level spatial baseline — G-18

Verified spatial implementation in current source: the existing first-person office connects through its north staff door into a 3.7 m wide upper lobby, with a modest 6 m by 6 m break room to the west through an open 1.65 m doorway. The genuine wall opening has approximately 1.07 m clear width and continuous floor support. Using the staff door once slides it 1.16 m left; it remains open for return. [ADR-0021](decisions/0021-bounded-elevator-transfer-and-first-level-layout.md) records this agent layout choice within the user-authorized continuation scope.

Construction retains `office.tscn`, the office GLB generated by `scripts/build-rifkin-office.py`, and mesh-name-based collision and raycast interactions in `office_room.gd`. The north wall is split around the service doorway; the former uninterrupted wall is no longer the intended passage geometry. New floors, walls, ceilings, and solid break-room furnishings follow the existing collision pattern. Preserve existing named objects and interaction coordinates outside the changed doorway.

The elevator uses matching static cab interiors 6 m apart vertically, each with a 1.4 m opening and a back-wall control reachable from inside with the existing 2.5 m interaction ray. E selects one downward or upward transfer. Walking pauses, velocity clears, and the player's view and horizontal position are preserved while a 0.3-second fade out, 0.4-second black hold, and 0.3-second fade in present the transfer. There is no moving platform, simulated shaft, or floor-selection system. The lower landing joins a 52 m long, 3.6 m wide corridor extending west to a solid, recognizable exit. The walking camera far range is 90 m to support this sightline.

This resolves D-15 for spatial slices 0.2–0.4 under ADRs 0018/0021; dimensions remain provisional for later player review. The workstation, notices, window/retention nets, current incident, Panopticon reactions, and current WASD/mouse controls are preserved. Travel is available without repair so the full layout can be inspected and the player can return to the workstation. The elevator puzzle, dogs/snack, final route gates, and nightly release state remain later work; physical exit arrival changes no shift, resignation, or campaign outcome.

Acceptance: in the running game, walk from the spawn/workstation through the connection, enter the break room, reach the elevator, follow the corridor to the exit, and return. Verify collision clearance, usable sightlines, lighting, and existing interaction prompts at normal player height. The exit must be recognizable as a future nightly-departure point without falsely declaring campaign completion. Use focused tests for changed movement/door/interaction behavior and a visual playthrough for geometry and atmosphere. The [continuation prompt](CONTINUATION_PROMPT.md) and spatial slices in the plan bound this work.

Verification on 2026-10-04: `building_integration.gd` passed the complete round trip using the actual capsule and `move_and_slide`, including closed-door blocking, continuous floor support, both elevator controls, and workstation access on return. Its optional `--visual-review=<absolute directory>` captures the rendered first-person route; nine images were reviewed under Forward+ alongside the Blender previews. The existing gameplay and surveillance checks passed with clean logs and isolated saves. The user completed the manual mouse/keyboard round trip and confirmed it worked. Reported elevator doorway texture fighting was corrected by making the floor and sidewall surfaces meet without overlapping. After rebuilding and importing the asset, overlap measurements were zero at both entrances, four targeted Forward+ views were reviewed, and all three integration checks passed again. The user has not yet retested the visual correction. This confirms route functionality, not movement tuning or educational effectiveness.

### Elevator puzzle, guard dogs, and the reserved snack — G-01, G-04, G-06, G-18, G-19

Required direction: refusal can bypass normal elevator departure authorization, descend toward the long exit corridor, and deal with guard dogs by movement evasion or the snack reserved in the break room. Obtaining route-essential clues or the snack cannot require incident repair, opposite-route evidence, or completing the optional movement minigame. None of these mechanics currently exists.

Proposed elevator approaches under D-16: (A) a discoverable maintenance exception entered through the floor buttons; (B) conflicting procedure revisions whose explicit precedence identifies the valid order; (C) reconstruct a previous employee's successful sequence from physical traces and accessible messages. Recommend A: a posted exception plus an ordinary service record/directory supports deduction, with a short button sequence bypassing the normal clearance state. The actual sequence, input boundaries, activation/reset, and surveillance coverage are undecided. Do not introduce an unexplained lockout or automatically write the answer into the notebook.

Proposed feedback: show each pressed button's acknowledgment, a distinct acceptance state and actual descent, and a legible rejection/reset state. Feedback teaches the control contract without disclosing missing solution steps. Wrong-input consequences and what Joel/Panopticon observe require D-16; changing those rules silently would undermine experimentation.

Proposed encounter contract: show the dogs' presence and interest in food before the player commits to the chase. The snack creates a dependable, low-demand passage window; movement skill offers a useful alternative. Both reach the same required refusal evidence and departure opportunity. No worse ending follows merely from choosing the snack. Required recovery under ADR-0020: if caught, return the player to the corridor entrance and restore the snack if used, allowing another attempt without replaying the coding incident. Exact snack acquisition/use/consumption, dog patrol/response, evasion timing, the retry clock/state snapshot, and recovery after wasting a snack without being caught remain D-16 choices.

Proposed evidence beat: a service/override record linking an earlier employee's late descent with later disappearance rewards the physical refusal route without declaring the murder conclusion. Exact identities, records, and chronology remain D-07/D-16. Connect it to established rumor/NDA evidence; preserve the distinction between suspicion and proof.

### Quake-style movement and the impossible movement room — G-19, G-20

Current: `office_player.gd` normalizes WASD direction and approaches a fixed walking speed in both ground and air states. It applies gravity but contains no jump input, separate air acceleration, or jump-pad handling. The current capsule is 0.48 m wide and 1.65 m high; camera far range is now 90 m for the exit corridor. Verify clearances and sightlines against changed movement rather than assuming existing office dimensions fit it.

Required direction: Quake 3 Arena-like movement with acceleration through strafe jumping. This needs a defined velocity/friction/jump contract, rather than a jump button added to the current capped walk. The [original movement source](https://github.com/id-Software/Quake-III-Arena/blob/master/code/game/bg_pmove.c) is a primary reference for ground friction and directional acceleration. Similar feel is the requirement; exact constants, a faithful port, timing model, or copied implementation are not approved. D-17 settles ground/air acceleration, jumping and repeat input, momentum on landing, reachable speeds, stopping, and teaching before controller work. Add no dependency simply to reproduce a named game's feel.

Later required direction: a secret office room contains jump pads and multiple courses increasing in difficulty, inspired by defrag strafe-jumping maps. Its interior can be much larger than the apparent exterior footprint. A simple oversized authored room can establish that effect; portals or special non-Euclidean rendering are not required. Course access, pad impulses, resets, challenge/reward structure, and clock interaction remain D-17. Suggested corporate framing is a “Mandatory Voluntary Wellness Annex”; this is proposed copy, not story canon.

Proposed progression teaches one movement behavior at a time in a safe space, then combines it with timing, direction changes, and pad-to-pad travel. Consistent local movement rules and readable feedback support experiments even when room scale is impossible. Advanced routes remain optional and cannot hold the only required refusal clue. This minigame is separate from G-15's real-app practice feasibility.

### Work shifts, Indubitably, and the campaign conclusion — G-01, G-11, G-16, G-17

Required tone and structure: dystopian absurdism. Each ordinary shift escape earns the right to go home for the night. After every completed shift/stage, both routes offer the choice to quit or continue employment. Continuing starts the next workday's level. Repair and refusal are distinct methods of leaving the current shift; refusal is not automatically resignation. Their meaningful local outcomes and crime evidence remain intact.

Required story direction: Indubitably is a fictional job-search/professional-networking app. Through story elements, it conveys fear that quitting leaves a black mark on the character's work record and damages prospects. This pressure does not remove the accepted option to quit. Do not infer a numeric employability score, compulsory application tasks, automatic penalties, or a full career simulation. Choice presentation, resignation consequences, and app interactivity require D-13.

Proposed first integration: one locally authored app panel or message during an evening/next-day interlude. It gives a reason to return, with ordinary controls and optional reading. It must not rank notebook clues or decide deductions. Exact text, location, application actions, and where resignation is presented remain unapproved; quitting availability after each completed stage is settled. Any enforced employment restriction must be discoverable before consequential use.

Required: several endings. Neither repairing code nor a crime-evidence threshold may gate the post-stage option to quit. Nightly release alone does not resign; an explicit reviewed player choice does. Returning must not occur automatically after choosing resignation. Exact end-state names, conditions, evidence effects, and whether the player can report retained evidence after quitting remain D-13/D-14 decisions. Quitting eligibility does not itself select one universal failure ending or require an immediately terminating epilogue.

User-envisioned candidate ending: the player supplies smoking-gun evidence of wrongdoing, including murder, to fictional authorities; Rifkin is shut down. Public recognition as a hero is followed by loss of steady income and rejection by employers with similarly abusive practices. The player character subtly wonders about the personal cost. Preserve both the effective shutdown and the career aftermath. Other required endings, evidence sufficiency, submission controls, public identity, and presentation require D-14. This does not establish allegations about real employers or real reporting procedures.

ADR-0016 defers Pirates-style retirement/accomplishment assessment for current story delivery. A later puzzle-pack product could revisit it only after a new scope decision. D-14 concerns authored narrative endings, evidence, and departure/reporting choices; it no longer gates work on selecting a retirement model. The existing test/hint-penalizing incident score is not an accepted campaign-ending measure. No salary/reputation simulation or generic ending framework is approved.

Keep campaign ending conditions separate from nightly exit conditions. Do not require every route's crime evidence to let the player go home, automatically mark a first-shift escape as final exposure, or turn personal notes into automatically graded accusations. Cross-night evidence storage and IT-wipe behavior still need D-01/D-08; proposed continuity must match the approved retention contract. Proposed first-shift baseline: demonstrate nightly release and a scoped next-day handoff; the entire campaign/finale remains later work. Exact baseline criteria remain D-11.

### Agreement signing and gradual revelation — G-01, G-07, G-10

Required: the game opens with the character signing both an employment agreement and an NDA. The NDA contains absurdly abusive terms expressed in polite, reassuring language. The actual restrictions must remain readable so players can recognize their significance later. This is an in-world action using ordinary game controls, not a real legal agreement, personal-data form, or external signature service.

Proposed integration: show the authored documents in the existing office/workstation UI and retain local signing state in the responsible script. Make the agreements available for later rereading without copying important clauses into the notebook automatically. Start the incident clock after onboarding, subject to the clock decision D-04. Do not add an onboarding framework or general contract system.

**Proposed NDA wording, not final copy:** “To preserve the welcoming environment we share, concerns about company activities remain within the Rifkin family, including after your employment ends. Public discussion requires Joel's prior written encouragement.” Other candidate terms frame compulsory availability, unrestricted monitoring, or the suppression of safety concerns as care and support. Exact clauses, document length, signing presentation, and refusal-to-sign behavior remain D-07 decisions.

Required author-level story: the company murdered employees who threatened to violate their NDAs and go public with what they knew. Required player experience: refusal-route physical records provide subtle, discoverable clues to that retaliation. Do not identify them as “murder evidence” in interaction prompts, automatically connect them in the notebook, or reveal the answer in the opening agreement.

Proposed evidence chain: a retained draft threatening disclosure repeats a phrase from the NDA; a dated management acknowledgment establishes that the threat was received; a separate record contradicts the corresponding official “accident” account. These are candidate objects, not approved text. Their connection relies on consistent identities, dates, and wording across documents. Keep route-specific escape information independently available, and leave the player to select records and infer the connection. Do not assign a specific killer, murder method, victim identity, or the full cover-up chronology without a narrative decision.

### First-mission rumors and the IT handoff — G-06, G-10, G-11

Required: suspicion begins with old messages in a messenger established by employees. A small group discusses recent disappearances and unusual department turnover. During mission one, the player's assigned computer still uses another person's logged-in accounts. The messenger does not seem viewable by Panopticon. The messages contain breadcrumbs and uncertainty, not proof of murder or an authoritative exposition of the whole conspiracy.

Required: before mission two, IT wipes the computer in preparation for the next assignment and finally supplies the player's own email access and credentials. All accounts, messages, and credentials are fictional local game content. Do not connect a real messenger, mailbox, or identity provider.

Proposed message examples: someone asks whether a colleague resigned; another points out that the colleague's desk was cleared before any farewell; someone remembers a request to save a conversation off the work computer. Names, dates, thread membership, and exact wording require D-08 review. Do not assume the logged-in account belongs to a murder victim.

“Apparently hidden” is a player observation, not a technical guarantee. Decide whether Panopticon can observe application presence, message content, or account access before enforcement. Do not use retroactive hidden monitoring to punish a player for an observation the game taught as reliable.

Proposed handoff contract: announce what will be removed, allow rereading before the transition, and preserve deliberately recorded notebook entries. The source messages can disappear while the player's selected excerpts survive. The wipe should change available evidence, not make the next escape impossible because an indispensable clue was lost. Decide exact retention, notification, transition controls, and tutorial/mission numbering in D-08 before implementation. This is a scripted in-game transition, not deletion of the real player's files or an automatic call to the incident sandbox reset.

### Joel across difficulty levels — G-02, G-05, G-07, G-12

Required: the underlying company story remains the same, but each difficulty has a different Joel persona. Do not confuse employee rumors with confirmed events or assign personal responsibility for the company murders to a persona without a separate story decision.

| Difficulty | Accepted personality and story presentation | Undecided mechanics |
| --- | --- | --- |
| Easiest | Talented but overbearing senior engineer; openly disdainful of AI. Panopticon catching helper use makes life harder for the player. | Detection coverage, advance warning, consequences, cap, and recovery. |
| Medium | No persona accepted yet. Proposed: once-capable engineer turned insecure manager, prioritizing dashboards, approvals, and his image. | Persona, AI stance, rules, loopholes, and consequences. |
| Hardest | Technically incompetent nepotism hire who guards his privilege. Employee rumors describe unwanted advances toward women and higher turnover among female staff. | Pressure, access restrictions, evidence presentation, and recovery. |

Proposed medium variant: he can recognize technical terminology but relies on activity reports instead of diagnosis. He privately uses AI while insisting staff demonstrate independence. A disclosed, capped review after helper detection is a candidate consequence, not an accepted penalty. A documented diagnostic or maintenance authorization could create a permitted exploration window. He differs from the talented engineer through process control and from the nepotism hire through concern about appearing competent.

Proposed implementation: keep persona identity fixed for a run and treat fast-completion workload tiers as a separate axis. A workload promotion should not silently change Joel's identity. Use existing content dictionaries and observed-action handling for the first approved variation; do not build a personality engine. Exact mode selection, mode-specific incident challenge, helper detection, sanctions, and middle persona require D-09.

Required constraints: helper hints remain optional and useful, consequential rules are discoverable, and both repair and refusal remain escapable. Review detection consequences before implementing them. In the easiest learning mode, prefer announced, bounded, recoverable friction to removing hints or compounding penalties. That balancing recommendation remains proposed.

### Dantalion's limited free plan — G-07, G-08, G-13

Required: name the apparent LLM helper Dantalion, using the user's intentional Ars Goetia reference. The player has a very limited fictional free subscription. Completing investigative tasks is a prerequisite for earning credits and refreshing allowance. A passive time reset or unrelated chore alone would not satisfy this requirement.

Current: the helper is a fixed local hint ladder in `main.gd` with level-authored hints and no model call. Proposed: keep the fictional service local and deterministic while integrating quota state and qualifying task events with existing scripts. No AI SDK, paid subscription, account service, or network call is authorized. The apparent model's identity does not establish supernatural powers or a real provider.

Accepted task category: investigation, under ADR-0009. Proposed credit model: a first-time completed investigation milestone restores the capped allowance. Candidate milestones include reproducing the failure, completing a diagnostic experiment, or performing a physical investigation action. Choose accessible tasks on both repair and refusal routes, including an opportunity before the next likely bottleneck. Do not require repairing the entire incident to earn help needed for that repair. Separate non-investigative favors are outside the selected initial model.

Proposed contracts for D-10 review:

- Display remaining allowance and explain qualifying task rules without identifying important post-tutorial clues or revealing a solution.
- Use explicit task completion rather than a hidden reward for opening an important document, so usage feedback does not become an automatic clue detector.
- At zero allowance, stop new hints but retain previous responses for rereading. Restoring allowance does not rewind the hint ladder or erase notes.
- Credit an approved milestone once, rather than allowing repeated identical test runs or already-completed tasks to replenish indefinitely. Restoring a cap and accumulating extra credits are distinct models; neither is implemented.
- Keep the neutral offline reference separate and unmetered. Technical lookup is not a Dantalion response.
- Keep allowance resets separate from Panopticon's observation history and any reviewed Joel consequence. A task refresh must not silently erase that history.
- Review the combined cost of quota scarcity, the incident clock, and helper detection so asking for optional assistance remains a useful choice.

Exact allowance, what counts as a response, eligible tasks, failure/retry charging, repeated-task credit, initial tutorial access, difficulty variation, and account/IT-wipe persistence remain D-10 decisions. These are local game rules, not claims about real LLM subscription behavior.

### Program construction through play — G-01, G-07, G-09, G-14

Required goal: teach how to construct a program, beyond recognizing syntax or repairing the supplied incident. Initial audience: players who write basic code but need help organizing programs. Defer absolute beginner lessons until the core game's functional skeleton supplies a baseline. Curriculum, exercise, editing surface, and baseline criteria remain D-11 decisions. Do not equate the developer's adopted TDD workflow with evidence that the player has learned it.

Proposed construction loop:

1. Describe the promised behavior, inputs, outputs, and constraints in plain language.
2. Choose concrete examples that expose those promises and assumptions.
3. Decide which part owns each responsibility and how data crosses its boundary.
4. Build one runnable slice, using a focused failing test, the smallest passing implementation, and local refactoring.
5. Inspect data representation, mutable state, side effects, and error behavior that the actual requirement needs.
6. Apply a changed requirement, then explain what had to change and why.

The test-first cycle is a teaching proposal grounded in [Fowler's description of TDD](https://martinfowler.com/bliki/TestDrivenDevelopment.html), not a claim of proven learning effectiveness. Teach tradeoffs and consequences, rather than grading function count, formatting, a design-pattern checklist, or one exact architecture. Deterministic checks can verify behavior. Playtest explanations and a changed-requirement exercise can supply evidence about understanding.

Proposed first lesson: use checkout evidence to ask what a coupon calculator promises callers while its stored data representation changes. An optional exercise has players choose examples for old and migrated coupons, construct a small compatible calculation, and examine which assumptions belong in the calculation versus its caller. A follow-up changes one agreed requirement so the player can observe the cost of coupling. Exact code, tests, and change remain unapproved; the shipped broken incident remains untouched.

Current editor limitation: `main.gd` exposes one editable source file and fixed runner actions. Authoring tests, creating files, or constructing a standalone program needs an explicitly scoped surface/content decision. Do not infer authorization for a general IDE, grading service, new framework, or additional incident pack from this goal. An exercise can start within the existing sandbox if the chosen lesson fits it.

Proposed delivery: scaffold the construction method in its tutorial, then offer optional Dantalion questions and neutral reference while players apply it independently. Begin with manageable pressure before combining new construction concepts with surveillance and quotas. Refusal escape remains possible without completing the repair or this exercise. The game should offer direct construction practice; it need not force every playthrough through every learning activity.

### Optional real-app practice feasibility — G-08, G-14, G-15

Required investigation: assess player-created environments for building and running functional apps outside story mode using the game's technical reference and guidance. This is research authorization, not a selected architecture or release promise. Findings, primary sources, and the proposed runnable proof are in the [practice spike](spikes/2026-10-03-practice-mode-feasibility.md).

Current gaps: only one editable source file; fixed batch commands; synchronous execution; no process ownership, stop control, live logs, app preview, or practice project management. Startup resets the incident copy. Existing commands save incident drafts, affect scoring, and emit surveillance events. A project directory or Python package environment is distinct from OS isolation.

Proposed first scope: one local JavaScript web app, with a versioned runtime, a few player-editable files and tests, local reference, explicit run/stop controls, and durable project/data storage separate from incident resets and IT wipes. A container-backed prototype is the leading research recommendation for native app execution; browser Node is an alternative with integration, compatibility, licensing, and offline questions. No backend is accepted. The native desktop build cannot use the Web-export-only JavaScriptBridge as an embedded browser.

Before any runnable spike, resolve D-12. Prove execution, persistence, interruption/recovery, and the isolation boundary before expanding languages or packages. A browser-based diagnostic preview can help establish execution, but it does not prove that interaction works inside the game. Embedded preview is a separate proof and may require approved dependencies. Keep project content separate from replaceable runtime environments.

Proposed practice rules: a quiet, untimed workspace; no Joel sanctions or story progression requirement; optional construction coaching and neutral documentation. Exact practice help, whether Dantalion appears there, and any allowance mechanism remain open. If practice uses Dantalion credits, preserve investigative prerequisites unless a new decision explicitly changes that policy. The existing authored hint ladder does not provide general answers for arbitrary projects, and this feature authorizes no real AI integration.

### Observation and resistance — G-02, G-03

Current: workstation `action_observed(action: String)` signals reach Panopticon's `observe_action`. Room actions cover workstation absence, cubicle departure, terminal proximity, notice reading, and looking toward the window or service door. These actions currently produce presentation effects. Random alert scheduling and observer-disconnected text do not create verified blind spots.

Proposed: distinguish workstation screen observation, local camera/presence observation, and independent access or server records. A channel's limits must correspond to player-visible evidence. Random atmospheric notices must not randomly impose detection penalties or disable a working bypass.

The borrowed drive would replay screen and seated footage for its paired workstation. Obtain it before the first action that requires its protection. Activation requires a valid recording at the workstation. A timer and independently inspectable presence/feed result confirm operation. It does not cover unrelated cameras or door records. Exact duration, activation steps, coverage, reuse, and expiry warnings require a decision before this slice.

Proposed recovery: an initial discrepancy gives the player time to retreat. Confirmed detection changes access or consumes the bypass opportunity. Preserve notes, evidence, and editor drafts. Demonstrate a remaining escape path after each designed recoverable mistake. Do not introduce confiscation or permanent failure without defining and testing that recovery contract.

### Two evidence-bearing routes — G-01, G-04, G-09, G-10

Required: repair and refusal are both viable. Neither route requires the other route's exclusive clue. No implementation may make deployment a universal escape prerequisite. Exact route switching and whether all evidence can be collected in one run remain undecided.

**Proposed example: “Release Pending.”** Use the current checkout incident as the coding anchor for a design demonstration. This example is not an implemented level or a decision to duplicate the tutorial.

| Route | Actions and puzzle clue | Distinct crime evidence |
| --- | --- | --- |
| Repair | Diagnose the migrated coupon fields, preserve legacy behavior, and pass tests plus production replay. A posted verification procedure permits a service-room visit. A maintenance diagram in the authorized records explains that route's exit latch. | An internal revision history shows mandatory extended shifts retrospectively recorded as voluntary. |
| Refusal | Establish a surveillance gap, investigate a vacant desk, and deduce an elevator bypass without repairing checkout. Descend to the dog-guarded corridor and pass through movement evasion or the reserved snack. A maintenance exception is the proposed puzzle approach; its exact clue/order is unaccepted. | Physical records subtly connect an employee's threat to violate the NDA and go public, management's knowledge of the threat, and a death later described as an “accident.” |

Retaliatory murders and agreement signing are accepted story requirements under ADR-0005. The individual incriminating records, repair-route record edits, and specific exit procedures remain proposed fiction. The repository currently establishes monitoring, compulsory shifts, retention nets, and Joel's notice about three “accidents.” It does not contain agreement signing or these new records.

Both routes connect observation, experimentation, and a physical departure home for the night. Players choose whether and what to record; notebook completion is not a nightly escape gate. Their revelations should change the player's understanding of the company. A proposed evening interlude lets players revisit their chosen evidence without grading their personal notes or supplying missed deductions. Collecting every record is not a nightly escape requirement. Final exposure has separate, unresolved conditions under D-14.

### Rules, workloads, and teaching — G-04, G-05, G-07, G-09

Required: consequential rules must be discoverable before enforcement. Proposed notices carry effective times and explicit exceptions. A contradiction becomes usable only when actual access behavior follows the documented exception or precedence rule.

Required: particularly fast completion can produce harder later assignments and tighter deadlines, ending at a defined cap. Set thresholds, tier count, minimum time budgets, and the performance measurement before implementing progression. Do not shorten an active assignment's deadline as an undisclosed reward for competence. Delayed reporting is a candidate resistance tactic. Immediate completion also needs a useful opportunity so waiting is not the dominant strategy.

Required: tutorial teaching covers controls, manual note selection, observation limits, bypass feedback, and recovery. After the tutorial, assistance comes primarily from requested Dantalion hints within the task-refresh allowance. Necessary interface feedback must remain available. Do not automatically label important clues, complete notebook deductions, or open a solution-revealing reference page. Proposed: teach allowance and refresh controls explicitly without teaching later puzzle deductions.

## 5. Runtime integration and verification boundaries

G-01, G-08: Godot currently invokes `node` with the runner path, sandbox path, and a fixed command. The runner invokes child actions with `process.execPath`. Supported commands are `status`, `simulate`, `test`, and `deploy`.

Deployment runs `node --test`, then the simulated production checkout. Nonzero exits reject deployment. Both passing accept the repair. The UI reports the result and emits an observed action. Deployment does not currently finish the escape or stop the clock.

Preserve the intentionally broken shipped incident. Verify a solved fixture only in a disposable copy or isolated test sandbox. Use existing SceneTree test patterns for integrated player actions. No live database or production deployment is involved.

## 6. Player surfaces

- **Office, G-01/G-02/G-04:** ordinary interaction labels, readable notices, and observable surveillance coverage. Do not mark a relevant object as a “key clue” after the tutorial.
- **Opening agreements, G-10:** readable employment agreement and NDA, politely framed abusive terms, and explicit fictional signing before incident play. Teach the interaction controls without explaining later evidence connections.
- **Workstation, G-01/G-07:** preserve real source editing, tests, simulation, deployment validation, and drafts when returning to the room.
- **Notebook, G-06/G-09:** proposed manual excerpts with source labels plus free-form writing. Copying is deliberate. The game does not rank notes or infer correct deductions. Decide paper versus monitored digital presentation before implementation.
- **Dantalion, G-07/G-13:** requested, graduated hints about observation or reasoning, with a very limited free-plan allowance and task-earned resets. Proposed UI shows remaining usage, refresh rules, and readable response history. Keep technical reference separate. Do not patch the player's source or supply a completed solution.
- **Reference, G-08:** searchable offline entries with version labels and ordinary examples. Support search, clear results, return navigation, and access to approved local reference material. Do not select a page based on a detected puzzle mistake. Searchable content must not require Internet access or download a whole documentation site.
- **Employee messenger, G-11:** locally authored archived group messages, visible speaker/time context, and ordinary reading controls. Teach manual excerpt controls without flagging particular messages as important. Its apparent surveillance gap must match the decided observation boundary.
- **IT handoff, G-11:** explain the in-game wipe and the arrival of the character's personal work accounts. The retained evidence behavior follows the approved D-08 contract.
- **Difficulty presentation, G-12:** explain the approved pressure differences and introduce the selected Joel through his messages and rules. An actual selection screen is a proposal, not an existing surface.
- **Practice, G-15:** candidate project creation, editing, tests, run/stop, app interaction, local reference, guidance, and reopen controls outside story mode. App type and preview technology remain D-12 decisions.
- **Indubitably and shift interlude, G-16:** fictional career-pressure content and the required quit/continue choice after every completed stage. Location, controls, app interactivity, resignation consequences, and return presentation require D-13.
- **Campaign conclusion, G-17:** multiple endings, with exposure/shutdown/job-search aftermath retained as a candidate; outcomes separate from nightly release, with evidence/choice gates under D-14.

## 7. Clocks and calculations

Current, G-05/G-07: the incident begins at 60 minutes. Godot timer ticks reduce the remaining time, and expiry permits continued play. Alerts occur at 30 and 10 minutes remaining. The displayed score is:

```text
max(0, 1000 - floor(elapsed_seconds / 6) - hints_used * 60
       - tests_run * 5 + discovered_clues * 20)
```

Only an explicit test action increments `tests_run`. Deployment's internal test run does not. `OS.execute` is synchronous, so this implementation is not a promise of elapsed wall-clock accuracy during command execution.

Proposed: budget time for reading, experiments, walking, and recovery. Let the incident clock continue during in-world documentation and note-taking, while an explicit pause freezes gameplay. Adopt or replace this policy before timed slices. Define how runner execution affects clocks. Displayed bypass time and actual expiry must follow the same policy. “Roughly three minutes” is an earlier example, not an accepted duration.

The existing score discourages tests and hints and rewards clue clicks. Review those incentives before progression; do not automatically treat them as the new educational success measure.

## 8. Configuration and decision gates

Extend existing `level.json` content only when a slice needs data. Keep enforcement in the responsible script. Do not add a configuration framework. G-01 through G-17 require these remaining decisions:

| ID | Decision | Resolve before |
| --- | --- | --- |
| D-01 | Notebook format, privacy, and persistence beyond a run. | Notebook slice. |
| D-02 | Drive acquisition, activation, duration, coverage, reuse, and recovery. | Drive slice. |
| D-03 | Concrete route procedures, evidence, rule precedence, and switching. | Scenario route slices. |
| D-04 | Reading, pause, runner, and bypass clock behavior. | Timed bypass integration. |
| D-05 | Workload tiers, thresholds, cap, score incentives, and time budgets. | Progression slice. |
| D-06 | Supported runtime versions and approved offline reference coverage. | Reference slice. |
| D-07 | Agreement clauses, signing presentation, refusal-to-sign behavior, and the physical disclosure/retaliation evidence chain. | Opening and refusal-record slices. |
| D-08 | Message wording, actual observation limits, IT-wipe disclosure and retention, mission numbering, and handoff controls. | Messenger and handoff slices. |
| D-09 | Medium persona, difficulty selection, pressure differences, helper-detection consequences, and relation to workload tiers. | Persona or difficulty behavior slices. |
| D-10 | Dantalion allowance, response costs, qualifying investigative milestones, reset/credit rules, tutorial access, and account/difficulty persistence. | Dantalion quota slice. |
| D-11 | First construction lesson for the accepted basic-coder audience, curriculum, editing/test surfaces, pressure, transfer checks, and baseline criteria before introductory lessons. | Construction exercise slice. |
| D-12 | Practice app type, meaning of environment, runtime/isolation, lifecycle, durable storage, preview, distribution/offline coverage, packages/network access, and guidance/allowance rules. | Any runnable practice spike or delivery. |
| D-13 | Indubitably text/location/interactivity, post-stage quit/continue controls, resignation consequences, return presentation, and any discoverable career-pressure mechanics. Quitting eligibility after every stage is settled. | Indubitably or resignation/return behavior. |
| D-14 | Campaign/evidence beats, authored multiple-ending conditions, departure/disclosure choices, post-quit reporting, submission/identity controls, and resignation/shutdown/employment aftermath. Pirates-style retirement scoring is deferred. | Resignation outcomes, later campaign content, or finale. |
| D-15 | Spatial layout and door/cab access are implemented under ADR-0021: north staff passage, upper break room/lobby, paired static cabs with one 6 m descent/return, lower landing and west exit corridor. Scripted collision traversal, rendered views, and the user's manual round trip passed; provisional dimensions can change after player review. | Final puzzle/access gates remain D-16/D-03. |
| D-16 | Elevator puzzle/sequence, clue sources, input feedback/reset, observation and wrong-input consequences; dogs, reserved-snack acquisition/use, viable evasion, retry clocks/state beyond the accepted entrance/snack reset, wasted-snack recovery without capture, and route evidence access. | Elevator puzzle or guard-dog encounter slices. |
| D-17 | Quake-style movement tuning, jump input/timing, momentum, stopping and teaching; later secret-room access, pad/course progression, resets, rewards and clock policy. | Controller slice; settle later course details only before minigame work. |

Record a consequential choice in a new immutable ADR, then update the living documents. Gates apply to dependent work, not to unrelated authorized documentation.

## 9. Local data and access

G-01/G-02/G-06/G-08: Panopticon is a fictional game system. Do not add real screen capture, employee monitoring, telemetry, or external communication to implement it. The drive's surveillance replay is simulated in the game.

Continue using local sandbox copies of authored incident files. The present Node runner executes local code and is not a security sandbox for downloaded or untrusted incident packs. Such packs are outside this release. Notebook, evidence, and reference content stay local. Avoid adding network access, credentials, accounts, or cloud storage.

Indubitably profiles, jobs, hiring messages, news, and authority reporting are fictional local game content. No real job-network integration, employer contact, applications, personal-data collection, or reporting service is implied. A later exposure action affects authored game state only.

Practice's execution and local preview require an explicit separate contract under D-12; current host execution is not proof of confinement. Proposed checks cover project-only storage access, host environment/credential exclusion, process/resource limits, restricted network access with a working local preview, and owned-process cleanup. Container control must remain outside player code. Specific enforcement, installation, and runtime provisioning require approval; nothing is installed or launched by the research spike.

## 10. Delivery and evidence

Target the existing Windows desktop prototype first. Preserve the Godot/GDScript and local Node arrangement. Export templates and runtime distribution are release decisions, not requirements to install tools during this session. An editor run is not proof of a distributable build.

Each completed slice must update its as-built behavior here, cite its capability IDs and governing ADR, and record actual automated and playtest results in [session continuity](../SESSION_CONTINUITY.md). Use the [plan](IMPLEMENTATION_PLAN.md) for execution steps. This session supplies documentation only; none of the proposed mechanics has been implemented.

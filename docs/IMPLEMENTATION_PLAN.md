# Legacy Incident Escape Room Implementation Plan

Last updated: 2026-10-04. Status: phased planning draft. This wrap-up publishes documentation. The next session is authorized to build the first-level spatial baseline under G-18; other slices retain their design gates.

**Goal:** deliver one playable work shift connecting real debugging, surveillance resistance, evidence recording, and two ways to get home for the night, then a scoped construction exercise for basic coders. Establish a limited next-day handoff. Investigate optional real-app practice now; keep its delivery and the later campaign finale separate from the core skeleton.

**Architecture:** extend the existing office, workstation, Panopticon, level content, and local runner. Each slice includes its player surface, behavior, content, tests, and documentation. Do not build separate infrastructure layers before a player can use the feature.

**Stack:** Godot 4.7 standard, GDScript, local Node/JavaScript ES modules and `node:test`, existing Python/Blender asset tooling.

**Next session:** follow the [continuation prompt](CONTINUATION_PROMPT.md), resolve D-15's circulation/elevator choice, and deliver slices 0.2–0.4. Establish physical space before implementing the remaining first-shift systems. Pirates-style retirement scoring is deferred; later puzzle packs are a conditional possibility, outside this plan's current delivery.

Sources: [PRD](PRD-legacy-incident-escape-room.md), [product specification](PRS-legacy-incident-escape-room.md), [ADRs](decisions/README.md), and [AGENTS.md](../AGENTS.md).

## Global constraints

- Preserve current code, assets, user drafts, and unrelated work.
- Retain the existing stack. Approve dependencies or architectural expansion before introducing them.
- Leave the shipped incident intentionally broken. Solved-state checks use isolated copies.
- Both repair and refusal can escape. Each supplies distinct puzzle clues and crime evidence.
- Dystopian absurdism governs the story. Ordinary escape means going home tonight, with another shift the next workday; refusal of the assignment does not automatically resign.
- After every completed shift/stage, both routes offer quitting or continuing employment. Several endings are required. Indubitably career pressure helps explain choosing return; controls, interactivity, and resignation outcomes remain D-13/D-14 choices.
- Preserve the candidate ending: evidence including murder prompts authorities to close Rifkin; the celebrated player then faces lost income and rejection by similarly abusive employers. Finale conditions remain D-14; do not make nightly exit depend on that ending.
- Open with fictional employment-agreement and NDA signing. Refusal-route physical records subtly connect employee murders to threats to break NDAs and expose the company.
- First-mission employee messages establish suspicion, before IT wipes the inherited workstation and supplies the player's own accounts for mission two.
- Keep the core story consistent across difficulty-specific Joel personas. Medium Joel and all helper-detection penalties require design decisions.
- Dantalion is an apparent LLM on a very limited fictional free plan. Investigative task completion is a prerequisite for earning credits/refreshing allowance; quotas and exact milestones remain open.
- Program construction is an explicit learning goal for players who can write basic code but struggle with program structure. Choose the exercise before expanding editing surfaces; keep refusal escape independent of construction or repair. Defer absolute beginner instruction until the core baseline.
- Optional practice mode is a research direction. Its environment, app type, lifecycle, persistent storage, preview, and guidance require D-12 decisions before a runnable proof or implementation; no installation or architecture expansion is approved by research.
- Post-tutorial players choose what matters and what to record. Hints remain optional.
- Consequential restrictions must be discoverable. Detection and expiry must have defined consequences and recovery.
- Numerical tuning, notebook medium, exact bypass behavior, and offline runtime coverage remain design gates in the specification.
- Work through manageable slices. Split a slice further if it cannot produce an independently testable player outcome in one review cycle.

## Cycle for every implementation slice

1. Read only affected code, its closest existing analogue, and relevant tests. Resolve the slice's open design gate.
2. Write one failing behavior test. Run it and confirm the expected assertion fails before implementation.
3. Add the smallest change that makes the test pass. Add further tests only for the slice's required behaviors or reachable regressions.
4. Run the relevant regression checks. Review the playable flow manually for readability, atmosphere, controls, and comprehension.
5. Update the specification's as-built section, any changed plan steps, and concise session continuity. Add an ADR only for a durable why/how decision.
6. Record one observed development or playtest lesson, try one process improvement in the next slice, and retain it only if useful.

Keep small red/green steps within each slice. Refactor only touched code when the passing test demonstrates safety. Do not commit or push without authorization. The plan describes behavior and verification, not premature code signatures for unsettled designs.

## Phase 0 — Establish the project contract

### Slice 0.1: Documentation and scenario decisions — G-01 through G-18

- [x] Create AGENTS.md, PRD, product specification, immutable ADRs, phase plan, and continuity.
- [x] Record the accepted repair/refusal choice and distinct puzzle/crime evidence.
- [x] Record the accepted signing opening and subtle physical evidence of murders after threatened disclosures.
- [x] Record suspicion-first messenger rumors, the IT handoff, and accepted easiest/hardest Joel personas. Keep medium Joel proposed.
- [x] Record Dantalion's name, free-plan scarcity, and task-earned reset requirement.
- [x] Record investigative prerequisites for credits and the explicit program-construction learning goal.
- [x] Record the initial basic-coder audience, deferred introductory lessons, and optional real-app practice investigation.
- [x] Complete the [practice feasibility research spike](spikes/2026-10-03-practice-mode-feasibility.md). This is source/architecture research; runnable validation remains pending.
- [x] Record nightly shift escapes, dystopian absurdism, Indubitably career pressure, and the candidate exposure ending. Keep app mechanics and finale conditions open.
- [x] Record multiple endings and the option to quit after every completed stage on either route; keep outcome details and post-quit reporting open.
- [x] Defer Pirates-style retirement scoring, retain the established story, and prepare the requested first-level building continuation.
- [ ] Review the proposed “Release Pending” example and resolve each remaining decision immediately before its dependent slice.

**Files:** the documentation linked above. **Proof:** links resolve, capability IDs align, accepted and proposed behavior are distinct, and the diff contains only authorized documentation. No gameplay tests are needed for this slice.

### Slice 0.2: Walk from the office to the break room — G-18

**Player outcome:** leave the existing office through a genuine opening, enter a recognizable break room, and return to the workstation.

**Gate:** D-15 circulation sequence. **Likely files:** `scripts/build-rifkin-office.py`, generated `assets/blender/rifkin_office.blend` and `godot/assets/office/rifkin_office.glb`, `godot/scripts/office_room.gd`, and the existing scene only where needed. Preserve existing named objects and coordinates referenced by interactions/tests.

- [ ] Review a compact layout in the existing office's scale. Split the wall behind the service door and provide floor support; clearing the decorative leaf alone is insufficient.
- [ ] Red/green for any new door or collision behavior: prove the approved passage is usable and closed geometry blocks movement where intended, then make the smallest consistent change. Use visual review for furniture/art rather than tests that merely repeat mesh coordinates.
- [ ] Add a modest break room using existing materials and asset patterns. Leave exact future clue placement and surveillance rules undecided.
- [ ] Verify: walk office → break room → workstation; inspect player clearance, floor seams, lighting, and preserved workstation/notice/net interactions.

### Slice 0.3: Reach and use the approved elevator area — G-18

**Player outcome:** reach the elevator from the office/break-room connection and use whatever bounded function D-15 selects.

**Gate:** D-15 elevator purpose and circulation; travel is not implicitly required by adding an elevator prop. **Depends on:** 0.2. **Likely files:** the same asset generator/exports and local room interaction/collision code; extend the current raycast/action branches instead of adding a general interaction framework.

- [ ] Red: if doors or travel are selected, a focused integration check exercises the reviewed interaction, destination, and return. Do not test hypothetical floors or failure modes.
- [ ] Green: build the recognizable elevator area and the selected cab/door/travel behavior. Use one useful connection; no tower, floor-selection system, or campaign transition is required.
- [ ] Verify: inspect access, controls, door clearance, and return to the workstation in the running game. Preserve mouse capture and existing prompts.

### Slice 0.4: Follow the long corridor to the exit — G-18

**Player outcome:** follow the approved circulation from the office/elevator into a long corridor, reach an identifiable exit, and return through all operative spaces.

**Gate:** D-15 exit location; future locked-release rules remain D-03 work. **Depends on:** 0.2 and 0.3. **Likely files:** the same geometry/collision surfaces; adjust lighting or camera range only where the selected layout demonstrates a need.

- [ ] Build the corridor and recognizable exit using the existing scale/materials. Check that camera clipping does not erase the intended long sightline.
- [ ] Verify focused movement/interaction behavior and run both existing headless integration checks. Walk the complete route manually to find collision seams, obstructing props, unreadable signs, and lighting issues.
- [ ] Update as-built layout, D-15's chosen scope, and continuity. Record a consequential how/why choice in a new ADR. Physical arrival at the exit does not claim nightly release, route completion, resignation, or a campaign ending.

These spatial slices establish the operative building only. The NDA, messenger, notebook, helper credits, surveillance resistance, route puzzles, and campaign choices retain their existing later slices. Do not bundle them into the geometry task.

## Phase 1 — Introduce coercion and teach evidence ownership

### Slice 1.0: Sign the welcoming agreements — G-07, G-10

**Player outcome:** encounter the NDA's politely worded but absurdly abusive terms alongside the employment agreement, sign in the game, and enter the normal tutorial.

**Gates:** D-07 final clauses, presentation, and refusal-to-sign behavior; D-04 when the incident clock begins. **Likely files:** `godot/scripts/office_room.gd`, `godot/scripts/main.gd`, existing authored level content, `godot/tests/gameplay_integration.gd`. Add art only if the approved presentation requires it.

- [ ] Red: the game presents both readable agreements before normal incident play, records the character's signing, and follows the approved unsigned-state behavior.
- [ ] Green: implement the opening in the existing UI and content pattern, then transition into the tutorial without exposing the later murder connection.
- [ ] Verify: inspect the actual text for readable abusive terms beneath its courteous tone; verify the chosen clock policy and later access to the documents. Use fictional signing controls, not real personal information or an external service.

### Slice 1.1: Record a chosen observation — G-06

**Player outcome:** read a notice or incident document, deliberately save an excerpt or personal note, leave the workstation, and retrieve it.

**Gate:** D-01 notebook format, privacy, and per-run persistence. Cross-launch persistence may remain outside this slice. **Depends on:** 1.0 for the opening's agreed transition into the tutorial.

**Likely files:** `godot/scripts/main.gd`, `godot/scripts/office_room.gd`, `godot/tests/gameplay_integration.gd`. Add a notebook script only if the chosen surface needs its own ownership.

- [ ] Red: a player-created entry survives leaving and reopening the workstation; reading alone creates no entry.
- [ ] Green: integrate one document-to-note interaction with the selected notebook surface.
- [ ] Verify: record a personal hypothesis, copy an excerpt if approved, and return from the room without losing either notes or editor drafts.

### Slice 1.2: Tutorial responsibility and independent play — G-06, G-07

**Player outcome:** practice choosing what to record during the tutorial, then read an unmarked post-tutorial source without automatic clue selection.

**Depends on:** 1.1. **Likely files:** `godot/scripts/main.gd`, `godot/levels/night_shift_checkout/level.json`, `godot/tests/gameplay_integration.gd`.

- [ ] Red: the tutorial teaches manual recording; the post-tutorial flow creates no important-clue label or automatic deduction.
- [ ] Green: add the practice interaction and scope existing clue guidance to the tutorial. Keep requested helper hints usable.
- [ ] Verify: distinguish a readable interaction prompt from a solution hint. Remove click-to-collect incentives only within the approved scoring change.

### Slice 1.3: Read inherited employee-group messages — G-06, G-10, G-11

**Player outcome:** inspect old messages during mission one, notice rumors about disappearances and turnover, and choose whether to record them.

**Gate:** D-08 message content and actual surveillance limits. **Depends on:** 1.1 and 1.2. **Likely files:** `godot/scripts/main.gd`, authored level/message content, `godot/tests/gameplay_integration.gd`; touch Panopticon only for the approved observation contract.

- [ ] Red: mission-one inherited accounts expose the approved conversation; reading alone writes no notes or murder conclusion; surveillance observes only the approved channels.
- [ ] Green: add the local message-reading surface and deliberate notebook excerpt action using existing UI/content patterns.
- [ ] Verify: thread chronology and speaker references support suspicion without proving murder. Test what the player can observe about Panopticon without making an unsupported safety promise.

### Slice 1.4: Earn another Dantalion allowance — G-07, G-08, G-13

**Player outcome:** complete an investigative task, earn Dantalion credits, request a hint, encounter the limited allowance, and perform another qualifying investigation to refresh it.

**Gate:** D-10 quota, response costs, qualifying investigative milestones, reset rules, and initial tutorial teaching. **Depends on:** 1.2 and its optional hint flow. **Likely files:** `godot/scripts/main.gd`, authored hint/task content in existing level data, `godot/tests/gameplay_integration.gd`; touch room interactions only for approved physical reset tasks.

- [ ] Red: credit grants require completed investigative tasks; a hint consumes the reviewed unit, exhaustion blocks new responses, and the next approved milestone grants exactly the reviewed amount. The clock or an unrelated chore does not reset usage.
- [ ] Red: already-completed or repeated actions follow the approved credit rule; prior responses and notes survive quota refresh; offline documentation remains outside the quota.
- [ ] Green: integrate the quota, one qualifying task, visible usage feedback, and refresh teaching with the existing local hint ladder. Do not add a real LLM service.
- [ ] Verify: each route has an accessible refresh opportunity under the reviewed task model, without first solving the problem that needed help. Check that allowance refresh leaves Panopticon's records intact and does not make detection consequences quietly accumulate.

## Phase 2 — Make resistance change what the player can do

### Slice 2.1: One observable surveillance rule — G-02, G-04

**Player outcome:** encounter a published absence rule, test it safely, and observe its actual access consequence.

**Gate:** one channel's coverage, detection threshold, advance notice, and recovery. **Likely files:** `godot/scripts/panopticon.gd`, `godot/scripts/office_room.gd`, `godot/tests/surveillance_integration.gd`, and notice content in the existing asset workflow.

- [ ] Red: a reachable observed violation changes access; a recoverable warning permits return; random notices do not impose penalties.
- [ ] Green: connect the existing observed-action path to that one rule and consequence.
- [ ] Verify: the player can discover enforcement before risking a route. Preserve drafts and notes after the warning.

### Slice 2.2: Borrow, activate, verify, and expire the drive — G-02, G-03

**Player outcome:** obtain the drive without already needing it, activate it, verify cover, investigate one desk, and return before or after expiry.

**Gates:** D-02 drive behavior and D-04 clocks. **Depends on:** 2.1 and notebook surface from 1.1. **Likely files:** `godot/scripts/office_room.gd`, `godot/scripts/panopticon.gd`, `godot/scripts/main.gd`, `godot/tests/surveillance_integration.gd`; touch office scene/assets only for required interactions.

- [ ] Red: covered observations suppress the defined access consequence; uncovered observations still apply; displayed time agrees with actual expiry.
- [ ] Green: implement the approved acquisition, recording, activation, and duration flow for one paired workstation.
- [ ] Verify: try one deliberate risky action, inspect proof of spoofing, let protection expire, and execute the approved recovery. Test approved reuse only if included in the chosen contract.

### Slice 2.3: Teach surveillance controls and recovery — G-02, G-03, G-07

**Player outcome:** complete a safe tutorial drill, recognize covered and uncovered observations, verify the bypass, and recover when it expires.

**Depends on:** 2.1 and 2.2. **Likely files:** `godot/scripts/office_room.gd`, `godot/scripts/main.gd`, tutorial level content, `godot/tests/gameplay_integration.gd`, `godot/tests/surveillance_integration.gd`.

- [ ] Red: the tutorial teaches the approved coverage, activation feedback, expiry, and recovery rules; its practice failure leaves the player able to continue.
- [ ] Green: integrate the drill with the real mechanics. Preserve the manual notebook lesson from 1.2 and keep post-tutorial solution guidance optional.
- [ ] Verify: a player can explain what is covered and demonstrate recovery. Teach the mechanic without revealing either post-tutorial escape procedure or identifying its important clues.

## Phase 3 — Complete both evidence-bearing escape routes

### Slice 3.1: Repair opens an escape opportunity — G-01, G-04, G-09

**Player outcome:** complete the real incident, use the posted verification exception, obtain that route's puzzle clue and crime evidence, and depart home for the night.

**Gate:** D-03 approved route procedures and fictional records. **Depends on:** phases 1 and 2. **Likely files:** `godot/scripts/main.gd`, `godot/scripts/office_room.gd`, `godot/levels/night_shift_checkout/level.json`, `godot/tests/gameplay_integration.gd`. Add scenario content in the existing level directory pattern only if a distinct incident is approved.

- [ ] Red: the untouched incident rejects deployment; a solved disposable copy passes tests and replay; acceptance alone does not mark escape; the physical procedure ends this shift without automatically resigning or ending the campaign.
- [ ] Green: connect validated repair to the approved access opportunity, route-specific records, and physical exit outcome.
- [ ] Verify: follow this route without any refusal-only clue. Confirm notes preserve the source of its crime evidence and the original puzzle source remains broken.

### Slice 3.2: Refuse the assignment and escape — G-01, G-02, G-03, G-04, G-09, G-10

**Player outcome:** use surveillance cover and a discoverable maintenance exception to get home for the night with the incident unresolved, collecting different puzzle clues and subtle physical evidence of murders after threatened NDA disclosures.

**Gates:** D-03 route procedure and D-07 approved physical records. **Depends on:** 3.1's physical exit behavior, the approved bypass, and the agreement content from 1.0. **Likely files:** `godot/scripts/office_room.gd`, `godot/scripts/panopticon.gd`, existing level content, `godot/tests/gameplay_integration.gd`, `godot/tests/surveillance_integration.gd`.

- [ ] Red: refusal can end the shift while deploy still fails, without resignation or final exposure; its puzzle and crime evidence differ from repair's; it needs no repair-only clue.
- [ ] Red: the approved physical records are reachable and preserve the authored identities, dates, and NDA references without automatic accusation labels or notebook deductions.
- [ ] Green: add the approved alternate procedure and subtle disclosure/retaliation records using the same room interaction patterns.
- [ ] Verify: complete the route from the intentionally broken start and test detection recovery. In playtesting, check whether players can infer the threat/death connection without an explicit explanation. Avoid route-switching machinery unless the design requires it.

### Slice 3.3: Evening reflection after departure — G-01, G-06, G-09, G-10, G-16

**Player outcome:** reach the evening after the shift, inspect chosen records and personal notes, and recognize what the route revealed about the company. This is a nightly interlude, not the campaign ending.

**Depends on:** 3.1 and 3.2. **Likely files:** `godot/scripts/office_room.gd`, `godot/scripts/main.gd`, level ending content, `godot/tests/gameplay_integration.gd`.

- [ ] Red: the approved evening review retains that shift's evidence/notes, requires no all-evidence completion, and neither rewrites deductions nor sets final campaign completion. Resolve retention beyond this review under D-01/D-08.
- [ ] Green: add an evidence review with the approved evening presentation.
- [ ] Verify: a playtester can describe the clue's relevance and one transferable reasoning lesson. Treat this as observed feedback, not proof that a shocking scene improves memory.
- [ ] Verify: the refusal ending preserves subtlety and the player's own deductions instead of automatically declaring every inferred murder or disclosure connection.

### Slice 3.4: Construct one small behavior and adapt it — G-01, G-07, G-09, G-14

**Player outcome:** turn a stated requirement into a small runnable program behavior, choose examples, build and verify it, then adapt it to a changed requirement.

**Gate:** D-11 lesson for the accepted basic-coder audience, curriculum, editing/test surfaces, and pressure. **Depends on:** the current incident tools and a complete escape scenario; direct construction practice remains optional for a refusal playthrough. **Likely files:** `godot/scripts/main.gd`, scoped construction exercise content using the existing level/sandbox pattern, `godot/tests/gameplay_integration.gd`; touch `godot/tools/level_runner.mjs` only if the approved verification surface requires it.

- [ ] Red: the exercise accepts the chosen behavioral examples and rejects a concrete incorrect implementation; the original puzzle source stays broken, and refusal escape has no exercise-completion gate.
- [ ] Green: integrate one construction task, its runnable checks, and its approved tutorial surface. Start with the existing editor if it can support the lesson; explain and approve any necessary expansion before implementation.
- [ ] Verify: the player can state the contract, explain responsibility choices, and meet a changed requirement without a supplied solution. Judge behavior and tradeoffs instead of one prescribed code layout.
- [ ] Playtest: observe comprehension first, then combine the method with approved pressure. Record which decisions transfer and which require teaching changes.

### Slice 3.5: Choose resignation or another shift — G-01, G-16, G-17

**Player outcome:** after completing a stage through either route, explicitly choose quitting or continued employment. Continuation leads to the next-day handoff; quitting follows its approved outcome.

**Gates:** D-13 controls and D-14 first resignation outcome, including whether reporting remains available; D-01/D-08 any retained evidence/notes used by that outcome. **Depends on:** nightly completion and 3.3's interlude, not optional construction exercise 3.4. **Likely files:** existing room/workstation UI and local authored outcome content, `godot/tests/gameplay_integration.gd`. Use existing state ownership; no general branching-narrative framework.

- [ ] Red: each completed stage exposes quitting on repair and refusal without a code-repair, optional-exercise, or crime-evidence gate. Going home alone does not resign.
- [ ] Red: the explicit quit choice follows the reviewed outcome and does not start the next shift; continuing permits the next-day handoff. Verify the full return with 4.0. Test supported stages as introduced rather than hypothetical future levels.
- [ ] Green: add the two choices and the reviewed first resignation outcome, keeping employment and shift completion distinct.
- [ ] Verify: both routes reach both choices. Outcome content uses only the retained information allowed by its contract and does not invent deductions or label resignation a universal bad ending. Exact additional endings follow later reviewed slices.

## Phase 4 — Support informed choices under bounded pressure

### Slice 4.0: Return for the next shift and IT handoff — G-06, G-11, G-16

**Player outcome:** return on the next workday, encounter IT's handoff, lose the inherited account access as designed, and receive personal work email and credentials before the second shift/mission. Tutorial-to-workday numbering remains D-08.

**Gate:** D-08 wipe scope, retained notes, disclosure, controls, and mission numbering; D-10 Dantalion account/allowance behavior across the handoff. **Depends on:** 1.3, the approved mission-one completion, and continued employment selected in 3.5. **Likely files:** `godot/scripts/main.gd`, `godot/scripts/office_room.gd`, authored handoff/account content, `godot/tests/gameplay_integration.gd`.

- [ ] Red: continued employment reaches the next-day handoff before mission two; resignation does not. The handoff replaces inherited accounts, removes only approved in-game state, and preserves whatever the reviewed retention contract specifies.
- [ ] Green: implement the local narrative/account transition without touching real user files or treating the incident-reset button as the handoff.
- [ ] Verify: inspect transition disclosure, chosen notebook retention, and next-route solvability. The slice proves the handoff without requiring a complete new incident pack.

### Slice 4.1: Search a neutral offline reference — G-07, G-08

**Player outcome:** identify the scenario's runtime version, search a topic, read an ordinary example, and return to the editor.

**Gates:** D-06 version and coverage, D-04 reading/clock policy. **Likely files:** `godot/scripts/main.gd`, scenario reference content and `level.json`, `godot/tests/gameplay_integration.gd`.

- [ ] Red: search opens the selected result offline, shows correct version metadata, and never auto-selects a fix page from puzzle state.
- [ ] Green: implement that search-and-read flow with locally authored or permitted reference material.
- [ ] Verify: a clean environment uses the documented runtime; examples execute there; reading follows the agreed pressure policy. Use primary documentation to verify technical content.

### Slice 4.2: Competence brings bounded extra work — G-05

**Player outcome:** see the next assignment's harder workload and tighter published deadline after particularly fast completion, while gaining a useful advantage from competent play.

**Gate:** D-05 tiers, cap, scoring, measurement, and time budgets. **Depends on:** one complete escapable scenario and approved next-assignment content. **Likely files:** `godot/scripts/main.gd`, level assignment content, `godot/tests/gameplay_integration.gd`. No general scheduler is required.

- [ ] Red: promotion follows the chosen threshold, stops at the cap, and never secretly shortens the active assignment; ordinary and top-tier assignments remain escapable.
- [ ] Green: implement one promotion and its finite cap before adding more tiers.
- [ ] Verify: compare immediate reporting and deliberate delay. Each must have a useful tradeoff. Do not punish necessary testing or reference use through an unreviewed inherited score formula.

### Slice 4.3: One reviewed difficulty-specific Joel variation — G-02, G-05, G-07, G-12

**Player outcome:** replay the same story with a different Joel's personality and one concrete, discoverable pressure rule.

**Gate:** D-09 persona, mode selection, pressure, and helper consequences; D-10 any difficulty variation in Dantalion allowance. Medium Joel must be accepted before implementing that version. **Depends on:** a complete escapable scenario and its optional helper. **Likely files:** `godot/scripts/main.gd`, `godot/scripts/panopticon.gd`, authored persona/rule content, `godot/tests/surveillance_integration.gd`, `godot/tests/gameplay_integration.gd`.

- [ ] Red: the chosen mode presents the reviewed persona and rule, retains the core story and both escape routes, and enforces only the approved helper-detection consequence.
- [ ] Green: implement one variation with existing content dictionaries and action handling; do not build a generalized personality framework.
- [ ] Verify: make the consequence discoverable, bounded, and recoverable under its approved contract. Hints must remain useful. Keep mode identity separate from speed-driven workload escalation if that proposal is accepted.
- [ ] Expand to other reviewed personas only after the first variation works; keep hardest Joel's allegations presented as rumors and exact medium behavior undecided until approved.

### Slice 4.4: One Indubitably career-pressure interaction — G-04, G-16

**Player outcome:** encounter a fictional career message explaining fear of quitting's black mark and the reason to return for another shift.

**Gates:** D-13 location, interaction/text, return presentation, and any resignation consequences. **Depends on:** the nightly departure and scoped next-day transition; post-stage quitting itself is provided by 3.5. **Likely files:** existing workstation/room UI and authored local content, plus `godot/tests/gameplay_integration.gd`; approve any new scene or surface before expanding beyond those patterns.

- [ ] Red: approved local content is reachable at the chosen point, ordinary controls work, and the interaction does not silently resign, alter notes, or require completing job applications to escape.
- [ ] Green: integrate one readable fictional Indubitably exchange using the approved UI. Whether this app contains the required resignation control is a D-13 placement choice; application actions remain optional proposals.
- [ ] Verify: a player can explain the character's employment pressure. Any selected consequence matches a discoverable rule; no numeric career simulator or external service is introduced.

## Phase 5 — Learn from the complete slice before expansion

### Slice 5.1: Playtest, revise, and update the process — G-01 through G-14, G-16

**Outcome:** complete both routes in integrated play, review learning evidence, and choose the next content increment from observed problems.

**Files:** only files implicated by playtest findings, their tests, living documentation, and any new decision ADR.

- [ ] Record where players misunderstand controls, rules, coverage, version information, or evidence ownership. Separate those issues from intentional deduction challenges.
- [ ] Ask players to explain one experiment, one company revelation, and one lesson they would reuse elsewhere.
- [ ] Observe whether the agreement's courteous coercion becomes more meaningful when players connect the physical disclosure and death records. Revise clue legibility without adding an automatic explanation.
- [ ] Check whether early messages produce suspicion and whether the wipe respects the chosen evidence-retention contract. Compare persona-specific pressure without changing the core story.
- [ ] Check whether both routes produce a meaningful nightly release and whether return/Indubitably content makes the dystopian employment pressure legible.
- [ ] Check post-stage quitting availability on both routes, the reviewed resignation outcome, and continued employment's next-day transition. Keep future endings separate from first-shift verification.
- [ ] Check whether Dantalion's limited allowance encourages useful experiments or strands players who need help. Review task reachability and the combined effect of scarcity and Joel's sanctions.
- [ ] Check construction learning through the approved changed-requirement exercise and player explanations, rather than treating escape or test completion alone as evidence of design understanding.
- [ ] Turn a selected reproducible problem into a failing test and make one focused correction.
- [ ] Compare the next run with the original observation. Record one process improvement to keep, change, or discard.
- [ ] Consider another scenario only after both routes work and the relevant checks pass. Additional languages, cloud tools, and a distributable release need their own scoped decision.

## Candidate Phase 6 — Optional practice after the core baseline

Research is complete; placement here is a delivery proposal. Define the core baseline under D-11 and review D-12 before starting. Beginner fundamentals remain a separate later curriculum decision.

### Candidate slice 6.1: Create, run, use, and reopen one real app — G-08, G-14, G-15

**Player outcome:** outside story mode, create one supported environment/project, build a small app using reference and guidance, verify its behavior, interact with it, stop it, and recover project files and intended saved data after reopening.

**Gates:** D-12 app/runtime/isolation/persistence/preview/guidance, explicit implementation authorization, and any necessary dependency approval. **Depends on:** the reviewed core baseline. **Affected surfaces:** existing workstation editing/runner patterns and a separately scoped practice surface; exact modules depend on the approved backend. Avoid a general IDE or environment-management platform.

- [ ] Runnable proof: demonstrate one app end to end; test a candidate isolation boundary, process stop/recovery, local preview, persistence, and an offline cold start. Do not treat an external-browser proof as acceptance of in-game preview.
- [ ] Red: a focused integration check exposes the missing create/run/use/stop/reopen behavior; story resets and IT wipes do not erase practice projects or modify story progress. Add supported runtime-failure checks justified by the proof.
- [ ] Green: implement that one reviewed workflow and its controls. Use a defined runtime and built-in libraries first; broader package installation is a later decision.
- [ ] Verify: adapt one requirement and observe the player's explanation of responsibility choices. Record startup time, disk/memory use, setup friction, and actual isolation/lifecycle results before deciding distribution or expanding scope.

## Later campaign content — G-16, G-17

Several endings are required; the complete set remains later campaign work rather than an executable finale plan. The first reviewed resignation outcome belongs in slice 3.5. Outline learning/evidence beats across subsequent workdays before detailing their puzzles. D-14 must define ending conditions, evidence sufficiency, post-quit reporting, player choice, identity controls, and aftermath before each dependent slice. Keep nightly exit and quitting eligibility distinct from finale gates; no all-record condition may prevent resignation.

For the proposed exposure ending, future validation must distinguish successful fictional reporting/shutdown from the later hiring aftermath. Preserve employment consequences without undoing the shutdown. Verify authored evidence/chronology and player comprehension; no actual employer or authority is contacted. Exact files and vertical slices follow the accepted campaign design.

## Verification commands and expected results

From the repository root, with the project's Godot executable available:

```powershell
godot --headless --path godot --script res://tests/gameplay_integration.gd
godot --headless --path godot --script res://tests/surveillance_integration.gd
```

Expected: exit code 0 and each script's `PASS` summary. Use the existing [setup instructions](GODOT_SETUP.md) if the alias is unavailable. Their isolated user directories must remain separate from the player's sandbox.

In `godot/levels/night_shift_checkout/incident_repo`:

```powershell
npm test
npm run simulate
```

Expected for the shipped start: nonzero exit for the migrated discount mismatch. Expected after a correct fix in a disposable copy: both pass and runner deployment accepts. Do not patch the source fixture to make ordinary repository checks appear green.

For documentation changes, inspect links, decision status, capability coverage, and diff scope. For art or scene changes, inspect the affected view in the game. No gameplay tests were executed for the current documentation-only delivery.

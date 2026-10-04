# Legacy Incident Escape Room — Product Requirements Document

> Status: Draft requirements. Created: 2026-10-03. Updated: 2026-10-04. The first-level spatial baseline is implemented and playtested. Controller slice 0.5 and its 120 ms landing buffer are implemented and checked; human comparison with Quake 3/Quake Live and movement-feel retest remain pending. The specification distinguishes current behavior from future mechanics.

## 1. Purpose & vision

Create a fun, thought-provoking, educational first-person escape room inside Rifkin Software, an exploitative employer. The player investigates real coding incidents, explores, resists surveillance, and seeks escape. Work and escape affect each other, requiring technical reasoning and decisions about compliance.

The tone is **dystopian absurdism**. Each ordinary level is a work shift: escaping earns the right to go home for the night. After every completed shift/stage, players can quit or continue into the next workday's shift. Fear of damaging their employment record helps explain choosing to return. **Indubitably**, a fictional blend of a professional network and job-search app, communicates that quitting could put a black mark on their prospects. Shift structure is accepted under [ADR 0013](decisions/0013-dystopian-absurdism-and-shift-based-escapes.md); career pressure and the candidate ending follow [ADR 0014](decisions/0014-indubitably-career-pressure-and-candidate-exposure-ending.md). [ADR 0015](decisions/0015-multiple-endings-and-post-shift-resignation.md) requires multiple endings and the option to quit after each stage.

One envisioned darkly humorous ending has the player deliver smoking-gun proof of wrongdoing, including murder, to fictional authorities. Rifkin is shut down. Public heroism then makes other employers reject the player because those companies similarly mistreat their own workers. Without steady income, the character subtly wonders whether they did the right thing. This is a proposed ending direction, not the only accepted conclusion or a decided evidence gate. Exposure succeeds while the economic aftermath exposes a wider abusive system.

Several endings are required. Quitting is a genuine player option after each completed stage, whether the player repaired the incident or refused it. Exact outcomes, how evidence affects them, and whether investigation/reporting can continue after resignation remain undecided. Returning is the continuation branch rather than the only available choice.

Focus current delivery on the established story and its authored choices. The Pirates-style retirement/accomplishment model is deferred under [ADR 0016](decisions/0016-story-first-scope-and-deferred-retirement-scoring.md). It could be reconsidered if a successful game later supports a puzzle-pack product; that is a conditional idea, not a current roadmap commitment. Multiple endings and the option to quit after each stage remain required.

The operative first-level building is implemented: a connected break room, elevator area, and long corridor to the exit. These spaces give physical exploration and future escape puzzles a usable setting, without requiring the entire building to be modeled. [ADR 0017](decisions/0017-first-level-operative-building-expansion.md) records this scope; [ADR 0021](decisions/0021-bounded-elevator-transfer-and-first-level-layout.md) records the implemented layout and bounded descent/return. The elevator leads down toward the refusal route's exit corridor. For the later refusal route, a puzzle allows unauthorized descent; a button-order code is a promising option rather than a finalized solution. Guard dogs will discourage escape, with the reserved break-room snack providing an alternative when movement evasion is too difficult. [ADR 0018](decisions/0018-refusal-descent-and-guard-dog-alternatives.md) records the direction. If caught, the player must return to the corridor entrance with the snack restored if used, under [ADR 0020](decisions/0020-local-guard-dog-retry-and-snack-restoration.md). These puzzle/encounter mechanics remain unimplemented; exact clues, timing, and other retry details remain open.

Movement should feel similar to Quake 3 Arena, with strafe jumping available to build speed. Later, a secret office room offers jump pads and progressively harder movement courses inspired by defrag maps. Its enormous interior contradicts the building's narrow footprint: Rifkin's architecture is deliberately strange. This movement playground follows [ADR 0019](decisions/0019-quake-style-movement-and-impossible-practice-space.md). It is separate from real-app practice and does not make advanced movement a prerequisite for refusal.

The existing long exit corridor belongs exclusively to level one. Both repair and refusal must provide access to that shared exit to complete the stage. Each subsequent level's exit increases the movement challenge, under [ADR 0024](decisions/0024-shared-stage-exits-and-movement-progression.md). Exact mechanics, technique demands, teaching, difficulty, accessible alternatives, and recovery remain open. This required stage progression is distinct from the optional secret movement room. The user's Pomodoro-inspired variation alternates coding/reasoning with a task that uses the brain differently; any cognitive or learning benefit is a hypothesis to investigate, not an established outcome. Research suitable challenges and difficulty spikes after the user returns with controller comparison findings; no such research or delivery has occurred.

Memorable, jarring moments are a hypothesis for attention and learning, not proven research or a gore mandate. Players and developers should improve through observation, experiments, evidence, and reflection.

An explicit goal is to teach how to construct a computer program: turn a need into understandable, working behavior and make choices that support later changes. This extends the learning aim beyond recognizing syntax or fixing a supplied bug under [ADR 0010](decisions/0010-teach-program-construction-through-play.md). Initially serve players who can write basic code but struggle to organize programs. Absolute beginner lessons follow an established core-game baseline, under [ADR 0011](decisions/0011-initial-audience-and-deferred-beginner-lessons.md). Exact curriculum and baseline criteria remain open.

Investigate an optional **practice** space where players use the game's documentation and guidance to create environments, build their own real applications, and use those applications outside the story. This could let players apply construction skills to something they choose to make. [ADR 0012](decisions/0012-explore-optional-practice-mode.md) authorizes feasibility exploration; it does not select a runtime or approve implementation. See the [research spike](spikes/2026-10-03-practice-mode-feasibility.md).

The game opens with the character signing an employment agreement and a non-disclosure agreement (NDA), a promise of secrecy. Its absurdly abusive terms sound welcoming and considerate. Old employee messages on the first mission seed rumors about disappearances and unusual turnover. Later, physical records on the refusal route quietly suggest that the company murdered employees who threatened to break their NDAs and reveal what they knew. Players discover that connection through evidence rather than an explanation at the opening.

Product purpose follows [ADR 0001](decisions/0001-product-purpose-and-player-agency.md). Repair and refusal routes follow [ADR 0004](decisions/0004-repair-and-refusal-evidence-routes.md). Technical delivery belongs in the [product specification](PRS-legacy-incident-escape-room.md).

The signing opening and retaliatory murders follow [ADR 0005](decisions/0005-nda-onboarding-and-retaliatory-murder-evidence.md). These are accepted story requirements. Exact clauses and individual clues remain design proposals.

The first computer still has another employee's accounts logged in. Before the second mission, IT wipes it and finally supplies the player's own email access and credentials. An employee-established messenger appears outside Panopticon's view, offering a brief look at a group trying to understand missing colleagues. This progression follows [ADR 0006](decisions/0006-first-mission-messenger-rumors-and-it-handoff.md).

The company story remains the same across difficulty levels, but Joel changes. Distinct personalities give players another reason to try harder modes, following [ADR 0007](decisions/0007-difficulty-specific-joel-personas.md).

The apparent AI helper is **Dantalion**, intentionally named after the demon from the Ars Goetia. The player gets by on a very limited free subscription. Completing investigative tasks is a prerequisite for earning credits and refreshing allowance. The scarcity makes asking for help a choice; the game still needs to support independent investigation. This direction follows [ADR 0008](decisions/0008-dantalion-free-plan-and-task-earned-usage-reset.md) and [ADR 0009](decisions/0009-investigation-earned-dantalion-credits.md).

## 2. Players

Initial players can already write basic code and want help turning requirements into well-organized, working programs, alongside technical reasoning and an unsettling workplace story. The tutorial teaches game controls and expectations; optional help supports reasoning. Absolute beginner instruction is deferred until the game's functional skeleton provides a baseline.

The developer uses player observations and technical checks to revise this existing desktop game.

## 3. Value drivers → required capabilities

- Connected puzzles make coding, exploration, and escape part of one experience: G-01, G-03, G-04.
- Consequences make surveillance and resistance decisions matter: G-02, G-05.
- Player-managed evidence and optional assistance preserve reasoning: G-06, G-07, G-08.
- Experiments and reflection expose what players learned and what the design needs to change: G-09.
- The welcoming agreement and later physical records let players recognize how the company hides coercion and retaliation: G-10.
- Temporary access to old coworker conversations makes the first rumors personal and rewards chosen evidence recording: G-11.
- Different versions of Joel provide fresh workplace pressures when replaying the same underlying story: G-12.
- Limited Dantalion access connects optional assistance to the player's own activity: G-13.
- Program-construction practice helps players make a working program from a requirement and understand their design choices: G-14.
- A candidate practice space lets players apply the reference and guidance to real apps of their own, outside story progression: G-15.
- Nightly release and Indubitably's career pressure make continued employment part of the dystopian absurdism: G-16.
- Several endings give employment and investigation choices consequences, including the candidate exposure ending's economically bleak aftermath: G-17.
- A connected first-level building gives exploration and escape a physical setting: G-18.
- Learnable momentum and an optional surreal movement playground make physical skill another source of mastery: G-19, G-20.
- Shared stage exits with increasing movement challenge vary the activity between coding/reasoning and physical traversal: G-21. Cognitive benefit remains a hypothesis.

## 4. Capability catalog

| ID | Required player capability and intended outcome |
| --- | --- |
| G-01 | Earn the right to go home from the first post-tutorial shift through repair or refusal. Refusal does not require fixing the incident or resigning. Both routes reveal distinct notable puzzle clues and distinct evidence of company crimes. |
| G-02 | Observe Panopticon and attempt resistance. Successful bypasses change available actions. Their limits must be discoverable. |
| G-03 | Explore a borrowed thumb drive as a possible surveillance bypass. Test it before finalizing its role, reuse, and failure behavior. |
| G-04 | Discover Joel's rules and exploit a rule or loophole through action. Evidence must support the inference before its consequence becomes necessary. |
| G-05 | Receive harder later assignments and tighter deadlines after particularly fast completion. Escalation stops at a defined cap. Thresholds, deadlines, and the cap remain unresolved. |
| G-06 | Choose and record evidence in a manual notebook. After the tutorial, the game must not automatically identify key clues or write notebook entries. |
| G-07 | Learn how to choose what matters during the tutorial. Request optional Dantalion hints afterward, within the free-plan allowance. Dantalion must not write the coding solution. |
| G-08 | Search accurate, neutral offline technical documentation with visible version information. Documentation must not identify the incident fix or reveal escape answers. |
| G-09 | Compare experiments with results and reflect on changed understanding. Player observations inform development decisions. Unsupported conclusions remain hypotheses. |
| G-10 | Sign the fictional employment agreement and politely worded, absurdly abusive NDA at the opening. Discover subtle physical evidence on the refusal route connecting employee murders with threats to violate NDAs and go public. |
| G-11 | Read rumor breadcrumbs in an old employee-group messenger during mission one, while the workstation still uses inherited logins. Encounter IT's wipe and the player's own email and credentials before mission two. The messenger appears unobservable by Panopticon; guaranteed safety is not established. |
| G-12 | Encounter a different Joel persona at each difficulty while the core company story remains the same. Easiest Joel is a talented, overbearing engineer opposed to AI, with consequences for detected helper use. Hardest Joel is an incompetent nepotism hire guarding his privilege, with employee rumors of unwanted advances and elevated female-staff turnover. Medium Joel and exact consequences remain undecided. |
| G-13 | Use Dantalion's very limited fictional free subscription. Complete investigative tasks as a prerequisite for earning credits and refreshing allowance. Exact limits, eligible milestones, and credit/reset rules remain undecided. |
| G-14 | Practice constructing a program, including deciding what it must do and how to organize and verify it. Explain design choices and apply the learned method to a changed requirement. The curriculum and exercise format remain proposed. |
| G-15 | Investigate optional practice outside story mode: player-created environments that run functional player-built applications using the game's documentation and guidance. App types, environment technology, assistance, and delivery remain undecided; this is a research direction. |
| G-16 | Escape ordinary shifts to go home for the night, then choose quitting or continuing into the next workday after every completed stage, on either route. Encounter Indubitably career-pressure story elements explaining fear of quitting's black mark. Controls, consequences, app interactivity, and cross-shift retention remain open. |
| G-17 | Provide several endings. Preserve the candidate in which smoking-gun wrongdoing/murder evidence leads authorities to close Rifkin, followed by unemployment and employer rejection of the publicly celebrated player. Ending conditions, resignation aftermath, evidence effects, and post-quit reporting remain undecided. |
| G-18 | Explore the existing office, break room, descending elevator, and long corridor to the exit. Refusal uses an elevator puzzle and faces guard dogs, with the reserved break-room snack as an alternative to movement evasion. If caught, return to the corridor entrance and restore the snack if used. Exact puzzle, snack, dog, and remaining retry rules are open. Spatial arrival alone does not define shift completion. |
| G-19 | Move in a manner similar to Quake 3 Arena, using strafe jumping for acceleration. The approved controller and 120 ms landing buffer are implemented under ADRs 0022/0023; human comparison and feel review remain pending. Preserve learnable, consistent movement and usable ordinary controls. |
| G-20 | Later discover a secret room with jump pads and multiple movement courses of ascending difficulty, inspired by defrag strafe-jumping maps. Deliberately oversized interiors imply impossible space within Rifkin's narrow exterior. This optional movement minigame is distinct from real-app practice; details remain open. |
| G-21 | Reach a shared stage exit after either repair or refusal. The existing long corridor is exclusive to level one; each subsequent level's exit increases movement challenge. Preserve independent viable routes without requiring incident repair for refusal. Specific challenges, difficulty, teaching, accessible alternatives, feedback/retry/clock rules remain undecided. |

Each route must provide the essentials needed to complete it. Neither route requires the other route's unique clues. Distinct evidence must affect understanding, not merely reward collection. Complementary perspectives and replay value remain proposals.

G-01 through G-09 follow ADR 0001. G-01 also follows ADR 0004. Evidence-based delivery follows [ADR 0002](decisions/0002-documentation-and-test-driven-delivery.md).

G-10 follows ADR 0005 and extends G-01's refusal-route evidence. The company's retaliatory murders are story facts for the authors; the player must infer them from the records.

G-11 follows ADR 0006. Mission-one messages raise suspicion rather than prove murder. G-12 follows ADR 0007. Allegations about hardest Joel remain rumors in the player-facing story; they do not by themselves establish the cause of an employee's disappearance.

G-13 follows ADRs 0008 and 0009 and qualifies G-07's optional assistance. Usage refresh and Panopticon's record of assistance are separate concerns. A real language-model integration is not a product requirement. G-14 follows ADR 0010; it does not remove the refusal route's independence from incident repair.

ADR 0011 sets the initial audience and defers introductory lessons. G-15 follows ADR 0012. Practice participation cannot become an undisclosed story or refusal-route prerequisite. Its guidance and quota rules need their own decision rather than silently inheriting story-mode investigative credit rules.

G-16 follows ADRs 0013/0014/0015. Daily escape completes a shift; resignation is a separate available choice afterward. G-17 follows ADR 0015 for multiple endings and ADR 0014 for the candidate exposure conclusion. Neither route's nightly exit or access to quitting requires every crime record; final exposure conditions need a separate decision and cannot silently redefine those exits.

G-18 follows ADRs 0017/0018/0020/0021. The spatial baseline is implemented; concrete elevator-puzzle, dog, snack, and release procedures still need design beyond accepted local recovery. G-19/G-20 follow ADR 0019; controller slice 0.5 and its buffer are implemented under ADRs 0022/0023, with human comparison pending. G-21 follows ADR 0024 for shared stage exits and later movement progression. Preserve a viable reasoning route through the dogs, with skilled evasion as an alternative; the later movement room must not gate escape or required crime evidence.

## 5. Phased delivery

The [implementation plan](IMPLEMENTATION_PLAN.md) defines vertical slices, conditional on resolving each phase's blocking choices.

- **P0:** Establish documents and resolve design decisions needed for the first slice.
- **First-level spatial baseline and controller implemented:** the office, break room, descending elevator, and long corridor are connected and playtested. Controller and buffer checks pass; await the user's Quake 3/Quake Live comparison and human feel retest before encounter tuning or exit-challenge research.
- **P1:** Deliver agreement signing, the notebook/tutorial, mission-one messages, and one task-earned Dantalion refresh loop. Observe whether players can investigate with limited optional help.
- **P2:** Connect surveillance observations to consequences and test a thumb-drive bypass loop. Retain the device only if the experiment supports it.
- **P3:** Deliver one complete shift with real coding validation, repair and refusal routes, distinct puzzle and crime evidence, going home as a separate completion state, and the reviewed quit/continue choice afterward.
- **P3 construction extension:** for the accepted audience of basic coders, choose one small program-construction exercise and a changed requirement. Keep it separate from the mandatory steps of refusal escape.
- **P4:** Deliver the next-day IT handoff, neutral documentation, bounded next-assignment tiers, reviewed difficulty personas, and a scoped Indubitably story interaction. Resolve retention, helper consequences, app/quitting choices, versions, and caps before implementation.
- **P5:** Playtest, reflect, and revise before expanding content.
- **Practice research now; candidate P6 later:** investigate real app execution now. Decide whether to deliver one optional practice workflow after the core baseline, with runtime and integration choices reviewed separately. Introductory lessons also remain deferred until the baseline; their later order is unchosen.
- **Later campaign direction:** outline successive shifts and multiple endings, including resignation outcomes and the candidate exposure ending; detailed later puzzles, evidence thresholds, and finale delivery remain outside the first-shift baseline.
- **Later movement playground:** add the secret, impossibly large jump-pad room and progressively harder courses after the controller is validated; keep this separate from the first building expansion and optional real-app practice.
- **Later stage exits:** after the user's controller comparison, research suitable challenges/difficulty spikes matched to the movement requirements, then review D-03/D-17 before implementing increasing exit challenges. Both routes share each stage exit; the current corridor remains level-one-only.

## 6. Success evidence

Baselines, numerical targets, and learning gains remain unknown. Review observed behavior and player explanations:

- Can the player escape through repair and independently through refusal without fixing the incident?
- Does either shift exit get the player home without automatically resigning, closing Rifkin, or ending the campaign? Does the next-day return fit the career-pressure premise?
- After every completed stage, is quitting available on both routes without an evidence threshold or construction-exercise gate? Does choosing to continue start the next shift, while quitting follows the reviewed outcome instead of forcing return?
- Does each route expose distinct puzzle clues and crime evidence without requiring the other route's unique clues?
- Can the player explain a discovered surveillance rule and its limits?
- Does the notebook contain player-selected evidence after the tutorial?
- Can the player use technical documentation without finding puzzle answers there?
- Does the complete scenario distinguish restored service from escape?
- Can the player encounter the abusive signing terms at the opening, then infer retaliation from refusal-route physical records without an automatic explanation?
- Do first-mission messages create suspicion about missing coworkers without confirming murder?
- Does the transition explain the workstation wipe and replacement accounts before mission two?
- Does changing difficulty change Joel's personality without replacing the core story or making optional assistance unusable?
- Can the player see Dantalion's allowance, understand how to refresh it, and find a qualifying task before needing to solve the problem they wanted help with?
- Does an investigative task precede each approved grant of Dantalion credits?
- Can the player build a small working behavior, explain its organization, and adapt it to a changed requirement without receiving a completed solution?
- For a future runnable practice proof, can a player create a supported app, execute and interact with it, stop it, and recover its project and intended saved data after reopening? Can they explain a later change? These checks have not been run.
- Do Indubitably's story elements convey the fear of quitting without an arbitrary undisclosed reputation penalty? If the exposure ending is developed, do players recognize both the real shutdown and the career aftermath?
- Can the developer trace a revision to an observation or experiment?

Record confusion, hypotheses, hint use, and reasoning. Establish quantitative measures after initial playtests.

## 7. Relationship to the current game

The current game has a first-person office, one usable workstation, Panopticon notices, and Night Shift Checkout. Workstation tools include clues, editing, tests, simulation, deployment, timing, scoring, and a fixed hint ladder.

Opening clues currently grants score. Accepted deploy changes status and emits a surveillance event. It neither stops the clock nor completes escape. Future capabilities remain unimplemented.

The current game starts in the cubicle. It does not yet include agreement signing or the new physical records about murder and threatened disclosure.

It has no employee messenger, mission-to-mission IT handoff, or difficulty-specific Joel personas.

The current helper is a local fixed hint ladder, without the Dantalion brand, a free-plan quota, or task-earned resets. No real model service is integrated.

The current incident teaches repair of supplied source. It does not yet provide a dedicated program-construction exercise or demonstrate transfer to a later design problem.

It has no general practice project creation, persistent practice storage, running-app lifecycle, or app preview. Its current copied incident folder runs code on the host computer; it does not establish an isolated virtual machine.

It has no completed nightly-release/next-day campaign loop, Indubitably surface, resignation outcome, or authority-exposure ending.

Retain the current desktop stack and extend existing patterns under [ADR 0003](decisions/0003-retain-current-desktop-stack.md). Preserve unrelated behavior and avoid new dependencies unless an approved requirement needs them.

## 8. Risks & open decisions

Cosmetic surveillance, arbitrary rules, uncapped escalation, and answer-revealing documentation can undermine player reasoning. Test these risks through the phased slices.

Unresolved choices remain here:

- Does the notebook accept manual excerpts, free text, or both?
- What does the thumb drive do, and what governs reuse or failure?
- Which Joel rules, consequences, and physical routes define the first scenario?
- What timing, pause policy, assignment thresholds, and escalation caps apply?
- Which runtime and documentation versions form the supported learning environment?
- Which clauses, signing interactions, and physical records establish the NDA and murder connection? What happens if the player declines to sign?
- What can Panopticon actually observe in the messenger, and what survives the IT wipe? How do mission numbers align with the tutorial?
- Which medium Joel fits the game, and what discoverable, bounded consequences follow helper detection at each difficulty?
- Which investigative milestones earn Dantalion credits, how much is granted, what consumes it, and what survives account handoffs?
- Which construction exercise and learning checks serve basic coders who struggle with program structure? What observable core-game baseline permits later introductory instruction?
- Which app type should practice first support, and what must its environment isolate? How do app persistence, preview, offline use, and practice guidance work without entangling story progression?
- How is the accepted post-stage quitting choice presented, and what consequence follows? How interactive is Indubitably, and how are career restrictions communicated before any enforcement?
- Which endings fulfill the accepted multiple-ending requirement, and can a player report retained evidence after quitting? What evidence/action leads to the candidate shutdown ending, and what carries across nights? How do the tutorial and first workday map to shift numbers?
- Which elevator puzzle earns descent, and how are its rules, successful input, and mistakes communicated? Where can players learn the dog/snack interaction? After the accepted corridor-entrance retry/snack restoration, what clock and other reset rules apply, and what happens if the snack is wasted without being caught?
- Does the implemented controller capture the desired Quake feel in the user's comparison? Which later shared-exit challenges, technique demands, teaching, difficulty, accessible alternatives, feedback/retry/clock rules fit D-03/D-17? How should the separate optional secret movement room teach and escalate these skills?

Specific future timing, route-access procedures, challenge thresholds, and failure proposals remain unaccepted; controller timing is approved under ADRs 0022/0023.

## 9. Out of scope

The completed spatial baseline and controller do not implement nightly release or campaign outcomes. The [continuation prompt](CONTINUATION_PROMPT.md) scopes controller review; the elevator puzzle, dog/snack mechanics, later shared-exit challenges, and optional secret room remain separate work. Exit-challenge research waits for the user's controller comparison. The practice spike is research and read-only inspection; no runnable prototype was created. Initial delivery excludes multiplayer, cloud services, additional incident packs, and platform replacement. Practice delivery, general-purpose virtual machines, arbitrary package installation, and absolute beginner lessons are outside the approved core skeleton. Pirates-style retirement scoring and a puzzle-pack product are deferred. Indubitably uses fictional content; real job-platform connections and a general career simulator are not authorized. The proposed campaign ending does not expand the first-shift implementation scope. Educational effectiveness and thumb-drive mechanics remain unproven. Nightly escape does not require collecting every route's evidence.

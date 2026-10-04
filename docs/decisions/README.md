# Decision record index

ADRs record HOW/WHY. Statuses are historical; index/specification shows effective decisions.

| ADR | Recorded status | Effective decision |
| --- | --- | --- |
| [0001](0001-product-purpose-and-player-agency.md) | Accepted | Educational escape-room purpose/agency |
| [0002](0002-documentation-and-test-driven-delivery.md) | Accepted | WHY/HOW docs, TDD, vertical delivery/feedback |
| [0003](0003-retain-current-desktop-stack.md) | Accepted | Current desktop stack |
| [0004](0004-repair-and-refusal-evidence-routes.md) | Accepted | Independent repair/refusal; consequential puzzle/crime evidence |
| [0005](0005-nda-onboarding-and-retaliatory-murder-evidence.md) | Accepted | Fictional NDA onboarding; subtle retaliatory murder evidence |
| [0006](0006-first-mission-messenger-rumors-and-it-handoff.md) | Accepted | Messenger rumors; IT mission handoff |
| [0007](0007-difficulty-specific-joel-personas.md) | Accepted | Difficulty-specific Joel; shared story |
| [0008](0008-dantalion-free-plan-and-task-earned-usage-reset.md) | Accepted | Dantalion free plan/reset; eligibility: 0009 |
| [0009](0009-investigation-earned-dantalion-credits.md) | Accepted | Investigative Dantalion credit eligibility |
| [0010](0010-teach-program-construction-through-play.md) | Accepted | Program construction teaching |
| [0011](0011-initial-audience-and-deferred-beginner-lessons.md) | Accepted | Basic-code learners; beginner lessons deferred |
| [0012](0012-explore-optional-practice-mode.md) | Accepted exploration | Optional app-building practice feasibility; architecture undecided |
| [0013](0013-dystopian-absurdism-and-shift-based-escapes.md) | Accepted | Dystopian absurdism; early escapes end shifts |
| [0014](0014-indubitably-career-pressure-and-candidate-exposure-ending.md) | Accepted direction; candidate ending | Indubitably pressure; candidate exposure ending; resignation eligibility: 0015 |
| [0015](0015-multiple-endings-and-post-shift-resignation.md) | Accepted | Several endings; resignation after each completed shift |
| [0016](0016-story-first-scope-and-deferred-retirement-scoring.md) | Accepted | Authored story first; retirement scoring deferred |
| [0017](0017-first-level-operative-building-expansion.md) | Accepted next-session scope | Traversable first-level spaces; refusal descent: 0018 |
| [0018](0018-refusal-descent-and-guard-dog-alternatives.md) | Accepted direction; puzzle mechanism proposed | Refusal descent; dogs/snack; caught retry: 0020 |
| [0019](0019-quake-style-movement-and-impossible-practice-space.md) | Accepted direction; later courses | Strafe-jump acceleration; controller contract: 0022; impossible movement-practice space |
| [0020](0020-local-guard-dog-retry-and-snack-restoration.md) | Accepted | Corridor-entrance retry; used snack restored |
| [0021](0021-bounded-elevator-transfer-and-first-level-layout.md) | Implementation choice; validation pending at recording | D-15 spatial layout; paired cabs with one 6 m descent/return |
| [0022](0022-approved-strafe-jump-controller-contract.md) | User-approved contract; implementation and verification pending at recording | D-17 controller constants, held-Space landing behavior, modal input clearing, break-room lesson and walking speed HUD; press-latch timing: 0023 |
| [0023](0023-timed-landing-jump-buffer.md) | User-approved timing change; implementation and verification pending at recording | 120 ms prelanding Space request; release retains it, eligible ground consumes it before friction, expiry/reset clears it |
| [0024](0024-shared-stage-exits-and-movement-progression.md) | Accepted direction; later research and delivery | Level-one corridor shared after repair/refusal; later stage exits increase movement challenge; cognitive benefit is a hypothesis |

0004: escape needs no opposite-route records; optional all-evidence investigation remains unresolved.
0013 clarifies early escape as permission to go home, not resignation or permanent campaign exit.
0015 adds post-shift resignation without redefining either escape route.
0018 settles refusal-path descent; button order remains proposed. 0020 settles caught recovery; timer and other reset details remain open.
0021 records the agent's bounded layout/travel choice within the authorized continuation; the final puzzle and release gates remain separate. Subsequent passing integration checks, rendered review, and the user's successful manual input review are recorded in [session continuity](../../SESSION_CONTINUITY.md).
0022 settles controller slice 0.5 under 0019 without changing 0021's elevator transfer. Later secret-room, pad/course, reset, reward, and clock choices remain D-17 work; controller approval is not implementation or verification. Subsequent implementation, passing controller/route checks, and pending human playtest are recorded in the living specification and [session continuity](../../SESSION_CONTINUITY.md).
0023 replaces only the next-tick press latch used to implement 0022 with an approved 120 ms prelanding buffer after the user's movement feedback. Its implementation and passing focused, rendered controller/route, and headless regression checks are recorded in the [living specification](../PRS-legacy-incident-escape-room.md). Held-Space repetition, movement constants, and 60 Hz physics remain effective; improved responsiveness and retained challenge still require manual retest.
0024 adds G-21 shared stage-exit progression: the existing corridor belongs only to level one, both repair/refusal reach it, and later exits increase movement challenge. Research follows the user's controller comparison; D-03/D-17 retain concrete choices. Optional G-20 courses remain separate, and cognitive/learning benefit is unproven.

Recorded ADRs are immutable: never edit/renumber/delete. Corrections/status changes require numbered successors referencing predecessors; update index/specification. Label proposals; cite authorization.

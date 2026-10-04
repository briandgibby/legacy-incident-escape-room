# ADR 0024: Shared stage exits and movement progression

- Date: 2026-10-04
- Status at recording: Accepted direction; challenge research and delivery deferred
- Source: Explicit user direction that the existing long exit corridor belongs exclusively to level one, is accessible after either repair or refusal to complete the stage, and that subsequent exits increase movement challenge. The user wants to compare the controller with Quake 3/Quake Live before further work.
- Supersedes: None; clarifies shared stage-exit access under ADRs 0004/0013/0018/0021 and adds progression distinct from ADR 0019's optional secret movement room. ADRs 0022/0023 remain the effective controller contract.

## Context

The current building includes a long corridor to a recognizable but non-functional nightly exit. Its spatial implementation permits traversal without repair; route-specific access and stage completion are still future behavior. The controller and 120 ms prelanding buffer are implemented and checked, with human comparison/feel review pending.

The user describes a Pomodoro-inspired variation: alternate coding/reasoning with a task that uses the brain differently. Any cognitive or learning benefit is a hypothesis, not established evidence or a selected timing schedule.

## Decision

Reserve the existing long exit corridor for level one. Both repair and refusal must provide access to this shared exit so the player can complete the stage. Each subsequent level's exit should increase the movement challenge rather than reuse that corridor for every stage. Track this direction as G-21.

Preserve independent viable routes and their distinct evidence. Refusal must not require fixing the incident, collecting repair-only clues, or completing the optional secret movement room. Keep the accepted first-level snack alternative to skilled dog evasion.

Stop implementation and challenge research for the user's Quake 3/Quake Live comparison. After the user returns with controller findings, research suitable exit challenges and difficulty spikes matched to the movement requirements. Resolve the concrete choices under D-03/D-17 before delivery: mechanics, technique demands, teaching, difficulty, accessible alternatives, feedback, retry, and clock behavior.

Keep shared stage-exit progression separate from the optional secret G-20 jump-pad/course room and real-app practice. No exact future challenge or advanced technique requirement is chosen by this decision.

## Why and alternatives

Shared exits make physical departure part of stage completion on either route while preserving different ways to obtain access and evidence. Increasing later movement challenges supplies the user's desired variation alongside coding/reasoning. A repeated level-one corridor would omit that accepted progression. Requiring refusal players to repair the incident or finish optional courses would violate existing route independence.

The intended benefit of varying activity remains a design hypothesis. Difficulty spikes need later research and player evidence rather than assumed cognitive effects or invented course mechanics.

## Consequences

Update the living requirements, specification, and phase plan only. This decision changes no geometry, controller, route gate, or stage-completion state and starts no research. Current physical exit arrival still does not complete a shift or campaign.

After comparison findings, review each later exit as a bounded slice using the existing architecture. Preserve nightly release and post-stage quit/continue choices separately from resignation and campaign endings. No new dependency, movement framework, mandatory advanced technique, or timed Pomodoro system is authorized.

## Verification

No new challenge research, implementation, or playtest has occurred at recording. Future accepted checks must prove access to the shared stage exit through repair and independently through refusal with the incident unresolved. For each later exit, verify its selected movement demand and reviewed difficulty, teaching, alternatives, feedback, recovery, and clock contract.

Evaluate the activity variation and any claimed cognitive/learning benefit through appropriate evidence separately from mechanical solvability. Existing controller checks do not establish those benefits or settle future challenges.

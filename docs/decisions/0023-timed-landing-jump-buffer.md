# ADR 0023: Timed landing jump buffer

- Date: 2026-10-04
- Status at recording: User-approved timing change; implementation and verification pending
- Source: The user reported reaching the 8 m/s cap but finding rhythmic jump taps too difficult, then explicitly approved a 120 ms prelanding buffer to improve responsive feel while maintaining challenge. These effects remain hypotheses for playtesting.
- Supersedes: Only the next-physics-tick Space press latch used to implement [ADR 0022](0022-approved-strafe-jump-controller-contract.md). All other controller choices in ADR 0022 remain effective.

## Context

The slice 0.5 controller retains a brief Space press until the next physics step. A tap shortly before landing can be discarded while the player is still airborne. Held-Space landing hops work and remain wanted; the user's playtest identifies the timing of rhythmic taps as the problem to address.

## Decision

A fresh Space press, excluding keyboard-repeat events, refreshes a 0.12-second pending jump countdown. Measure its remaining duration using physics delta at the existing 60 Hz step. Releasing Space does not cancel that request.

On the first eligible grounded physics step while the request remains live, jump before ground friction, preserve horizontal momentum, and consume the request once. Expiry clears the request. Existing `active = false` resets also clear it, preserving workstation, notice, elevator, mouse-release, and focus-loss behavior and the requirement for fresh jump input after resuming.

Keep held-Space repeated hops, the 8 m/s horizontal cap, all approved acceleration/friction and jump/gravity values, and the physics rate from ADR 0022. The buffer adds neither a jump while airborne nor grace to jump after leaving a ledge.

## Why and alternatives

A short landing request can retain an intentional near-landing tap without changing the movement model or requiring Space to remain held. The user approved 120 ms as the initial balance between responsive input and timing challenge. Neither improved feel nor retained challenge is established by approval or automated checks; evaluate both in the next manual playtest.

Keeping the next-tick latch would leave the reported tap timing unchanged. Broad timing forgiveness, airborne jumping, and late-ledge grace address different behavior and are outside this decision.

## Consequences

Change only pending jump timing in the existing controller and its focused checks. Do not add a dependency, input framework, scene, or movement abstraction. Preserve the rest of slice 0.5, existing office interactions, the intentionally broken incident, and the later decisions for dogs/snack, movement courses, and escape outcomes.

## Verification

Implementation and verification are pending at recording. Observe a focused failing test for a tap within the prelanding window that is released before landing. Verify a single momentum-preserving grounded hop before friction, expiry, refresh by a fresh press, ignored keyboard repeats, modal clearing, and unchanged held-Space behavior. Check that the buffer adds no airborne jump or late-ledge grace. Rerun the relevant controller/route and gameplay checks with isolated saves.

Manually retest rhythmic jump taps alongside held hops, steering, stopping, mouse capture, and the existing route/lesson. Record implementation and check results in the living specification and session continuity, keeping subjective responsiveness and challenge separate from automated controller evidence.

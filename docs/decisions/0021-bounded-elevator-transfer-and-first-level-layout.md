# ADR 0021: Bounded elevator transfer and first-level layout

- Date: 2026-10-04
- Status at recording: Implementation choice within authorized spatial scope; validation pending
- Source: Agent layout choice within the user's authorized building continuation, which permits practical provisional dimensions and furnishings. The exact dimensions and transfer presentation were not separately approved by the user.
- Supersedes: None; resolves the spatial implementation choices in D-15 under ADRs 0017 and 0018.

## Context

ADR 0017 bounds construction to a connected break room, elevator, and exit corridor. ADR 0018 places the refusal corridor below the office. The continuation request requires descent and return while preserving existing controls and interactions; the final elevator puzzle and departure gates remain separate work.

## Decision

Open a genuine passage through the existing office's north wall. Its staff door blocks the opening until used, then slides 1.16 m left once and remains open. Preserve its existing closed position and provide overlapping floor support across the threshold. Clear width is approximately 1.07 m.

Place a modest 6 m by 6 m break room west of a 3.7 m wide upper lobby. Connect them through an open 1.65 m doorway. Use the existing materials and asset generator, with collision handling in the existing room script.

Use two matching static elevator cab interiors separated vertically by 6 m, each with a 1.4 m entry opening. An E interaction with the back-wall control makes one downward or upward transfer. The existing 2.5 m interaction ray reaches the control from inside the cab. Fade to black for 0.3 seconds, hold black for 0.4 seconds, then fade in for 0.3 seconds. Pause walking during transfer, clear velocity, and preserve the player's view and horizontal position. These cabs establish bounded travel and return without a moving platform, simulated shaft, or additional selectable floors.

Connect the lower landing westward to a 52 m long, 3.6 m wide corridor with a clear central lane, repeated lights and exit wayfinding. Its far end remains solid and carries a recognizable exit door. Increase the walking camera's far range to 90 m for the corridor sightline.

## Why and alternatives

A bounded transfer establishes the required descent and return while following the existing local interaction pattern. A moving cab and shaft would add platform motion, door coordination, and passenger handling that the spatial task does not need. Those additional behaviors are not required to choose the later refusal puzzle.

The continuous floors and clear passages support ordinary walking now. Their dimensions remain provisional and can be adjusted after play review; they do not establish the later Quake-style movement tuning.

## Consequences

Spatial access remains available without incident repair. Arrival at the exit changes no shift, employment, or campaign outcome. Preserve the workstation, notices, window/retention nets, Panopticon reactions, and current controls.

The elevator puzzle, guard dogs, snack, and final release gates remain D-16/D-03 work. Controller tuning and the secret movement room remain D-17 work. This choice adds no general elevator framework, dependencies, or new narrative evidence.

## Verification

Validation is pending at recording. Check closed-door blocking, passage support after opening, controls reached through the existing interaction ray, downward/upward transfer, input pause, velocity clearing, and preserved view. Run both existing gameplay and surveillance integration checks with isolated saves. In the running game, walk office → break room → elevator → lower corridor → exit and back to the workstation; inspect seams, clearances, lighting, signs, prompts, and mouse capture. Record actual results in session continuity rather than treating this decision as proof of completion.

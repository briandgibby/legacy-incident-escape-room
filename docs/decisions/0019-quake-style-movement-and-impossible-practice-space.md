# ADR 0019: Quake-style movement and impossible practice space

- Date: 2026-10-04
- Status at recording: Accepted movement and surreal-space direction; courses remain later work
- Source: Explicit user direction for Quake III Arena-like strafe-jump acceleration, a later secret room with jump pads and escalating defrag-style courses, and huge interiors within a narrow building footprint.
- Supersedes: None; elaborates ADRs 0017 and 0018.

## Context

The inspected `office_player.gd` uses fixed walking speed and gravity, with no jump input. Requested movement and courses are not implemented. [id Software's movement source](https://github.com/id-Software/Quake-III-Arena/blob/master/code/game/bg_pmove.c) provides primary context for acceleration and friction, not an approved implementation for this game.

## Decision

Require Quake III Arena-like movement with speed gained through strafe jumping. Track this capability as G-19. The accepted direction does not require an exact faithful port, fixed constants, a selected tick rate, copied code, or new dependencies.

Later, provide a secret movement-practice room with jump pads and escalating defrag-style courses. Accept strangely huge interior spaces inside the building's narrow apparent footprint as part of its surreal direction. Track this later space as G-20, separately from optional app-building feasibility in ADR 0012. Do not implement the minigame in this documentation turn.

Exact movement tuning, inputs, teaching, course placement, progression, and recovery remain open under D-17.

## Why and alternatives

Movement mastery can make traversal and escape rewarding; the later courses provide room to develop that skill. Impossible interiors reinforce the game's dystopian absurdism. Ordinary fixed-speed walking would omit the requested technique, while assuming original engine constants would decide implementation prematurely.

## Consequences

Extend the existing player controller proportionally when implementation is authorized. Preserve office interactions and independently viable routes, including the snack alternative when movement is insufficient. Keep later courses outside the immediate spatial slice; no engine replacement or imported movement framework is accepted.

## Verification

When implemented, observe speed gains from the selected strafe-jump technique and check existing movement, collision, camera, and workstation behavior. Evaluate teaching and later course progression through play. Do not claim exact Quake fidelity or proven learning without a defined contract and evidence.

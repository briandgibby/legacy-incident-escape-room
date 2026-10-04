# ADR 0022: Approved strafe-jump controller contract

- Date: 2026-10-04
- Status at recording: User-approved controller contract; implementation and verification pending
- Source: Explicit user approval in this session of the proposed D-17 controller contract and slice 0.5 implementation.
- Supersedes: None; resolves the controller and initial teaching choices left open by ADR 0019. Later movement courses remain open. Retains ADR 0021's bounded elevator transfer.

## Context

ADR 0019 requires Quake III Arena-like strafe-jump acceleration. The existing controller provides fixed-speed WASD movement, gravity, and mouse look without jumping. The connected office, break room, elevator, and exit corridor under ADR 0021 provide a traversal baseline. Choose a bounded movement contract before implementing slice 0.5 or tuning dog evasion.

[id Software's movement source](https://github.com/id-Software/Quake-III-Arena/blob/master/code/game/bg_pmove.c) provides primary context for ground friction, acceleration limited by velocity along the intended direction, and evaluating jumping before ground friction. The game adopts those principles with its own approved constants and input behavior.

## Decision

Keep ordinary walking at 2.8 m/s and normalize diagonal WASD input. Use ground acceleration of 28 m/s², ground friction of 8/s, and a stop-reference speed of 1 m/s. With movement and jump released on the ground, target a stop within 0.35 seconds from ordinary walking speed and within 0.5 seconds from the maximum horizontal speed.

Use air acceleration of 3 m/s² along the normalized intended movement direction. Limit that acceleration according to the current velocity projected onto the intended direction reaching 2.8 m/s, allowing coordinated strafing and mouse turns to increase total speed. Cap total horizontal speed at 8 m/s.

Space jumps upward at 4.2 m/s with gravity of 12 m/s². On flat ground these values give approximately 0.74 m height and 0.70 seconds in the air. Holding Space repeats a hop on landing before ground friction, preserving horizontal momentum. Releasing Space permits ground friction on landing.

Retain Godot's existing 60 Hz physics update and handle jump input there. Keep the existing controller, capsule, collision handling, and mouse-look pattern. Workstation, notice, elevator-transfer, and mouse-release transitions clear momentum and pending jump input. Require a fresh Space press after walking resumes so a held modal input cannot launch a jump.

Teach the controls through a safe, short lesson in the existing break room, with horizontal speed shown in the walking HUD. Explain walking, holding Space to repeat hops, gaining speed through strafing and mouse turns, and releasing Space and movement to stop. No new room or later movement course belongs to this slice.

## Why and alternatives

Ordinary walking remains usable at interactables while the separate air acceleration and landing order provide the requested means to gain and carry speed. Bounded stopping and modal input clearing preserve deliberate control around the existing workstation, notices, and elevator. A short lesson and speed feedback make the accepted technique observable; whether players learn it effectively still needs play review.

A jump added to the fixed-speed controller would omit the requested acceleration. A faithful Quake port, copied source, imported controller framework, or changed tick rate would add scope beyond the approved contract. Held-Space repetition is an accepted input choice for this game rather than a claim of original-game fidelity.

## Consequences

Extend the current affected scripts and relevant checks proportionally. This decision authorizes no new dependency or movement framework. Preserve existing office interactions, the intentionally broken incident, independent repair/refusal routes, and the snack alternative to skilled dog evasion. Dogs, snack use, the elevator puzzle, nightly release, and campaign outcomes remain separate work.

The later secret room, jump-pad impulses, course access/progression, resets, rewards, and clock policy remain D-17 choices under ADR 0019. The short break-room lesson is not an escape prerequisite and does not implement the later optional minigame or real-app practice.

## Verification

Implementation and verification are pending at recording. Use focused tests for ordinary straight/diagonal walking, strafe-jump speed gain, the horizontal cap, jump height/time, held/released landing behavior, stopping bounds, and fresh jump input after modal transitions. Recheck the complete building round trip, existing gameplay and surveillance checks, and collision clearance/stopping at interactables with isolated saves. Review the lesson and walking speed feedback in the running game. Record observed results in the living specification and session continuity; approval alone establishes neither implementation nor teaching effectiveness.

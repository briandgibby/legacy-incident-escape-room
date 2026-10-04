# ADR 0017: First-level operative building expansion

- Date: 2026-10-04
- Status at recording: Accepted next-session implementation scope
- Source: Explicit user request for continuation instructions to build the first level with a break room, elevator, and long corridor leading to the exit.
- Supersedes: None; elaborates ADRs 0003, 0013, and 0016.

## Context

The current first-person office supports the workstation incident but lacks the requested complete first-level layout. The user wants the next session to begin building that space, after preserving the current planning work.

## Decision

Bound the next session's implementation to connected, traversable first-level spaces: a break room, an elevator area, and a long corridor leading to the exit. Extend the current Godot office implementation and preserve its existing movement, collision, workstation, and surveillance behavior. Track this scope as G-18.

This authorizes the requested physical expansion, not a new engine, generalized level framework, full campaign, complete puzzles, finale, or deferred scoring system. Elevator mechanics remain undecided; its presence does not require a full multi-floor simulation or approve activation, travel, or access gates. Layout/elevator-function choices remain D-15.

Exact spatial layout, interactions, and exit conditions need clarification when they materially affect behavior. Do not silently make code repair a prerequisite for refusal-route departure.

## Why and alternatives

A bounded first-level expansion gives the accepted shift-based escape a concrete setting while keeping development focused. Building all future spaces or campaign systems first would exceed the requested continuation scope.

## Consequences

Carry these boundaries into the next-session prompt and affected plan slices. Preserve independently viable repair/refusal routes and keep going home, resignation, and continuation distinct. This documentation turn performs no gameplay implementation; optional practice and future puzzle packs remain outside the authorized expansion.

## Verification

When built, inspect the connected spaces through play and check movement, collision, workstation access, and surveillance regressions with relevant existing checks. Confirm the requested rooms/path exist and that unresolved elevator or ending mechanics were not invented as part of the layout change.

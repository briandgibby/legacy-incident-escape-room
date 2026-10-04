# ADR 0020: Local guard-dog retry and snack restoration

- Date: 2026-10-04
- Status at recording: Accepted
- Source: Explicit user choice: return to the corridor entrance, restoring the snack if used.
- Supersedes: None; clarifies the caught/snack recovery aspect of ADR 0018 under D-16.

## Context

ADR 0018 accepts guard dogs and a break-room snack alternative, with recovery rules unresolved. The user has chosen the outcome when the dogs catch the player.

## Decision

Return the caught player to the corridor entrance for a local retry. Restore the snack if it was used. This local recovery does not require replaying the incident before attempting the corridor again.

Timer behavior, the exact snapshot/reset boundary, snack restoration details, dog state, and penalties beyond this chosen outcome remain undecided. The choice does not authorize extra punishment or loss of notes.

## Why and alternatives

A local retry keeps the failed attempt within the corridor challenge. Restoring a used snack preserves the accepted alternative to movement mastery. Replaying the incident or silently exhausting that alternative would add consequences beyond the selected recovery.

## Consequences

Refine the corridor slice and specification without rewriting ADR 0018. Preserve independently viable repair/refusal routes and the snack alternative. Separate the accepted retry destination and snack restoration from remaining reset rules; do not infer a timer reset, dog respawn pattern, or additional penalty.

## Verification

When implemented, verify a caught attempt returns the player to the corridor entrance, restores a used snack, and permits another attempt without incident replay. Check other state and timer behavior only against their subsequently chosen contracts, rather than assuming this decision defines them.

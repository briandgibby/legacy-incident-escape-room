# ADR 0004: Repair and refusal routes reveal distinct evidence

- Date: 2026-10-03
- Status at recording: Accepted
- Source: Explicit user decision: allow repair and refusal routes, with both avenues giving different notable clues to puzzles and evidence of company crimes.
- Supersedes: None; elaborates the player-agency purpose in ADR 0001.

## Context

The current incident loop centers on diagnosing and repairing code. The intended game also asks players to consider the company controlling their work. A refusal option that still requires the repair would not provide the accepted choice. Route differences need to affect investigation and story, rather than merely changing decorative dialogue.

## Decision

Provide viable repair and refusal routes to escape the first post-tutorial scenario. Refusal must be completable without repairing the code. Each route reveals distinct notable puzzle clues and evidence of crimes committed by the company, with gameplay and narrative implications.

Make the clues necessary to complete a chosen route accessible without taking the opposite route. The complete picture of the company's crimes may invite replay, but an all-evidence completion requirement has not been decided. Exact escape mechanisms, evidence objects, refusal difficulty, and timing remain proposals until separately resolved.

## Why and alternatives

A mandatory repair would contradict the accepted refusal choice. Identical evidence on both routes would weaken the requested distinction. Requiring opposite-route clues would silently make either choice incomplete. Separate consequential evidence supports both agency and further investigation without deciding specific crimes or mechanics in this record.

## Consequences

The specification and phased plan must treat both routes as complete behaviors and trace their distinct clues and crime evidence. Future work must not remove refusal viability as a convenience fix. Route-specific evidence must have a defined use or narrative consequence, not only alternate wording.

## Verification

Prove each route independently from a fresh scenario state. Check that refusal succeeds with the incident unrepaired, required clues do not depend on the opposite route, and each route exposes its distinct puzzle and crime evidence with the specified consequences.

# ADR 0002: Documentation and test-driven delivery

- Date: 2026-10-03
- Status at recording: Accepted
- Source: Explicit user instruction for distinct PRD/spec responsibilities, immutable HOW/WHY decisions, session continuity, phased implementation, TDD, and iterative process improvement.
- Supersedes: None.

## Context

The project has a playable scaffold and historical handoff notes. Further development needs a small, reliable record of intent, technical behavior, decisions, and the next step. Documentation and process must respect the user's minimal-change policy rather than becoming additional infrastructure.

## Decision

Maintain a plain-language PRD for WHY and intended outcomes, a technical product specification for HOW, immutable numbered ADRs for consequential decisions, a phased plan of playable vertical slices, and concise session continuity.

Use TDD for new behavior and fixes: write and run the relevant failing test, observe the intended failure, implement the smallest passing change, and safely refactor when needed. Use suitable document or visual review for non-code work. Protect existing user changes and the intentionally broken puzzle repository.

After each slice, try one process improvement supported by observed friction or results. Adopt or revise it based on the next slice's evidence. Update documents only when their responsibilities are affected.

## Why and alternatives

A single growing handoff mixes intent, implementation, and history. A comprehensive bureaucracy adds maintenance without proving player value. Separate concise records and playable slices allow review and learning while keeping the scope small. [Fowler's explanation of Beck's TDD](https://martinfowler.com/bliki/TestDrivenDevelopment.html) supports the test-first delivery cycle.

## Consequences

Recorded ADRs cannot be edited, renumbered, or deleted. Corrections, reversals, and status changes require a new numbered record referencing the predecessor; the index and living spec show the effective successor. Acceptance must cite authorization. Process documents must not imply gameplay approval or require unrelated deliverables.

## Verification

For each completed slice, check requirement traceability, relevant test evidence, documented behavior, and a concrete next action. Record the process experiment and its observed result concisely, without boilerplate.

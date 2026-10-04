# ADR 0018: Refusal descent and guard-dog alternatives

- Date: 2026-10-04
- Status at recording: Accepted direction; elevator puzzle mechanism remains proposed
- Source: Explicit user direction for an elevator puzzle enabling refusal-path descent, an exit corridor guarded by dogs, and a reserved break-room snack alternative when movement is insufficient.
- Supersedes: None; clarifies ADR 0017 and elaborates ADR 0004.

## Context

ADR 0017 accepts connected first-level spaces but leaves elevator function unresolved. The user now places the refusal escape corridor below the office and selects obstacles and an alternative to movement mastery.

## Decision

Provide an elevator puzzle that enables descent to the long exit corridor as the refusal path. Guard dogs discourage escape there. Preserve an alternative using a snack reserved in the break room if the player's movement is insufficient to escape the dogs.

Refusal requires no incident repair. This descent clarifies D-15's circulation direction without requiring simulation of the entire building or every floor. Retain independently viable repair/refusal routes and their distinct consequential evidence.

A button-order code is a promising proposal, not a selected mechanism or accepted sequence. Puzzle clues, wrong-input behavior, reset rules, dog interactions, snack handling, and recovery policies remain open under D-16. The snack alternative is accepted; its precise fairness and recovery contract is not yet chosen.

## Why and alternatives

Descent gives the corridor a coherent place in the physical refusal route. Dogs turn the escape into pressure beyond solving the incident. The snack provides another approach when movement skill alone is insufficient. Making code repair the elevator prerequisite would contradict refusal viability.

## Consequences

Refine the spatial and route slices without treating proposed buttons or recovery rules as approved implementation. Connect the break room to the escape alternatives. Do not silently replace the snack option with compulsory advanced movement or broaden the task into a whole-building simulator.

## Verification

When implemented, verify refusal can reach the corridor without code repair and complete departure through the selected movement and snack procedures. Review clue discoverability and the chosen wrong-input, reset, and dog-recovery policies explicitly; the proposal alone proves no fairness outcome.

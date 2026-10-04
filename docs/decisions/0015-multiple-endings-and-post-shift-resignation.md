# ADR 0015: Multiple endings and post-shift resignation

- Date: 2026-10-04
- Status at recording: Accepted
- Source: Explicit user acceptance of several endings and a player option to quit after each stage.
- Supersedes: None; refines resignation eligibility and ending scope in ADRs 0013 and 0014.

## Context

ADR 0013 distinguishes completing a shift from permanently leaving the campaign. ADR 0014 establishes career pressure and preserves an exposure ending as a candidate, while leaving quitting options open. The user has now selected resignation eligibility and multiple endings.

## Decision

Require several endings. Offer the player the option to resign after every completed shift/stage, whether completed through repair or refusal.

Keep going home, resigning, and continuing distinct. A shift escape earns going home for the night; it does not automatically resign the character. Choosing to continue leads to the next workday's shift. Refusal still ends the assignment without requiring code repair and does not itself mean quitting employment.

Exact quitting controls, resignation outcomes, evidence effects, reporting after quitting, ending count/names, and presentation remain unchosen. The envisioned exposure ending remains a candidate rather than the sole or finalized outcome.

## Why and alternatives

Post-shift resignation makes staying an explicit player choice while preserving the accepted shift progression. Several endings let the game explore different responses to its pressures. Making refusal automatically resign, or withholding resignation from that route, would collapse these distinct choices.

## Consequences

Refine the living specification and affected slices without rewriting earlier ADRs. Preserve independent repair/refusal viability and their consequential evidence. Career pressure can inform the choice but does not remove the accepted resignation option or establish automatic black-mark mechanics.

## Verification

When implemented, check resignation eligibility after each completed stage on both routes. Confirm going home alone does not resign, continuation reaches the next shift, and several distinct endings exist. Verify unchosen reporting and evidence rules remain explicit design questions.

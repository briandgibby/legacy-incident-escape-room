# ADR 0007: Difficulty-specific Joel personas

- Date: 2026-10-03
- Status at recording: Accepted
- Source: Explicit user direction for a shared base story, different Joel personas by difficulty, and additional replay motivation.
- Supersedes: None; elaborates ADRs 0001 and 0004.

## Context

The user selected easiest/hardest personas for the same base story. Medium characterization and exact difficulty rules remain undecided.

## Decision

Keep the base story across difficulties; change Joel's persona and delivery. On the easiest difficulty, Joel is a talented, overbearing senior engineer who openly disdains AI. Panopticon catching the player using the helper makes the player's life harder; the specific consequences have not been selected.

On the hardest difficulty, Joel is an incompetent nepotism hire, unable to center a div even with AI assistance, who pulls the ladder up behind him. In-world rumors describe unwanted advances toward women alongside elevated female staff turnover. Preserve these as allegations and suspicious correlation, not established causation, proof of murder, or an identification of a perpetrator.

Medium persona, exact detection penalties, multipliers, and implementation remain undecided. Track G-12.

## Why and alternatives

Different personas make replay reveal another workplace dynamic without replacing the shared story. Merely changing numerical difficulty would miss the requested characterization. Treating rumors as confirmed facts would collapse investigation and invent conclusions the user did not choose.

## Consequences

Keep the helper optional and useful, with discoverable consequential rules. Preserve the accepted detection consequence as a requirement pending its exact design; do not silently remove it. Repair and refusal must remain independently viable. Technical implementation and the medium persona remain proposals.

## Verification

When implemented, compare easiest/hardest playthroughs for consistent story facts, distinct Joel behavior, and clearly framed rumors. Check discoverable helper rules/consequences and independently viable routes at each supported difficulty.

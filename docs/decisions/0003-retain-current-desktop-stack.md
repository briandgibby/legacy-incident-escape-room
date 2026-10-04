# ADR 0003: Retain the current desktop stack

- Date: 2026-10-03
- Status at recording: Accepted
- Source: Explicit user minimal-change policy, applied to the existing repository architecture and documented development baseline.
- Supersedes: None.

## Context

The current Windows desktop scaffold uses Godot 4.7 standard with GDScript for the game and JavaScript ES modules with Node's built-in `node:test` for the incident sandbox. SQL files provide simulated diagnostic evidence without a production database. Blender/Python tools support assets. Existing gameplay and surveillance integration checks already exercise this arrangement.

## Decision

Continue development within these existing tools, naming, interfaces, and control flow. Extend the closest implementation for each authorized slice. Add no framework, runtime, production database, or generalized layer merely because a later scenario might benefit from it.

Treat Godot 4.7 as the observed documented baseline, not a new upgrade policy. The Node runtime currently comes from PATH; this record does not establish an exact supported Node version. Establish and test the release's supported runtime before distributing a scenario that relies on it.

## Why and alternatives

Changing engines, adopting a broader application framework, or provisioning a database would expand the request and delay validation of the game. The current stack supports a playable debugging loop and its existing checks. Retention follows the user's instruction to preserve architecture unless the requested behavior makes that impossible.

## Consequences

New work should stay local to the affected modules. If a requested behavior truly needs a dependency or architectural expansion, explain why the smaller approach fails and obtain approval before proceeding. No additional platform support, version pinning, or export tooling is accepted by this record.

## Verification

Run the relevant existing Godot integration checks for behavior changes. Keep their user data isolated and solver proof disposable. Preserve expected starting puzzle failures; validate runtime compatibility and export behavior when release work requires them.

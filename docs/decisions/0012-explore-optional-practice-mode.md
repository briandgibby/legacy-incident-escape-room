# ADR 0012: Explore optional practice-mode feasibility

- Date: 2026-10-03
- Status at recording: Accepted for feasibility exploration only
- Source: Explicit user request to explore an optional mode outside the story for genuine app construction and execution using game documentation, guidance, and player-created environments.
- Supersedes: None; elaborates ADR 0010's construction-learning goal.

## Context

The existing workstation edits supplied incident code. It does not provide a general app-building practice mode. The user wants to investigate extending learning beyond the story's constrained incidents.

## Decision

Investigate the feasibility of an optional practice mode outside the story where players genuinely build and run applications using the game's documentation and guidance within player-created environments.

The accepted action is investigation, not implementation or approval of an architecture, runtime, backend, dependency, or service. Container, WebAssembly, and native-runtime approaches remain candidates. The meaning and scope of an environment, including whether full virtual machines are needed, remain unresolved.

## Why and alternatives

Open practice may let players apply construction lessons to their own work. A preset puzzle alone may not provide that freedom. Selecting a runtime before clarifying environment needs could impose unnecessary infrastructure and scope.

## Consequences

Keep this direction optional and separate from story completion and viable repair/refusal routes. Compare approaches against the current desktop stack and minimal-change policy. Do not add code, dependencies, or execution infrastructure as part of recording this decision. Further delivery requires a concrete scoped proposal and authorization.

## Verification

Produce a proportionate feasibility comparison identifying what can genuinely run, environment boundaries, limitations, and unresolved choices. Distinguish researched capabilities from locally demonstrated behavior; make no implementation or learning-effectiveness claim from documentation alone.

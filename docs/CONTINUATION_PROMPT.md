# Controller slice continuation prompt

Paste the following into a new session working in `C:\Users\Jack Thompson\git-projects\legacy-incident-escape-room`.

---

Continue Legacy Incident Escape Room with implementation-plan slice 0.5: Quake 3 Arena-like movement and strafe-jump acceleration (G-19).

Repository: https://github.com/briandgibby/legacy-incident-escape-room
Local workspace: `C:\Users\Jack Thompson\git-projects\legacy-incident-escape-room`

The spatial implementation and related design progress were committed and pushed to `origin/main` as `53279f4`; a subsequent documentation commit prepares this handoff. Inspect current Git status and history first and preserve all uncommitted work. Read `AGENTS.md`, `SESSION_CONTINUITY.md`, PRD G-19/G-20, the PRS movement section and D-17, ADRs 0019/0021, and implementation-plan slice 0.5. Investigate only the affected controller, room transitions, scene/input settings, and relevant tests.

Slices 0.2–0.4 already work: the office's staff door opens into the break room/lobby, paired elevator cabs provide one 6 m descent/return, and a 52 m corridor reaches a recognizable solid exit. The user completed the mouse/keyboard round trip and confirmed functionality. Reported elevator texture fighting was corrected by removing overlapping floor and sidewall surfaces; the rebuilt asset passed measured overlap checks, targeted rendered review, and all three integration checks. The user has not yet retested that visual correction. Preserve these spaces and joins. Physical exit arrival does not implement nightly release, resignation, or campaign completion.

Begin by reviewing a compact D-17 controller contract. Quake-style strafe-jump acceleration is already wanted; do not re-ask that direction. Recommend a practical starting contract covering:

- Ordinary ground speed, acceleration, friction, and stopping at interactables.
- Directional air acceleration and speed gained/carried through coordinated strafing and mouse direction.
- Jump key, press versus hold/repeat behavior, gravity/jump height, and momentum on landing.
- Practical speed bounds, physics-step/input handling, and a safe short controls lesson.

Explain the consequential choices and ask one focused review question before implementing the unsettled contract. Routine implementation choices can use the simplest existing-pattern approach. Exact Quake constants, a faithful port, a new tick rate, copied source, and new dependencies are not approved. Use primary movement documentation/source if needed to substantiate the proposed physics. Settle only the controller portion of D-17 now; later course rules stay open.

Once the controller contract is reviewed, implement slice 0.5 in small red/green steps. Extend `godot/scripts/office_player.gd` and only necessary scene/input settings. Keep the existing `CharacterBody3D`, mouse look/capture, named-mesh collision convention, and local interactions; add no controller framework or unrelated refactor. Preserve workstation/notice transitions and the elevator's walking pause and velocity reset, including the new controller's momentum/jump state as required by those existing transitions.

Tests should distinguish ordinary navigation, jumping, accelerating strafe jumps, and the approved landing/stopping behavior. Observe each focused failure for the intended reason before implementation. Exercise the real controller and collisions under the accepted physics-step/input contract. The existing building test scripts its own walking velocity and disables player physics, so its route pass alone does not verify new movement. Add only the focused controller coverage needed; avoid hypothetical frame-rate matrices.

Teach the controls in a short safe existing space with the smallest useful feedback. The secret movement room is later work. Play the office → break room → elevator → corridor → exit and return at ordinary and skilled speeds, checking doorframes, ceilings, stopping near controls, mouse capture, and workstation return. Inspect visible surface joins as well as collision clearance: the manual playtest found coplanar elevator surfaces that scripted traversal missed. Report manual verification you cannot perform and arrange a user playtest when needed.

Run the relevant checks from the repository root, keeping saves isolated:

```powershell
godot --headless --path godot --script res://tests/building_integration.gd
godot --headless --path godot --script res://tests/gameplay_integration.gd
godot --headless --path godot --script res://tests/surveillance_integration.gd
```

Use `docs/GODOT_SETUP.md` and the existing launcher if the Godot alias is unavailable. Keep any playable test launch isolated from the player's ordinary incident sandbox: startup refreshes the incident copy. Leave the shipped JavaScript incident intentionally broken; its starting test/simulation failures are puzzle behavior.

Finish this controller slice before moving to Phase 1. Do not bundle the elevator puzzle, dogs/snack, nightly release, NDA opening, notebook, messenger, Dantalion credits, new evidence, campaign outcomes, or real-app practice into it. Dog evasion must be tuned only after movement is validated. For later D-16 work, preserve the accepted corridor-entrance retry and used-snack restoration without inventing clock/reset penalties. The secret room, jump pads, and defrag-style courses remain later G-20 work. Both repair and refusal must remain independently viable; advanced movement cannot become an undisclosed prerequisite.

Keep changes minimal and preserve the established dystopian story and existing stack. Update only affected as-built PRS/plan sections and concise session continuity. Record consequential HOW/WHY choices in a new numbered ADR and update the index; never edit recorded ADRs or invent approval. Report what changed, actual verification, remaining tuning/playtest limits, and one evidence-backed process improvement. Do not commit or push in the new session unless I authorize it there.

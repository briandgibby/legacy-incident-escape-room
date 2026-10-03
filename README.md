# Legacy Incident Escape Room

A playable vertical-slice scaffold for a desktop indie game about debugging a legacy production incident under escape-room pressure.

## What is implemented

- A first-person Rifkin Software office with movement, collision, and one usable computer in the player's cubicle.
- A workstation with desk clues, case file, editable source file, terminal actions, timer, scoring, and a hint-ladder helper.
- One data-driven level: `Night Shift Checkout`.
- A real runnable Node/JavaScript incident repository with tests, fixtures, SQL artifacts, logs-by-simulation, and a deploy validator.
- A helper design that gives hints and diagnostic direction without writing solution code.

## Try the incident repo now

The game project uses this repo as its sandbox. You can run it directly:

```powershell
cd "C:\Users\Jack Thompson\git-projects\legacy-incident-escape-room\godot\levels\night_shift_checkout\incident_repo"
npm test
npm run simulate
```

The first test run fails on purpose. That is the puzzle.

## Open the Godot project

Open this file in Godot 4.7:

```text
C:\Users\Jack Thompson\git-projects\legacy-incident-escape-room\godot\project.godot
```

Run the main scene. Godot will copy the incident repo into `user://night_shift_checkout`, let the player edit `src/discounts.js`, and call the local Node runtime for tests, simulation, and deploy validation.

Use WASD to move, the mouse to look, and E while facing your computer to open the workstation or facing the bulletin board to read the facilities notice. Escape or the return button leaves the workstation without losing drafts or clues. The incident clock continues in the office. In the room, Escape releases the mouse; click to resume looking around.

Using the computer brings the first-person camera close to its physical monitor, with the interface inside the glass. Panopticon reacts to editing, evidence access, hints, test and deploy results, and movement around the office. Its eye remains after notices fade, unused terminals acknowledge nearby movement, and quiet keyboard taps sometimes follow a pause in typing. Notices also appear randomly on all six terminals without interrupting input.

The east window overlooks a high-rise service court with retention nets below the office. The nearby bulletin board pairs a compulsory extended-shift policy with Joel's notice about three software engineers' recent "accidents" and the new net installation.

Run the gameplay integration checks from the repository root:

```powershell
godot --headless --path godot --script res://tests/gameplay_integration.gd
godot --headless --path godot --script res://tests/surveillance_integration.gd
```

These checks use a separate user-data directory and leave the player's sandbox untouched.

Godot 4.7 is installed through WinGet for this buildout. If a terminal opened before installation does not see `godot`, restart the terminal or run the executable from the WinGet package directory.

See `docs/GODOT_SETUP.md` for installation and verification notes.

## Design notes

- The first slice focuses on a TypeScript/JavaScript web incident stack.
- The language is real JavaScript with `node:test`; SQL files use normal Postgres-style DDL and read-only diagnostic queries.
- Production systems are simulated, but outputs derive from the same source code and fixtures the player edits.
- The level content is data-driven in `godot/levels/night_shift_checkout/level.json`.
- Future incident packs can add Python, Docker, CI, security incidents, and data pipelines without replacing the core loop.

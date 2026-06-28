# Legacy Incident Escape Room

A playable vertical-slice scaffold for a desktop indie game about debugging a legacy production incident under escape-room pressure.

## What is implemented

- Godot 4 project shell with an in-game office/clue panel, case file, editable source file, terminal actions, timer, scoring, and a hint-ladder helper.
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

Godot 4.7 is installed through WinGet for this buildout. If a terminal opened before installation does not see `godot`, restart the terminal or run the executable from the WinGet package directory.

See `docs/GODOT_SETUP.md` for installation and verification notes.

## Design notes

- The first slice focuses on a TypeScript/JavaScript web incident stack.
- The language is real JavaScript with `node:test`; SQL files use normal Postgres-style DDL and read-only diagnostic queries.
- Production systems are simulated, but outputs derive from the same source code and fixtures the player edits.
- The level content is data-driven in `godot/levels/night_shift_checkout/level.json`.
- Future incident packs can add Python, Docker, CI, security incidents, and data pipelines without replacing the core loop.

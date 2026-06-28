# Legacy Incident Escape Room Handoff

## Current state

Repository:

```text
C:\Users\Jack Thompson\git-projects\legacy-incident-escape-room
```

This repo contains a first playable vertical-slice scaffold for a desktop Godot indie game about debugging a realistic legacy production incident. The current level is `Night Shift Checkout`, a TypeScript/JavaScript-style checkout incident where a migration changed coupon discounts from percent values to basis points.

The implementation has two halves:

- `godot/`: Godot 4.7 project with the office/clue UI, case file, editable source file, terminal actions, timer, score, helper hints, and level runner integration.
- `godot/levels/night_shift_checkout/incident_repo/`: Real Node/JavaScript incident repo used as the player sandbox.

The incident repo is intentionally broken in its starting state. `npm test` and `npm run simulate` should fail until the player diagnoses and fixes `src/discounts.js`.

## Setup and verification

Godot Engine 4.7 standard edition is installed through WinGet:

```powershell
winget install --id GodotEngine.GodotEngine --exact --source winget --accept-package-agreements --accept-source-agreements
```

Open the project:

```powershell
cd "C:\Users\Jack Thompson\git-projects\legacy-incident-escape-room"
.\scripts\open-godot.ps1
```

The launcher uses the `godot` alias when available and falls back to the WinGet install path.

Verify Godot can load the project:

```powershell
& "$env:LOCALAPPDATA\Microsoft\WinGet\Packages\GodotEngine.GodotEngine_Microsoft.Winget.Source_8wekyb3d8bbwe\Godot_v4.7-stable_win64_console.exe" --headless --path "C:\Users\Jack Thompson\git-projects\legacy-incident-escape-room\godot" --quit
```

Verify the intentional puzzle failure:

```powershell
cd "C:\Users\Jack Thompson\git-projects\legacy-incident-escape-room\godot\levels\night_shift_checkout\incident_repo"
npm test
npm run simulate
```

Expected starting-state behavior:

- `LATE-NIGHT-15 applies the migrated basis-points discount` fails.
- Actual discount is `0`; expected discount is `1500`.
- The simulation reports `coupon selected but discount amount does not match marketing.coupon_rules`.

## Puzzle contract

Do not patch the incident repo into a passing state as a normal code fix. The broken source is the level.

The intended player diagnosis:

- The coupon is active and selected.
- The schema migration introduced `discount_basis_points`.
- `src/discounts.js` still reads only `discount_percent`.
- A correct fix supports `discount_basis_points` while preserving legacy `discount_percent` rows.

The helper may point players toward evidence, concepts, and tests, but must not output the exact fix or write code for them.

## Important files

- `README.md`: repo overview and quick start.
- `docs/GODOT_SETUP.md`: Godot installation and verification notes.
- `scripts/open-godot.ps1`: project opener with WinGet fallback.
- `godot/scripts/main.gd`: main game UI and runtime loop.
- `godot/scripts/office_view.gd`: lightweight drawn office scene.
- `godot/tools/level_runner.mjs`: bridge used by Godot to run status, simulate, test, and deploy actions.
- `godot/levels/night_shift_checkout/level.json`: level clues, objectives, hints, and sandbox file list.
- `godot/levels/night_shift_checkout/incident_repo/src/discounts.js`: intentionally flawed player-editable file.

## Completed work

- Established the project in `C:\Users\Jack Thompson\git-projects`.
- Initialized Git and committed the baseline prototype.
- Installed Godot Engine 4.7 with WinGet.
- Confirmed Godot headless project load succeeds.
- Confirmed the scene can boot briefly in headless mode.
- Confirmed the incident repo fails in the intended starting state.
- Added setup documentation and a launcher script.

Recent commits:

```text
325d9ba Document Godot setup and launcher
0beca89 Initial legacy incident escape room prototype
```

## Next buildout recommendations

1. Replace the generated UI-only scene with a true first-person office scene while keeping the current workstation/clue loop intact.
2. Add a solved-state validation fixture or automated meta-test that proves the level is solvable without committing the solved code.
3. Add an in-game SQL/docs viewer so `sql/schema.sql`, `sql/diagnostics.sql`, and query output become first-class evidence.
4. Improve the helper into a state-aware hint ladder that unlocks hints based on discovered clues, test output, and elapsed time.
5. Add ending states for clean deploy, late deploy, wrong deploy, and diagnosis-without-fix.
6. Install Godot export templates only when ready to produce a distributable Windows build.

## Guardrails

- Keep player-facing code real JavaScript/SQL/tooling, not invented syntax.
- Keep the helper puzzle-preserving: hints, questions, and explanations only.
- Keep the incident sandbox deterministic.
- Avoid adding broad infrastructure before one polished vertical slice feels good.
- Treat failing tests in `incident_repo` as expected unless explicitly testing the solved state in a temporary copy.

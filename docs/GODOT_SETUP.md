# Godot Setup

This project targets the standard Godot 4.7 build, not the Mono/.NET build.

## Installed package

Installed with:

```powershell
winget install --id GodotEngine.GodotEngine --exact --source winget --accept-package-agreements --accept-source-agreements
```

WinGet installed Godot Engine 4.7 and added `godot` / `godot_console` aliases. Terminals opened before the install may need to be restarted before those aliases resolve.

Known executable paths after this install:

```text
C:\Users\Jack Thompson\AppData\Local\Microsoft\WinGet\Packages\GodotEngine.GodotEngine_Microsoft.Winget.Source_8wekyb3d8bbwe\Godot_v4.7-stable_win64.exe
C:\Users\Jack Thompson\AppData\Local\Microsoft\WinGet\Packages\GodotEngine.GodotEngine_Microsoft.Winget.Source_8wekyb3d8bbwe\Godot_v4.7-stable_win64_console.exe
```

## Open the project

```powershell
godot --path "C:\Users\Jack Thompson\git-projects\legacy-incident-escape-room\godot"
```

If `godot` is not available in the current terminal yet, use the direct executable path above.

## Verify the project

```powershell
cd "C:\Users\Jack Thompson\git-projects\legacy-incident-escape-room\godot\levels\night_shift_checkout\incident_repo"
npm test
npm run simulate
```

Those commands fail in the starting state by design. A correct player fix should make both pass, and the in-game deploy action runs the same checks through `godot/tools/level_runner.mjs`.

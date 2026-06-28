$ErrorActionPreference = "Stop"

$projectRoot = Split-Path -Parent $PSScriptRoot
$godotProject = Join-Path $projectRoot "godot"

$godot = Get-Command godot -ErrorAction SilentlyContinue
if ($godot) {
    & $godot.Source --path $godotProject
    exit $LASTEXITCODE
}

$wingetRoot = Join-Path $env:LOCALAPPDATA "Microsoft\WinGet\Packages"
$godotExe = Get-ChildItem -Path $wingetRoot -Recurse -Filter "Godot_v*-stable_win64.exe" -ErrorAction SilentlyContinue |
    Where-Object { $_.FullName -notlike "*_console.exe" } |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 1

if (-not $godotExe) {
    throw "Godot executable not found. Install it with: winget install --id GodotEngine.GodotEngine --exact --source winget"
}

& $godotExe.FullName --path $godotProject

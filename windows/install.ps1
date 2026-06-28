$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent $scriptDir
$installDir = Join-Path $env:USERPROFILE "bin"

New-Item -ItemType Directory -Force -Path $installDir | Out-Null

$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
$pathParts = @()
if (-not [string]::IsNullOrWhiteSpace($currentPath)) {
    $pathParts = $currentPath -split ";" | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
}

if ($pathParts -notcontains $installDir) {
    $pathParts += $installDir
    [Environment]::SetEnvironmentVariable("Path", ($pathParts -join ";"), "User")
}

$commands = @("ytcut", "ytaudio", "ytsub", "ytdl")

foreach ($command in $commands) {
    $scriptPath = Join-Path $repoRoot "windows\$($command).ps1"
    $wrapperPath = Join-Path $installDir "$command.cmd"

    $wrapper = @"
@echo off
powershell -NoProfile -ExecutionPolicy Bypass -File "$scriptPath" %*
"@

    Set-Content -Path $wrapperPath -Value $wrapper -Encoding ASCII
}

Write-Host ""
Write-Host "Installed launchers to: $installDir"
Write-Host "Close and reopen PowerShell so PATH picks up the new bin directory."
Write-Host "Then you can run: ytdl, ytaudio, ytsub, ytcut"

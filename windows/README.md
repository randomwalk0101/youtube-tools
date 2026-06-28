# Windows Scripts

PowerShell scripts for YouTube Tools, plus an installer that adds global launchers to your PATH.

## Requirements

- Windows 10 or Windows 11
- PowerShell
- yt-dlp.exe
- ffmpeg.exe

Download links:

- yt-dlp.exe: https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe
- ffmpeg: https://www.gyan.dev/ffmpeg/builds/

Copy-paste install script for Windows PowerShell:

```powershell
$bin = "$env:USERPROFILE\bin"
New-Item -ItemType Directory -Force -Path $bin | Out-Null

Invoke-WebRequest -Uri "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe" -OutFile "$bin\yt-dlp.exe"

$ffmpegZip = Join-Path $env:TEMP "ffmpeg-release-essentials.zip"
$ffmpegExtract = Join-Path $env:TEMP "ffmpeg-release-essentials"
Invoke-WebRequest -Uri "https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip" -OutFile $ffmpegZip
Expand-Archive -Path $ffmpegZip -DestinationPath $ffmpegExtract -Force

$ffmpegFolder = Get-ChildItem $ffmpegExtract -Directory | Where-Object { $_.Name -like "ffmpeg-*-essentials_build" } | Select-Object -First 1
Copy-Item (Join-Path $ffmpegFolder.FullName "bin\ffmpeg.exe") "$bin\ffmpeg.exe" -Force
Copy-Item (Join-Path $ffmpegFolder.FullName "bin\ffprobe.exe") "$bin\ffprobe.exe" -Force

$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
$pathParts = @()
if (-not [string]::IsNullOrWhiteSpace($currentPath)) {
    $pathParts = $currentPath -split ";" | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
}
if ($pathParts -notcontains $bin) {
    $pathParts += $bin
    [Environment]::SetEnvironmentVariable("Path", ($pathParts -join ";"), "User")
}
```

If you prefer manual download, put `yt-dlp.exe` and `ffmpeg.exe` into a folder that is already in PATH, or add the folder to PATH yourself and reopen PowerShell.

## Usage

From the project folder, run:

```powershell
powershell -ExecutionPolicy Bypass -File .\windows\install.ps1
```

Then open a new PowerShell window and use the tools directly:

```powershell
ytdl
ytaudio
ytsub
ytcut
```

If you do not want to install the launchers, you can still run the scripts directly from the project folder:

```powershell
powershell -ExecutionPolicy Bypass -File .\windows\ytcut.ps1
powershell -ExecutionPolicy Bypass -File .\windows\ytaudio.ps1
powershell -ExecutionPolicy Bypass -File .\windows\ytsub.ps1
powershell -ExecutionPolicy Bypass -File .\windows\ytdl.ps1
```

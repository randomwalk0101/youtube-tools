# Windows Scripts

PowerShell scripts for YouTube Tools, plus an installer that adds global launchers to your PATH.

## Requirements

- Windows 10 or Windows 11
- PowerShell
- yt-dlp.exe
- ffmpeg.exe

Make sure `yt-dlp.exe` and `ffmpeg.exe` are available in PATH.

## Usage

From the project folder, run:

```powershell
.\windows\install.ps1
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
.\windows\ytcut.ps1
.\windows\ytaudio.ps1
.\windows\ytsub.ps1
.\windows\ytdl.ps1
```

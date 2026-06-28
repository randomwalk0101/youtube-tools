
Simple command-line tools for downloading and analyzing YouTube content.

## Tools

- `ytcut` - Download the first N seconds of a YouTube video as MP4
- `ytaudio` - Download the first N seconds of YouTube audio as MP3
- `ytsub` - Download subtitles and export VTT / SRT / TXT
- `ytdl` - Download full YouTube videos with selectable quality

---

## macOS One-Command Setup

Copy and run this in Terminal:

```bash
mkdir -p ~/bin && \
curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp_macos -o ~/bin/yt-dlp && \
chmod +x ~/bin/yt-dlp && \
git clone https://github.com/randomwalk0101/youtube-tools.git ~/youtube-tools && \
cd ~/youtube-tools && \
cp mac/ytcut ~/bin/ytcut && \
cp mac/ytaudio ~/bin/ytaudio && \
cp mac/ytsub ~/bin/ytsub && \
cp mac/ytdl ~/bin/ytdl && \
chmod +x ~/bin/ytcut ~/bin/ytaudio ~/bin/ytsub ~/bin/ytdl && \
grep -qxF 'export PATH="$HOME/bin:$PATH"' ~/.zshrc || echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc && \
source ~/.zshrc
```

Then check:

```bash
yt-dlp --version
ffmpeg -version
```

If `ffmpeg` is not installed, install FFmpeg first.

---

## macOS Usage

```bash
ytcut
```

```bash
ytaudio
```

```bash
ytsub
```

```bash
ytdl
```

Output folders:

```text
~/Downloads/ytcut
~/Downloads/ytaudio
~/Downloads/ytsub
~/Downloads/ytdl
```

## Cookies

macOS scripts now use Safari cookies by default through `yt-dlp --cookies-from-browser safari`.

Windows scripts now use Chrome cookies by default through `yt-dlp --cookies-from-browser chrome`.

If macOS shows `Operation not permitted` while reading Safari cookies, grant Full Disk Access to your terminal app in System Settings, or switch to another browser source with `YTDLP_COOKIE_BROWSER`.

If you want to disable cookie loading on macOS, run:

```bash
export YTDLP_COOKIE_BROWSER=
```

If you want to override the default on macOS or Windows, set:

```bash
export YTDLP_COOKIE_BROWSER=chrome
```

PowerShell example:

```powershell
$env:YTDLP_COOKIE_BROWSER = "edge"
```

---

## Windows One-Command Setup

Before running the scripts, make sure these are installed and available in PATH:

* `yt-dlp.exe`
* `ffmpeg.exe`
* `git`

Download links:

* `yt-dlp.exe`: https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe
* `ffmpeg`: https://www.gyan.dev/ffmpeg/builds/

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

Then open PowerShell and run:

```powershell
git clone https://github.com/randomwalk0101/youtube-tools.git "$env:USERPROFILE\youtube-tools"
cd "$env:USERPROFILE\youtube-tools"
powershell -ExecutionPolicy Bypass -File .\windows\install.ps1
```

If PowerShell blocks scripts, run:

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

If you prefer manual download, put `yt-dlp.exe` and `ffmpeg.exe` into a folder that is already in PATH, or add the folder to PATH yourself and reopen PowerShell.

---

## Windows Usage

After installation, open a new PowerShell window and run the commands directly:

```powershell
ytdl
```

```powershell
ytaudio
```

```powershell
ytsub
```

```powershell
ytcut
```

If you prefer to run them from the repository without installing the launchers, you can still use the scripts directly:

```powershell
cd "$env:USERPROFILE\youtube-tools"
powershell -ExecutionPolicy Bypass -File .\windows\ytcut.ps1
```

```powershell
cd "$env:USERPROFILE\youtube-tools"
powershell -ExecutionPolicy Bypass -File .\windows\ytaudio.ps1
```

```powershell
cd "$env:USERPROFILE\youtube-tools"
powershell -ExecutionPolicy Bypass -File .\windows\ytsub.ps1
```

```powershell
cd "$env:USERPROFILE\youtube-tools"
powershell -ExecutionPolicy Bypass -File .\windows\ytdl.ps1
```

Output folders:

```text
%USERPROFILE%\Downloads\ytcut
%USERPROFILE%\Downloads\ytaudio
%USERPROFILE%\Downloads\ytsub
%USERPROFILE%\Downloads\ytdl
```

If you want to launch the tools with arguments, the Windows scripts also accept the URL as the first argument and, for the audio and cut tools, the number of seconds as the second argument.

---

## Recommended yt-dlp Installation Notes

On older macOS versions, using Homebrew to install `yt-dlp` may fail because of:

* unsupported macOS version
* Xcode version requirements
* Python version issues
* outdated `yt-dlp` packages

The recommended macOS method is the official standalone binary:

```bash
mkdir -p ~/bin
curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp_macos -o ~/bin/yt-dlp
chmod +x ~/bin/yt-dlp
~/bin/yt-dlp --version
```

---

## FFmpeg

FFmpeg is required for:

* cutting video samples
* cutting audio samples
* merging full videos
* converting subtitles

Check:

```bash
ffmpeg -version
```

---

## Proxy

If GitHub is inaccessible from Terminal, configure Git proxy.

Example for V2RayN HTTP port `10809`:

```bash
git config --global http.proxy http://127.0.0.1:10809
git config --global https.proxy http://127.0.0.1:10809
```

Remove proxy:

```bash
git config --global --unset http.proxy
git config --global --unset https.proxy
```

---

## Disclaimer

This project is intended for personal learning, research, subtitle extraction, content analysis, and educational use.

Please comply with YouTube Terms of Service and applicable copyright laws.

## Welcome donate

Bep20ï¼

```bash
0x5fab904fc0f0d03c0769f2964a167eb60dacf481
```

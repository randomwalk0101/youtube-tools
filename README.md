

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
````

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

---

## Windows One-Command Setup

Before running the scripts, make sure these are installed and available in PATH:

* `yt-dlp.exe`
* `ffmpeg.exe`
* `git`

Then open PowerShell and run:

```powershell
git clone https://github.com/randomwalk0101/youtube-tools.git "$env:USERPROFILE\youtube-tools"
```

If PowerShell blocks scripts, run:

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

---

## Windows Usage

Run these from PowerShell:

```powershell
cd "$env:USERPROFILE\youtube-tools"
.\windows\ytcut.ps1
```

```powershell
cd "$env:USERPROFILE\youtube-tools"
.\windows\ytaudio.ps1
```

```powershell
cd "$env:USERPROFILE\youtube-tools"
.\windows\ytsub.ps1
```

```powershell
cd "$env:USERPROFILE\youtube-tools"
.\windows\ytdl.ps1
```

Output folders:

```text
%USERPROFILE%\Downloads\ytcut
%USERPROFILE%\Downloads\ytaudio
%USERPROFILE%\Downloads\ytsub
%USERPROFILE%\Downloads\ytdl
```

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

Bep20：

```bash
0x5fab904fc0f0d03c0769f2964a167eb60dacf481
```

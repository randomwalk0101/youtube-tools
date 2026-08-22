# youtube-tools

Personal command-line helpers for downloading and processing YouTube videos, audio, and subtitles.

## Tools

- `ytcut` - download the first N seconds of a YouTube video as MP4.
- `ytaudio` - download full YouTube audio, or only the first N seconds, as MP3.
- `ytsub` - download subtitles and export clean TXT, SRT, or both.
- `ytdl` - download full YouTube videos with selectable quality and optional embedded subtitles.

## macOS Quick Setup

This is the recommended setup for a new Mac.

```bash
xcode-select --install
```

Install Homebrew if the Mac does not already have it:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Install required dependencies:

```bash
brew install git ffmpeg
mkdir -p ~/bin
curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp_macos -o ~/bin/yt-dlp
chmod +x ~/bin/yt-dlp
grep -qxF 'export PATH="$HOME/bin:$PATH"' ~/.zshrc || echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

Clone and install the tools:

```bash
git clone https://github.com/randomwalk0101/youtube-tools.git ~/youtube-tools
cd ~/youtube-tools
cp mac/ytcut ~/bin/ytcut
cp mac/ytaudio ~/bin/ytaudio
cp mac/ytsub ~/bin/ytsub
cp mac/ytdl ~/bin/ytdl
chmod +x ~/bin/ytcut ~/bin/ytaudio ~/bin/ytsub ~/bin/ytdl
```

Verify:

```bash
yt-dlp --version
ffmpeg -version
ytcut
```

Press `Control + C` if you only want to confirm the command starts.

## macOS Usage

Run the commands directly from Terminal:

```bash
ytcut
ytaudio
ytsub
ytdl
```

Most tools can also accept arguments, which is useful for automation:

```bash
ytaudio "https://www.youtube.com/watch?v=VIDEO_ID"
ytaudio "https://www.youtube.com/watch?v=VIDEO_ID" 60
ytsub "https://www.youtube.com/watch?v=VIDEO_ID" txt
ytsub "https://www.youtube.com/watch?v=VIDEO_ID" srt
ytsub "https://www.youtube.com/watch?v=VIDEO_ID" both
```

## Output Folders

Default output folders:

```text
~/Downloads/ytcut
~/Downloads/ytaudio
~/Downloads/ytsub
~/Downloads/ytdl
```

Optional environment variables:

```bash
export YTDLP_COOKIE_BROWSER=chrome
export YTAUDIO_OUT_DIR="$HOME/Downloads/ytaudio"
export YTSUB_OUT_DIR="$HOME/Downloads/ytsub"
```

## Cookie Notes

The macOS scripts use Safari cookies by default:

```text
yt-dlp --cookies-from-browser safari
```

If macOS shows `Operation not permitted` while reading Safari cookies, grant Full Disk Access to Terminal, iTerm, or the app you use to run these commands.

To switch browser cookies:

```bash
export YTDLP_COOKIE_BROWSER=chrome
```

To disable browser-cookie loading:

```bash
export YTDLP_COOKIE_BROWSER=
```

## Tool Details

`ytcut`

- Prompts for a YouTube link and seconds.
- Downloads a temporary MP4 up to 720p, cuts the first N seconds with FFmpeg, and saves an MP4.
- Output: `~/Downloads/ytcut`.

`ytaudio`

- Prompts for a YouTube link if no URL argument is provided.
- If seconds are not provided, waits 10 seconds and then downloads the full audio by default.
- Supports common YouTube URL formats including watch links, `youtu.be`, `live`, `shorts`, and `embed`.
- Output can be changed with `YTAUDIO_OUT_DIR`.

`ytsub`

- Prompts for a YouTube link if no URL argument is provided.
- Supports output formats: `txt`, `srt`, `both`.
- Defaults to TXT when no output format is provided.
- Auto-selects `zh-Hans` after 10 seconds when available.
- Skips `live_chat` records because they are not real subtitles.
- For videos without usable subtitles, falls back to `ytaudio`.
- Output can be changed with `YTSUB_OUT_DIR`.

`ytdl`

- Prompts for a YouTube link.
- Lists available video qualities.
- Downloads selected quality and merges audio/video to MP4.
- Can embed Chinese, English, Chinese plus English, or all available subtitles.
- Output: `~/Downloads/ytdl`.

## Updating Existing Install

If the repo already exists on the Mac:

```bash
cd ~/youtube-tools
git pull
cp mac/ytcut ~/bin/ytcut
cp mac/ytaudio ~/bin/ytaudio
cp mac/ytsub ~/bin/ytsub
cp mac/ytdl ~/bin/ytdl
chmod +x ~/bin/ytcut ~/bin/ytaudio ~/bin/ytsub ~/bin/ytdl
```

## Windows

Windows scripts are included under `windows/`.

Requirements:

- Windows 10 or Windows 11
- PowerShell
- Git
- `yt-dlp.exe`
- `ffmpeg.exe`

Clone and install:

```powershell
git clone https://github.com/randomwalk0101/youtube-tools.git "$env:USERPROFILE\youtube-tools"
cd "$env:USERPROFILE\youtube-tools"
powershell -ExecutionPolicy Bypass -File .\windows\install.ps1
```

Then open a new PowerShell window and run:

```powershell
ytdl
ytaudio
ytsub
ytcut
```

See `windows/README.md` for Windows-specific notes.

## Proxy

If GitHub is inaccessible from Terminal, configure a Git proxy.

Example for local HTTP proxy port `10809`:

```bash
git config --global http.proxy http://127.0.0.1:10809
git config --global https.proxy http://127.0.0.1:10809
```

Remove proxy:

```bash
git config --global --unset http.proxy
git config --global --unset https.proxy
```

## Notes

This repository is for personal learning, research, subtitle extraction, content analysis, and educational use. Please comply with YouTube Terms of Service and applicable copyright laws.

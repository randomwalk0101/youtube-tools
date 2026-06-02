# YouTube Tools

Simple command-line tools for downloading and analyzing YouTube content.

## Features

### ytcut

Download the first N seconds of a YouTube video.

Output:

- MP4

### ytaudio

Download the first N seconds of YouTube audio.

Output:

- MP3

### ytsub

Download YouTube subtitles.

Features:

- Automatically detect available subtitle languages
- Select subtitle language by number
- Export multiple formats

Output:

- VTT
- SRT
- TXT

### ytdl

Download full YouTube videos.

Features:

- Automatically detect available video qualities
- Select quality by number
- Automatically merge video and audio
- Output MP4

Supported qualities depend on the source video.

Examples:

- 2160p
- 1440p
- 1080p
- 720p
- 480p

## Requirements

### Operating System

Currently tested on:

- macOS 12 Monterey
- Intel MacBook Pro
- macOS with V2RayN proxy

Windows support is planned.

### yt-dlp

Recommended installation on macOS:

Do not use Homebrew on older macOS versions.

Older macOS systems may encounter:

- Homebrew Tier 3 warnings
- Xcode version issues
- Python version issues
- Outdated yt-dlp packages
- nsig extraction failed
- Only images are available for download

Recommended:

mkdir -p ~/bin

curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp_macos -o ~/bin/yt-dlp

chmod +x ~/bin/yt-dlp

~/bin/yt-dlp --version

Verify that a recent version is installed.

### FFmpeg

Required by:

- ytcut
- ytaudio
- ytdl
- subtitle conversion

Check installation:

ffmpeg -version

Install FFmpeg if it is not available.

## Installation

Clone repository:

git clone https://github.com/randomwalk0101/youtube-tools.git

cd youtube-tools

Create local binary directory:

mkdir -p ~/bin

Install scripts:

cp mac/ytcut ~/bin/ytcut
cp mac/ytaudio ~/bin/ytaudio
cp mac/ytsub ~/bin/ytsub
cp mac/ytdl ~/bin/ytdl

Make executable:

chmod +x ~/bin/ytcut
chmod +x ~/bin/ytaudio
chmod +x ~/bin/ytsub
chmod +x ~/bin/ytdl

If ~/bin is not in PATH:

echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc

source ~/.zshrc

## Usage

ytcut

ytaudio

ytsub

ytdl

## Output Folders

ytcut

~/Downloads/ytcut

ytaudio

~/Downloads/ytaudio

ytsub

~/Downloads/ytsub

ytdl

~/Downloads/ytdl

## GitHub Connectivity

If GitHub is inaccessible from terminal, configure Git proxy.

Example for V2RayN HTTP port 10809:

git config --global http.proxy http://127.0.0.1:10809

git config --global https.proxy http://127.0.0.1:10809

Remove proxy:

git config --global --unset http.proxy

git config --global --unset https.proxy

## Roadmap

Current

- ytcut
- ytaudio
- ytsub
- ytdl

Planned

- Windows scripts
- ytinfo
- ytanalyse

## Disclaimer

This project is intended for personal learning, research, subtitle extraction, content analysis, and educational use.

Please comply with YouTube Terms of Service and applicable copyright laws.


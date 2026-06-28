$url = Read-Host "YouTube URL"

function Get-YtDlpCookieArgs {
    $browser = $env:YTDLP_COOKIE_BROWSER
    if ([string]::IsNullOrWhiteSpace($browser)) {
        $browser = "chrome"
    }

    return @("--cookies-from-browser", $browser)
}

$outdir = "$env:USERPROFILE\Downloads\ytdl"
New-Item -ItemType Directory -Force -Path $outdir | Out-Null
$cookieArgs = Get-YtDlpCookieArgs

if (-not (Get-Command yt-dlp.exe -ErrorAction SilentlyContinue)) {
    Write-Host "Cannot find yt-dlp.exe. Please install yt-dlp first."
    exit
}

if (-not (Get-Command ffmpeg.exe -ErrorAction SilentlyContinue)) {
    Write-Host "Cannot find ffmpeg.exe. Please install ffmpeg first."
    exit
}

if ($url -match "v=([^&]+)") {
    $id = $Matches[1]
} elseif ($url -match "youtu\.be/([^?&/]+)") {
    $id = $Matches[1]
} else {
    Write-Host "Cannot find video ID"
    exit
}

$clean = "https://www.youtube.com/watch?v=$id"

Write-Host ""
Write-Host "Video ID: $id"
Write-Host "Reading available qualities..."
Write-Host ""

$json = yt-dlp.exe @cookieArgs -J --no-playlist $clean | ConvertFrom-Json

$formats = $json.formats |
    Where-Object { $_.vcodec -ne "none" -and $_.height } |
    Sort-Object height, fps -Descending

$list = @()
$seen = @{}

foreach ($f in $formats) {
    $key = "$($f.height)-$($f.fps)-$($f.ext)"
    if (-not $seen.ContainsKey($key)) {
        $seen[$key] = $true
        $list += $f
    }
}

Write-Host "Available qualities:"
for ($i = 0; $i -lt $list.Count; $i++) {
    $n = $i + 1
    $f = $list[$i]
    Write-Host "$n. $($f.height)p $($f.fps)fps $($f.ext) + m4a format=$($f.format_id)"
}

Write-Host ""
Write-Host "0. Auto best quality"
$choice = Read-Host "Choose quality number"

if ($choice -eq "0" -or $choice -eq "") {
    $format = "bv*[ext=mp4]+ba[ext=m4a]/bv*+ba/best"
} else {
    if (-not ($choice -as [int]) -or [int]$choice -lt 1 -or [int]$choice -gt $list.Count) {
        Write-Host "Invalid choice"
        exit
    }

    $selected = $list[[int]$choice - 1]
    $format = "$($selected.format_id)+ba[ext=m4a]/best"
}

Write-Host ""
Write-Host "Subtitle options:"
Write-Host "0. No subtitles"
Write-Host "1. Chinese subtitles"
Write-Host "2. English subtitles"
Write-Host "3. Chinese + English subtitles (default)"
Write-Host "4. All available subtitles"

$subChoice = Read-Host "Choose subtitle language, press Enter for default"

$subArgs = @()

if ($subChoice -eq "0") {
    $subArgs = @()
} elseif ($subChoice -eq "1") {
    $subArgs = @(
        "--write-sub",
        "--write-auto-sub",
        "--sub-langs", "zh-Hans,zh-CN,zh,zh-Hant",
        "--embed-subs"
    )
} elseif ($subChoice -eq "2") {
    $subArgs = @(
        "--write-sub",
        "--write-auto-sub",
        "--sub-langs", "en",
        "--embed-subs"
    )
} elseif ($subChoice -eq "4") {
    $subArgs = @(
        "--write-sub",
        "--write-auto-sub",
        "--all-subs",
        "--embed-subs"
    )
} else {
    $subArgs = @(
        "--write-sub",
        "--write-auto-sub",
        "--sub-langs", "zh-Hans,zh-CN,zh,zh-Hant,en",
        "--embed-subs"
    )
}

Write-Host ""
Write-Host "Start downloading..."
Write-Host "Output folder: $outdir"
Write-Host ""

yt-dlp.exe `
    @cookieArgs `
    $clean `
    --no-playlist `
    -f $format `
    --merge-output-format mp4 `
    @subArgs `
    -o "$outdir\%(title)s.%(ext)s"

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "Done. Output folder: $outdir"
} else {
    Write-Host ""
    Write-Host "Download failed."
    exit $LASTEXITCODE
}

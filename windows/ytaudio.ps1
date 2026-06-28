$url = if ($args.Count -ge 1 -and -not [string]::IsNullOrWhiteSpace($args[0])) {
    $args[0]
} else {
    Read-Host "YouTube URL"
}

$seconds = if ($args.Count -ge 2 -and -not [string]::IsNullOrWhiteSpace($args[1])) {
    $args[1]
} else {
    Read-Host "Extract first N seconds audio (press Enter for full audio)"
}

function Get-YtDlpCookieArgs {
    $browser = $env:YTDLP_COOKIE_BROWSER
    if ([string]::IsNullOrWhiteSpace($browser)) {
        $browser = "chrome"
    }

    return @("--cookies-from-browser", $browser)
}

$outdir = "$env:USERPROFILE\Downloads\ytaudio"
$tmpdir = "$outdir\tmp"

New-Item -ItemType Directory -Force -Path $tmpdir | Out-Null
$cookieArgs = Get-YtDlpCookieArgs

if ($url -match "v=([^&]+)") {
    $id = $Matches[1]
}
elseif ($url -match "youtu\.be/([^?&/]+)") {
    $id = $Matches[1]
}
else {
    Write-Host "Cannot find video ID"
    exit
}

$clean = "https://www.youtube.com/watch?v=$id"

yt-dlp.exe @cookieArgs $clean `
    --no-playlist `
    -f "bestaudio/best" `
    -o "$tmpdir\audio.%(ext)s"

$file = Get-ChildItem $tmpdir | Select-Object -First 1

$title = yt-dlp.exe @cookieArgs --get-title --no-playlist $clean

$safe = ($title -replace '[\\/:*?"<>|]', '_')

if ($safe.Length -gt 80) {
    $safe = $safe.Substring(0,80)
}

if ([string]::IsNullOrWhiteSpace($seconds)) {

    $outfile = "$outdir\${safe}_full.mp3"

    ffmpeg.exe `
        -y `
        -i $file.FullName `
        -vn `
        -ar 44100 `
        -ac 2 `
        -b:a 192k `
        $outfile
}
else {

    $outfile = "$outdir\${safe}_${seconds}s.mp3"

    ffmpeg.exe `
        -y `
        -i $file.FullName `
        -t $seconds `
        -vn `
        -ar 44100 `
        -ac 2 `
        -b:a 192k `
        $outfile
}

Remove-Item $tmpdir -Recurse -Force

Write-Host ""
Write-Host "Done: $outfile"

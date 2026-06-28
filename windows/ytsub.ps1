$url = Read-Host "YouTube URL"

function Get-YtDlpCookieArgs {
    $browser = $env:YTDLP_COOKIE_BROWSER
    if ([string]::IsNullOrWhiteSpace($browser)) {
        $browser = "chrome"
    }

    return @("--cookies-from-browser", $browser)
}

$outdir = "$env:USERPROFILE\Downloads\ytsub"
$tmpdir = "$outdir\tmp"
New-Item -ItemType Directory -Force -Path $tmpdir | Out-Null
$cookieArgs = Get-YtDlpCookieArgs

if ($url -match "v=([^&]+)") {
    $id = $Matches[1]
} elseif ($url -match "youtu\.be/([^?&/]+)") {
    $id = $Matches[1]
} else {
    Write-Host "Cannot find video ID"
    exit
}

$clean = "https://www.youtube.com/watch?v=$id"
$json = yt-dlp.exe @cookieArgs -J --no-playlist $clean | ConvertFrom-Json

$items = @()

foreach ($p in $json.subtitles.PSObject.Properties) {
    $items += [PSCustomObject]@{Kind="manual"; Lang=$p.Name}
}

foreach ($p in $json.automatic_captions.PSObject.Properties) {
    $items += [PSCustomObject]@{Kind="auto"; Lang=$p.Name}
}

if ($items.Count -eq 0) {
    Write-Host "No subtitles available"
    exit
}

for ($i = 0; $i -lt $items.Count; $i++) {
    $n = $i + 1
    Write-Host "$n. $($items[$i].Lang) [$($items[$i].Kind)]"
}

$choice = Read-Host "Choose subtitle number"
$item = $items[[int]$choice - 1]

$title = yt-dlp.exe @cookieArgs --get-title --no-playlist $clean
$safe = ($title -replace '[\\/:*?"<>|]', '_')
if ($safe.Length -gt 80) { $safe = $safe.Substring(0,80) }

if ($item.Kind -eq "manual") {
    yt-dlp.exe @cookieArgs $clean --no-playlist --skip-download --write-subs --sub-langs $item.Lang --sub-format "vtt/best" -o "$tmpdir\sub.%(ext)s"
} else {
    yt-dlp.exe @cookieArgs $clean --no-playlist --skip-download --write-auto-subs --sub-langs $item.Lang --sub-format "vtt/best" -o "$tmpdir\sub.%(ext)s"
}

$vtt = Get-ChildItem $tmpdir -Filter "*.vtt" | Select-Object -First 1

if (-not $vtt) {
    Write-Host "Subtitle download failed"
    exit
}

$finalBase = "$outdir\${safe}_$($item.Lang)_$($item.Kind)"
$finalVtt = "$finalBase.vtt"
$finalSrt = "$finalBase.srt"
$finalTxt = "$finalBase.txt"

Copy-Item $vtt.FullName $finalVtt -Force
ffmpeg.exe -y -i $finalVtt $finalSrt | Out-Null

Get-Content $finalVtt |
    Where-Object {
        $_ -notmatch "WEBVTT" -and
        $_ -notmatch "-->" -and
        $_.Trim() -ne "" -and
        $_ -notmatch "^Kind:" -and
        $_ -notmatch "^Language:"
    } |
    ForEach-Object { ($_ -replace "<[^>]+>", "").Trim() } |
    Where-Object { $_ -ne "" } |
    Set-Content $finalTxt -Encoding UTF8

Remove-Item $tmpdir -Recurse -Force

Write-Host "Done:"
Write-Host $finalVtt
Write-Host $finalSrt
Write-Host $finalTxt

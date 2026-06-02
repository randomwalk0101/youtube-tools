$url = Read-Host "YouTube URL"
$seconds = Read-Host "Download first N seconds"

$outdir = "$env:USERPROFILE\Downloads\ytcut"
$tmpdir = "$outdir\tmp"
New-Item -ItemType Directory -Force -Path $tmpdir | Out-Null

if ($url -match "v=([^&]+)") {
    $id = $Matches[1]
} elseif ($url -match "youtu\.be/([^?&/]+)") {
    $id = $Matches[1]
} else {
    Write-Host "Cannot find video ID"
    exit
}

$clean = "https://www.youtube.com/watch?v=$id"

yt-dlp.exe $clean --no-playlist -f "best[height<=720][ext=mp4]/best[height<=720]/best" -o "$tmpdir\full.%(ext)s"

$file = Get-ChildItem $tmpdir | Select-Object -First 1
$title = yt-dlp.exe --get-title --no-playlist $clean
$safe = ($title -replace '[\\/:*?"<>|]', '_')
if ($safe.Length -gt 80) { $safe = $safe.Substring(0,80) }

$outfile = "$outdir\${safe}_${seconds}s.mp4"

ffmpeg.exe -y -i $file.FullName -t $seconds -c copy $outfile

Remove-Item $tmpdir -Recurse -Force
Write-Host "Done: $outfile"

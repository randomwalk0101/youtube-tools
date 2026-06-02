$url = Read-Host "YouTube URL"
$seconds = Read-Host "Extract first N seconds audio"

$outdir = "$env:USERPROFILE\Downloads\ytaudio"
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

yt-dlp.exe $clean --no-playlist -f "bestaudio/best" -o "$tmpdir\audio.%(ext)s"

$file = Get-ChildItem $tmpdir | Select-Object -First 1
$title = yt-dlp.exe --get-title --no-playlist $clean
$safe = ($title -replace '[\\/:*?"<>|]', '_')
if ($safe.Length -gt 80) { $safe = $safe.Substring(0,80) }

$outfile = "$outdir\${safe}_${seconds}s.mp3"

ffmpeg.exe -y -i $file.FullName -t $seconds -vn -ar 44100 -ac 2 -b:a 192k $outfile

Remove-Item $tmpdir -Recurse -Force
Write-Host "Done: $outfile"

$url = Read-Host "YouTube URL"
$outdir = "$env:USERPROFILE\Downloads\ytdl"
New-Item -ItemType Directory -Force -Path $outdir | Out-Null

if ($url -match "v=([^&]+)") {
    $id = $Matches[1]
} elseif ($url -match "youtu\.be/([^?&/]+)") {
    $id = $Matches[1]
} else {
    Write-Host "Cannot find video ID"
    exit
}

$clean = "https://www.youtube.com/watch?v=$id"

Write-Host "Reading available qualities..."
$json = yt-dlp.exe -J --no-playlist $clean | ConvertFrom-Json

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

for ($i = 0; $i -lt $list.Count; $i++) {
    $n = $i + 1
    $f = $list[$i]
    Write-Host "$n. $($f.height)p $($f.fps)fps $($f.ext) + m4a format=$($f.format_id)"
}

Write-Host "0. Auto best quality"
$choice = Read-Host "Choose quality number"

if ($choice -eq "0" -or $choice -eq "") {
    $format = "bv*[ext=mp4]+ba[ext=m4a]/bv*+ba/best"
} else {
    $selected = $list[[int]$choice - 1]
    $format = "$($selected.format_id)+ba[ext=m4a]/best"
}

yt-dlp.exe $clean --no-playlist -f $format --merge-output-format mp4 -o "$outdir\%(title)s.%(ext)s"
Write-Host "Done. Output folder: $outdir"

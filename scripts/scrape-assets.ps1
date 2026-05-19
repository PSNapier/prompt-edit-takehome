<#
.SYNOPSIS
  Download all images and videos from a webpage into ./images and ./videos.

.EXAMPLE
  .\scrape-assets.ps1
  .\scrape-assets.ps1 -Url "https://example.com" -OutDir "C:\out"
#>
[CmdletBinding()]
param(
    [string]$Url = "https://www.contentcreator.com/prompt-edit",
    [string]$OutDir = "C:\Users\arjon\Downloads\prompt-edit-takehome"
)

$ErrorActionPreference = "Stop"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$imageDir = Join-Path $OutDir "images"
$videoDir = Join-Path $OutDir "videos"
New-Item -ItemType Directory -Force -Path $imageDir, $videoDir | Out-Null

$imageExt = @('.jpg','.jpeg','.png','.gif','.webp','.svg','.bmp','.avif')
$videoExt = @('.mp4','.webm','.mov','.m4v','.ogg','.ogv')

Write-Host "Fetching $Url ..." -ForegroundColor Cyan
$ua = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/124.0 Safari/537.36"
$resp = Invoke-WebRequest -Uri $Url -UserAgent $ua -UseBasicParsing
$html = $resp.Content
$base = [Uri]$Url

function Resolve-AssetUrl {
    param([string]$raw, [Uri]$base)
    if ([string]::IsNullOrWhiteSpace($raw)) { return $null }
    $raw = $raw.Trim().Trim('"',"'")
    if ($raw.StartsWith('data:')) { return $null }
    if ($raw.StartsWith('//'))   { return "https:$raw" }
    try { return ([Uri]::new($base, $raw)).AbsoluteUri } catch { return $null }
}

$urls = New-Object System.Collections.Generic.HashSet[string]

# src / data-src / poster attributes
$attrRegex = '(?i)(?:src|data-src|data-lazy-src|data-original|poster|href)\s*=\s*["'']([^"'']+)["'']'
foreach ($m in [regex]::Matches($html, $attrRegex)) {
    $u = Resolve-AssetUrl $m.Groups[1].Value $base
    if ($u) { [void]$urls.Add($u) }
}

# srcset (comma-separated, each "url size")
$srcsetRegex = '(?i)srcset\s*=\s*["'']([^"'']+)["'']'
foreach ($m in [regex]::Matches($html, $srcsetRegex)) {
    foreach ($part in $m.Groups[1].Value -split ',') {
        $candidate = ($part.Trim() -split '\s+')[0]
        $u = Resolve-AssetUrl $candidate $base
        if ($u) { [void]$urls.Add($u) }
    }
}

# CSS url(...)
$cssRegex = '(?i)url\(\s*["'']?([^"''\)]+)["'']?\s*\)'
foreach ($m in [regex]::Matches($html, $cssRegex)) {
    $u = Resolve-AssetUrl $m.Groups[1].Value $base
    if ($u) { [void]$urls.Add($u) }
}

Write-Host "Found $($urls.Count) candidate URLs" -ForegroundColor Cyan

$downloaded = 0; $skipped = 0; $failed = 0
foreach ($u in $urls) {
    try {
        $path = ([Uri]$u).AbsolutePath
        $ext = [IO.Path]::GetExtension($path).ToLower()
        $dest = $null
        if     ($imageExt -contains $ext) { $dest = $imageDir }
        elseif ($videoExt -contains $ext) { $dest = $videoDir }
        else { $skipped++; continue }

        $name = [IO.Path]::GetFileName($path)
        if ([string]::IsNullOrWhiteSpace($name)) { $skipped++; continue }
        # Deduplicate filename collisions
        $target = Join-Path $dest $name
        $i = 1
        while (Test-Path $target) {
            $stem = [IO.Path]::GetFileNameWithoutExtension($name)
            $target = Join-Path $dest "$stem`_$i$ext"
            $i++
        }

        Write-Host "  -> $u" -ForegroundColor DarkGray
        Invoke-WebRequest -Uri $u -UserAgent $ua -OutFile $target -UseBasicParsing
        $downloaded++
    } catch {
        Write-Warning "Failed: $u  ($($_.Exception.Message))"
        $failed++
    }
}

# ---------------------------------------------------------------------------
# Wistia videos: page embeds Wistia HLS players (no direct .mp4 in HTML).
# We find embedded media IDs and resolve them to MP4 via the public JSON API.
# ---------------------------------------------------------------------------
Write-Host ""
Write-Host "Resolving Wistia video embeds..." -ForegroundColor Cyan

$wistiaIds = New-Object System.Collections.Generic.HashSet[string]
foreach ($m in [regex]::Matches($html, '(?i)(?:fast\.wistia\.(?:com|net)/embed/(?:iframe|medias)/|wvideo=)([a-z0-9]{10})')) {
    [void]$wistiaIds.Add($m.Groups[1].Value)
}

# Also accept IDs passed in via env var WISTIA_IDS (comma/space-separated),
# useful when IDs were captured from a live browser session.
if ($env:WISTIA_IDS) {
    foreach ($id in ($env:WISTIA_IDS -split '[\s,]+')) {
        if ($id -match '^[a-z0-9]{10}$') { [void]$wistiaIds.Add($id) }
    }
}

Write-Host "Found $($wistiaIds.Count) Wistia media IDs" -ForegroundColor Cyan

# Preferred quality order: 720p -> 540p -> 1080p -> first mp4 we see.
$qualityPref = @('hd_mp4_video:720p', 'md_mp4_video:540p', 'hd_mp4_video:1080p')

foreach ($id in $wistiaIds) {
    try {
        $meta = Invoke-WebRequest -Uri "https://fast.wistia.com/embed/medias/$id.json" -UserAgent $ua -UseBasicParsing
        $j = $meta.Content | ConvertFrom-Json
        $assets = $j.media.assets

        $picked = $null
        foreach ($pref in $qualityPref) {
            $parts = $pref -split ':'
            $picked = $assets | Where-Object { $_.type -eq $parts[0] -and $_.display_name -eq $parts[1] } | Select-Object -First 1
            if ($picked) { break }
        }
        if (-not $picked) {
            $picked = $assets | Where-Object { $_.type -like '*mp4*' } | Sort-Object -Property size | Select-Object -First 1
        }
        if (-not $picked) { Write-Warning "No MP4 asset for $id"; $failed++; continue }

        $title = ($j.media.name -replace '[\\\/\:\*\?"<>\|]', '_').Trim()
        if (-not $title) { $title = $id }
        $name = "$title`_$id.mp4"
        $target = Join-Path $videoDir $name
        if (Test-Path $target) {
            Write-Host "  skip (exists): $name" -ForegroundColor DarkGray
            $skipped++; continue
        }

        $mp4Url = $picked.url -replace '\.bin$', '.mp4'
        Write-Host ("  -> {0}  ({1}, {2:N1} MB)" -f $name, $picked.display_name, ($picked.size/1MB)) -ForegroundColor DarkGray
        Invoke-WebRequest -Uri $mp4Url -UserAgent $ua -OutFile $target -UseBasicParsing
        $downloaded++
    } catch {
        Write-Warning "Wistia $id failed: $($_.Exception.Message)"
        $failed++
    }
}

Write-Host ""
Write-Host "Done. Downloaded: $downloaded  Skipped: $skipped  Failed: $failed" -ForegroundColor Green
Write-Host "Images: $imageDir"
Write-Host "Videos: $videoDir"

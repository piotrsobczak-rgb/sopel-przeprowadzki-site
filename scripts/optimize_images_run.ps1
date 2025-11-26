# One-off converter: reliably convert PNG/JPG files in images folder to WebP using magick
$siteImages = Join-Path $PSScriptRoot '..\images'
$siteImages = (Resolve-Path $siteImages).ProviderPath
Write-Output "Images folder: $siteImages"

if(-not (Test-Path $siteImages)){
    Write-Error "Images folder not found: $siteImages"
    exit 1
}

$files = Get-ChildItem -Path (Join-Path $siteImages '*') -Include '*.png','*.jpg','*.jpeg' -File
if($files.Count -eq 0){ Write-Output "No PNG/JPG files found in $siteImages"; exit 0 }

$magick = Get-Command magick -ErrorAction SilentlyContinue
if(-not $magick){ Write-Error "magick not found. Install ImageMagick and ensure 'magick' is on PATH."; exit 2 }

foreach($f in $files){
    $webp = Join-Path $f.DirectoryName ([IO.Path]::GetFileNameWithoutExtension($f.Name) + '.webp')
    if(Test-Path $webp){ Write-Output "WebP already exists for $($f.Name), skipping."; continue }
    Write-Output "Converting $($f.Name) -> $(Split-Path $webp -Leaf) using magick"
    & magick convert "$($f.FullName)" -quality 80 "$webp"
}

Write-Output "Done. If conversions ran, .webp files are next to the originals."
<#
Optimize images into WebP using ImageMagick (magick) or cwebp if available.
Usage: run this script from PowerShell: .\optimize_images.ps1
#>

$siteImages = Join-Path $PSScriptRoot '..\images'
$siteImages = (Resolve-Path $siteImages).ProviderPath
Write-Output "Images folder: $siteImages"

# Find converter
$magick = Get-Command magick -ErrorAction SilentlyContinue
$cwebp = Get-Command cwebp -ErrorAction SilentlyContinue

if(-not (Test-Path $siteImages)){
    Write-Error "Images folder not found: $siteImages"
    exit 1
}

$files = Get-ChildItem -Path $siteImages -Include *.png,*.jpg,*.jpeg -File
if($files.Count -eq 0){ Write-Output "No PNG/JPG files found in $siteImages"; exit 0 }

foreach($f in $files){
    $webp = Join-Path $f.DirectoryName ([IO.Path]::GetFileNameWithoutExtension($f.Name) + '.webp')
    if(Test-Path $webp){ Write-Output "WebP already exists for $($f.Name), skipping."; continue }

    if($magick){
        Write-Output "Converting $($f.Name) -> $(Split-Path $webp -Leaf) using magick"
        & magick convert "$($f.FullName)" -quality 80 "$webp"
    }
    elseif($cwebp){
        Write-Output "Converting $($f.Name) -> $(Split-Path $webp -Leaf) using cwebp"
        & cwebp "-q" "80" "-o" "$webp" "$($f.FullName)" | Out-Null
    }
    else{
        Write-Warning "No converter found (magick or cwebp). Install ImageMagick or libwebp's cwebp and re-run this script."
        break
    }
}

Write-Output "Done. If conversions ran, .webp files are next to the originals."
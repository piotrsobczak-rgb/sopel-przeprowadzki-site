<#
Netlify deploy helper. If you have Netlify CLI (ntl or netlify), this script will deploy the current folder.
It will try to use 'netlify' or 'ntl' if available. If not, it prints instructions to install via npm.
#>

$site = Resolve-Path "$PSScriptRoot\.." | Select-Object -ExpandProperty Path
Write-Output "Site path: $site"

$netlify = Get-Command netlify -ErrorAction SilentlyContinue
$ntl = Get-Command ntl -ErrorAction SilentlyContinue

if($netlify -or $ntl){
    $cmd = if($netlify) { 'netlify' } else { 'ntl' }
    Write-Output "Using $cmd to deploy. You will be prompted to login if not authenticated."
    Push-Location $site
    & $cmd deploy --dir=. --prod
    Pop-Location
} else {
    Write-Output "Netlify CLI not found. Install via npm: npm i -g netlify-cli"
    Write-Output "After install, run this script again."
}

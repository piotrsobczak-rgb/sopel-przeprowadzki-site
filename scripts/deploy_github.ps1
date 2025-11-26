<#
Deploy helper for GitHub. This script initializes git in the site folder and guides you to create a GitHub repo.
It will try to use 'gh' (GitHub CLI) if available to create a repo, otherwise it prints the commands you should run.
Run from PowerShell with elevation if necessary.
#>

param(
  [string]$RepoName = "sopel-przeprowadzki-site",
  [string]$Remote = "origin"
)

$site = Resolve-Path "$PSScriptRoot\.." | Select-Object -ExpandProperty Path
Write-Output "Site path: $site"

# Check git
$git = Get-Command git -ErrorAction SilentlyContinue
if(-not $git){ Write-Error "Git not found. Install Git for Windows first: https://git-scm.com/download/win"; exit 1 }

Push-Location $site
if(-not (Test-Path ".git")){
    git init
    git add -A
    git commit -m "Initial site commit"
} else { Write-Output "Git repo already initialized." }

$gh = Get-Command gh -ErrorAction SilentlyContinue
if($gh){
    Write-Output "GitHub CLI found. Creating remote repo '$RepoName' (private=false)."
    gh repo create $RepoName --public --source=. --remote=$Remote --push
    Write-Output "Repo created and pushed. Visit https://github.com/$(gh repo view --json owner -q .owner.login)/$RepoName"
} else {
    Write-Output "GitHub CLI not found. To create a repository manually, run these commands (replace USER/REPO):"
    Write-Output "git remote add origin https://github.com/YOUR_USER/$RepoName.git"
    Write-Output "git branch -M main"
    Write-Output "git push -u origin main"
}

# After push, the included workflow will publish to gh-pages branch automatically.
Pop-Location
Write-Output "Done. If you used gh CLI, repo should be created and pushed. If not, run the printed commands to push."
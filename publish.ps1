$ErrorActionPreference = "Stop"
$RepoName = "banking-market-capitalisation-pyspark"
$Description = "PySpark ETL and market analysis of the ten largest banks by market capitalisation"

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    throw "GitHub CLI (gh) is not installed. Install it, then rerun this script from the project root."
}
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw "Git is not installed. Install it, then rerun this script from the project root."
}
gh auth status
if (-not (Test-Path ".git")) { git init -b main }
$currentBranch = (git branch --show-current).Trim()
if ($currentBranch -ne "main") { git branch -M main }
git add .
git rev-parse --verify HEAD 2>$null | Out-Null
$hasCommit = ($LASTEXITCODE -eq 0)
if (-not $hasCommit) {
    git commit -m "Initial commit: PySpark banking market-capitalisation analysis"
} else {
    git diff --cached --quiet
    if ($LASTEXITCODE -ne 0) { git commit -m "Add banking market-capitalisation analysis project" }
}
# Creates a PUBLIC GitHub repository under the authenticated account and pushes main.
# Change --public to --private below if the project should remain private.
gh repo create $RepoName --public --source . --remote origin --push --description $Description

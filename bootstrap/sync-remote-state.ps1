$ErrorActionPreference = "Stop"

$repos = @(
  "C:\XPS\xps-intelligence-control-plane",
  "C:\XPS\xps-intelligence-system",
  "C:\XPS\xps-intel",
  "C:\XPS\xps-distallation-system",
  "C:\XPS\xps-ui",
  "C:\XPS\xps-source-adapter-template",
  "C:\XPS\xps-google-workspace-bridge",
  "C:\XPS\xps-analytics-bi",
  "C:\XPS\xps-employee-copilots"
)

foreach ($repo in $repos) {
  if (-not (Test-Path (Join-Path $repo ".git"))) {
    continue
  }

  Write-Host "---- $repo ----" -ForegroundColor Cyan
  git -C $repo fetch origin
  $branch = git -C $repo branch --show-current
  $aheadBehind = git -C $repo rev-list --left-right --count "origin/$branch...HEAD"
  $status = git -C $repo status --short
  Write-Host "branch: $branch"
  Write-Host "ahead/behind: $aheadBehind"
  if ([string]::IsNullOrWhiteSpace(($status -join ""))) {
    Write-Host "status: clean"
  } else {
    Write-Host "status:"
    $status
  }
}

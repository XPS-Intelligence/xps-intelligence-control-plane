$ErrorActionPreference = "Stop"

$root = "C:\XPS"
$files = @(
  "C:\XPS\AGENTS.md",
  "C:\XPS\xps-intelligence-control-plane\docs\07-prompts\PLATFORM_MEMORY.md",
  "C:\XPS\xps-intelligence-control-plane\docs\01-architecture\MASTER_INDEX.md",
  "C:\XPS\xps-intelligence-control-plane\docs\02-roadmap\MASTER_REQUEST_COMPILATION.md",
  "C:\XPS\xps-intelligence-control-plane\docs\03-checklists\MASTER_BUILD_CHECKLIST.md",
  "C:\XPS\xps-intelligence-system\docs\ARCHITECTURE.md",
  "C:\XPS\xps-intelligence-system\docs\STACK_DECISION.md",
  "C:\XPS\xps-intel\docs\ARCHITECTURE.md",
  "C:\XPS\xps-distallation-system\docs\ARCHITECTURE.md"
)

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "XPS WORKSPACE REHYDRATE" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

foreach ($file in $files) {
  if (Test-Path $file) {
    Write-Host ""
    Write-Host "---- $file ----" -ForegroundColor Yellow
    Get-Content $file
  } else {
    Write-Host "Missing: $file" -ForegroundColor Red
  }
}

Write-Host ""
Write-Host "---- repo status ----" -ForegroundColor Yellow
Get-ChildItem $root -Directory | ForEach-Object {
  if (Test-Path (Join-Path $_.FullName ".git")) {
    $branch = git -C $_.FullName branch --show-current
    $status = git -C $_.FullName status --short
    $dirty = -not [string]::IsNullOrWhiteSpace(($status -join ""))
    Write-Host "$($_.Name) :: branch=$branch :: dirty=$dirty"
  }
}

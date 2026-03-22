param(
  [switch]$Apply
)

$ErrorActionPreference = "Stop"

$root = "C:\XPS"
$quarantineRoot = Join-Path $root "_quarantine"

$candidates = @(
  "xps-intelligence-system-v.5",
  "XPS_INTELLIGENCE_SYSTEM",
  "xps-intelligence-systems",
  "xps-ai-factory",
  "open-lovable"
)

New-Item -ItemType Directory -Force -Path $quarantineRoot | Out-Null

Write-Host "Quarantine plan:" -ForegroundColor Cyan
foreach ($name in $candidates) {
  $source = Join-Path $root $name
  $target = Join-Path $quarantineRoot $name

  if (-not (Test-Path $source)) {
    Write-Host "Missing: $source" -ForegroundColor Yellow
    continue
  }

  if ($Apply) {
    if (Test-Path $target) {
      Write-Host "Already quarantined: $target" -ForegroundColor Yellow
      continue
    }

    Move-Item -Path $source -Destination $target
    Write-Host "Moved: $source -> $target" -ForegroundColor Green
  } else {
    Write-Host "Would move: $source -> $target"
  }
}

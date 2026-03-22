$ErrorActionPreference = "Stop"

$repoRoot = "C:\XPS\xps-intelligence-control-plane"
$checklistPath = Join-Path $repoRoot "docs\03-checklists\INTERACTIVE_FOUNDATION_CHECKLIST.json"

if (-not (Test-Path $checklistPath)) {
  throw "Missing checklist file: $checklistPath"
}

$checklist = Get-Content $checklistPath -Raw | ConvertFrom-Json
$failures = @()

foreach ($section in $checklist.sections) {
  foreach ($item in $section.items) {
    if (-not (Test-Path $item.path)) {
      $failures += "Missing required foundation artifact: $($item.label) [$($item.path)]"
    }
  }
}

$requiredDocs = @(
  "docs\01-architecture\MASTER_INDEX.md",
  "docs\01-architecture\XPS_MASTER_BLUEPRINT.md",
  "docs\01-architecture\SYSTEM_CONTRACT.md",
  "docs\01-architecture\REPOSITORY_MAP.md",
  "docs\01-architecture\SYSTEM_MAP.md",
  "docs\01-architecture\FOUNDATION_BLUEPRINT.md",
  "docs\02-roadmap\MASTER_REQUEST_COMPILATION.md",
  "docs\02-roadmap\PARALLEL_EXECUTION_ROADMAP.md",
  "docs\03-checklists\MASTER_BUILD_CHECKLIST.md",
  "docs\03-checklists\REFLECTION_LOOP.md",
  "docs\07-prompts\PLATFORM_MEMORY.md"
)

foreach ($relativePath in $requiredDocs) {
  $fullPath = Join-Path $repoRoot $relativePath
  if (-not (Test-Path $fullPath)) {
    $failures += "Missing required control-plane doc: $relativePath"
    continue
  }

  $content = Get-Content $fullPath -Raw
  if ([string]::IsNullOrWhiteSpace($content)) {
    $failures += "Empty required control-plane doc: $relativePath"
  }
}

$memory = Get-Content "C:\XPS\AGENTS.md" -Raw
$platformMemory = Get-Content (Join-Path $repoRoot "docs\07-prompts\PLATFORM_MEMORY.md") -Raw

foreach ($repoName in @("xps-intelligence-system", "xps-intel", "xps-distallation-system")) {
  if ($memory -notmatch [regex]::Escape($repoName)) {
    $failures += "Workspace memory missing repo reference: $repoName"
  }
  if ($platformMemory -notmatch [regex]::Escape($repoName)) {
    $failures += "Platform memory missing repo reference: $repoName"
  }
}

if ($failures.Count -gt 0) {
  Write-Host "Foundation validation failed:" -ForegroundColor Red
  $failures | ForEach-Object { Write-Host " - $_" -ForegroundColor Red }
  exit 1
}

Write-Host "Foundation validation passed." -ForegroundColor Green

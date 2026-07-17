param(
    [Parameter(Mandatory = $true)]
    [string]$SourceRoot,

    [Parameter(Mandatory = $true)]
    [string]$OutputRoot,

    [Parameter(Mandatory = $true)]
    [string]$StrategyName,

    [Parameter(Mandatory = $false)]
    [string]$PackageName = 'ZeroTouchNinjaTrader',

    [Parameter(Mandatory = $false)]
    [string]$Version = '0.0.0'
)

$ErrorActionPreference = 'Stop'

$resolvedSourceRoot = (Resolve-Path $SourceRoot).Path
$resolvedOutputRoot = if (Test-Path $OutputRoot) { (Resolve-Path $OutputRoot).Path } else { $OutputRoot }

$timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$stagingRoot = Join-Path $resolvedOutputRoot 'staging'
$exportRoot = Join-Path $resolvedOutputRoot 'exports'
$packageRoot = Join-Path $resolvedOutputRoot 'packages'
$stagingPath = Join-Path $stagingRoot "$StrategyName-$timestamp"
$ntRoot = Join-Path $stagingPath 'NinjaTrader 8'
$customRoot = Join-Path $ntRoot 'bin\Custom'

New-Item -ItemType Directory -Force -Path $stagingPath,$exportRoot,$packageRoot,$customRoot | Out-Null

$sourceFiles = Get-ChildItem -Path $resolvedSourceRoot -Recurse -Include *.cs,*.xml,*.json -File
if (-not $sourceFiles -or $sourceFiles.Count -eq 0) {
    throw "No NinjaTrader source files found under $resolvedSourceRoot"
}

$strategyRoot = Join-Path $resolvedSourceRoot 'Strategy'
$indicatorRoot = Join-Path $resolvedSourceRoot 'Indicators'

if (-not (Test-Path $strategyRoot) -and -not (Test-Path $indicatorRoot)) {
    Write-Warning "Expected Strategy and/or Indicators folders under $resolvedSourceRoot. Packaging all discovered source files as a fallback."
}

foreach ($file in $sourceFiles) {
    $relativePath = $file.FullName.Substring($resolvedSourceRoot.Length).TrimStart('\\')
    $destination = Join-Path $customRoot $relativePath
    $destinationDir = Split-Path -Path $destination -Parent
    New-Item -ItemType Directory -Force -Path $destinationDir | Out-Null
    Copy-Item -Path $file.FullName -Destination $destination -Force
}

$addOnRoot = Join-Path $stagingPath 'AddOnContent'
New-Item -ItemType Directory -Force -Path $addOnRoot | Out-Null

$manifest = [ordered]@{
    packageName = $PackageName
    version = $Version
    strategyName = $StrategyName
    createdAtUtc = (Get-Date).ToUniversalTime().ToString('o')
    sourceRoot = $resolvedSourceRoot
    fileCount = $sourceFiles.Count
    packageFormat = 'ninjatrader-import-zip-scaffold'
}

$manifestPath = Join-Path $stagingPath 'package-manifest.json'
$manifest | ConvertTo-Json -Depth 4 | Out-File -FilePath $manifestPath -Encoding utf8

$readmePath = Join-Path $stagingPath 'IMPORT-INSTRUCTIONS.txt'
@(
    "Package: $PackageName"
    "Version: $Version"
    "Strategy: $StrategyName"
    ""
    "This scaffolded package is intended for supervised NinjaTrader 8 import workflows."
    "Validate contents and environment-specific behavior before importing into NinjaTrader."
) | Out-File -FilePath $readmePath -Encoding utf8

$zipName = "$PackageName-$StrategyName-$Version-$timestamp.zip"
$zipPath = Join-Path $exportRoot $zipName
Compress-Archive -Path (Join-Path $stagingPath '*') -DestinationPath $zipPath -Force

$latestPackagePath = Join-Path $packageRoot "$PackageName-$StrategyName-latest.zip"
Copy-Item -Path $zipPath -Destination $latestPackagePath -Force

"latest_package_path=$latestPackagePath" | Out-File -FilePath $env:GITHUB_OUTPUT -Append -Encoding utf8
"latest_package_file=$([System.IO.Path]::GetFileName($latestPackagePath))" | Out-File -FilePath $env:GITHUB_OUTPUT -Append -Encoding utf8
"versioned_package_path=$zipPath" | Out-File -FilePath $env:GITHUB_OUTPUT -Append -Encoding utf8
"versioned_package_file=$([System.IO.Path]::GetFileName($zipPath))" | Out-File -FilePath $env:GITHUB_OUTPUT -Append -Encoding utf8

Write-Host "Created NinjaTrader import package: $zipPath"
Write-Host "Latest package copy: $latestPackagePath"

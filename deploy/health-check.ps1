param(
    [Parameter(Mandatory = $true)]
    [string]$DropFolder,

    [Parameter(Mandatory = $true)]
    [string]$LogFolder,

    [Parameter(Mandatory = $false)]
    [switch]$RequireChecksum
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path $DropFolder)) {
    throw "Drop folder not found: $DropFolder"
}

if (-not (Test-Path $LogFolder)) {
    throw "Log folder not found: $LogFolder"
}

$latestPackage = Get-ChildItem -Path $DropFolder -Filter *.zip -File -ErrorAction SilentlyContinue |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 1

if (-not $latestPackage) {
    throw "No NinjaTrader package zip found in drop folder: $DropFolder"
}

$latestLog = Get-ChildItem -Path $LogFolder -Filter deploy-*.log -File -ErrorAction SilentlyContinue |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 1

if (-not $latestLog) {
    throw "No deployment log found in log folder: $LogFolder"
}

if ($RequireChecksum) {
    $expectedChecksumPath = "$($latestPackage.FullName).sha256"

    if (-not (Test-Path $expectedChecksumPath)) {
        throw "Checksum file required but not found for package: $expectedChecksumPath"
    }

    $checksumContent = (Get-Content -Path $expectedChecksumPath -Raw).Trim()
    $expectedHash = ($checksumContent -split '\s+')[0]
    $actualHash = (Get-FileHash -Path $latestPackage.FullName -Algorithm SHA256).Hash

    if ([string]::IsNullOrWhiteSpace($expectedHash)) {
        throw "Checksum file did not contain a valid hash: $expectedChecksumPath"
    }

    if ($expectedHash -ne $actualHash) {
        throw "Checksum validation failed for package: $($latestPackage.FullName)"
    }

    Write-Host "Latest checksum: $expectedChecksumPath"
}

Write-Host "Health check passed."
Write-Host "Latest package: $($latestPackage.FullName)"
Write-Host "Latest log: $($latestLog.FullName)"

param(
    [Parameter(Mandatory = $true)]
    [string]$ArtifactPath,

    [Parameter(Mandatory = $true)]
    [string]$DropFolder,

    [Parameter(Mandatory = $true)]
    [string]$LogFolder,

    [Parameter(Mandatory = $false)]
    [string]$ChecksumPath = ''
)

$ErrorActionPreference = 'Stop'

New-Item -ItemType Directory -Force -Path $DropFolder | Out-Null
New-Item -ItemType Directory -Force -Path $LogFolder | Out-Null

$timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$logPath = Join-Path $LogFolder "deploy-sim-$timestamp.log"
$artifactFileName = Split-Path -Path $ArtifactPath -Leaf
$destinationPath = Join-Path $DropFolder $artifactFileName
$checksumDestinationPath = ''

Copy-Item -Path $ArtifactPath -Destination $destinationPath -Force

$checksumValidated = $false

if ($ChecksumPath) {
    if (-not (Test-Path $ChecksumPath)) {
        throw "Checksum file not found: $ChecksumPath"
    }

    $checksumFileName = Split-Path -Path $ChecksumPath -Leaf
    $checksumDestinationPath = Join-Path $DropFolder $checksumFileName
    Copy-Item -Path $ChecksumPath -Destination $checksumDestinationPath -Force

    $checksumContent = (Get-Content -Path $checksumDestinationPath -Raw).Trim()
    $expectedHash = ($checksumContent -split '\s+')[0]
    $actualHash = (Get-FileHash -Path $destinationPath -Algorithm SHA256).Hash

    if ([string]::IsNullOrWhiteSpace($expectedHash)) {
        throw "Checksum file did not contain a valid hash: $checksumDestinationPath"
    }

    if ($expectedHash -ne $actualHash) {
        throw "Checksum validation failed for $destinationPath"
    }

    $checksumValidated = $true
}

$logLines = @(
    "[$(Get-Date -Format o)] Copied package to $destinationPath"
)

if ($checksumDestinationPath) {
    $logLines += "[$(Get-Date -Format o)] Copied checksum to $checksumDestinationPath"
}

if ($checksumValidated) {
    $logLines += "[$(Get-Date -Format o)] Package checksum validated successfully."
}

$logLines += "[$(Get-Date -Format o)] Package expected to be imported by NinjaTrader 8 from the monitored folder or manual supervised import process."
$logLines | Out-File -FilePath $logPath -Encoding utf8

Write-Host "Deployment complete. Package copied to: $destinationPath"
Write-Host "Log: $logPath"

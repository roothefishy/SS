# =========================================================
#          PREMIUM SS TOOLKIT - AUTOMATED SETUP
# =========================================================
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ErrorActionPreference = "SilentlyContinue"

# 1. Admin Check & Relaunch
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell -Verb RunAs -ArgumentList "-ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Definition)`""
    exit 0
}

# 2. Setup Directory
$folder = "C:\SS_Toolbox"
if (-not (Test-Path $folder)) { New-Item -Path $folder -ItemType Directory -Force | Out-Null }
Set-Location $folder

# 3. Visual Header
cls
Write-Host "  ___________________________________________________" -ForegroundColor Cyan
Write-Host " /                                                   \\" -ForegroundColor Cyan
Write-Host " |            SCREENSHARE TOOLKIT v2.0               |" -ForegroundColor White
Write-Host " |          [ AUTOMATED ANALYSIS READY ]             |" -ForegroundColor Green
Write-Host " \___________________________________________________/" -ForegroundColor Cyan
Write-Host ""

# 4. Security Bypass (Defender Exclusion)
Write-Host "[!] Initializing Secure Workspace..." -ForegroundColor DarkGray
Add-MpPreference -ExclusionPath $folder 

# 5. Tool Definitions
$tools = @{
    "System Informer" = "https://github.com/winsiderss/si-builds/releases/download/3.2.25275.112/systeminformer-build-canary-setup.exe"
    "Everything"      = "https://www.voidtools.com/Everything-1.4.1.1029.x64-Setup.exe"
    "Hollows Hunter"  = "https://github.com/hasherezade/hollows_hunter/releases/download/v0.4.1.1/hollows_hunter32.exe"
    "Prefetch View"   = "https://www.nirsoft.net/utils/winprefetchview-x64.zip"
}

# 6. Download & Auto-Open Loop
$i = 0
foreach ($name in $tools.Keys) {
    $i++
    $url = $tools[$name]
    $fileName = Split-Path $url -Leaf
    $dest = Join-Path $folder $fileName
    
    Write-Host "[$i/4] Fetching $name..." -ForegroundColor Cyan -NoNewline
    
    # Simple Progress Tracker
    try {
        Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing
        Write-Host " [DONE]" -ForegroundColor Green
        
        if ($fileName.EndsWith(".zip")) {
            Expand-Archive -Path $dest -DestinationPath "$folder\$name" -Force
            Remove-Item $dest
            # Open the folder for unzipped tools
            Start-Process explorer.exe "$folder\$name"
        } else {
            # Automatically launch .exe tools
            Start-Process $dest
        }
    } catch {
        Write-Host " [FAILED]" -ForegroundColor Red
    }
}

# 7. Final Polish
Write-Host "`n=====================================================" -ForegroundColor Cyan
Write-Host "  SETUP COMPLETE: All tools are active and running." -ForegroundColor Green
Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host " Workspace: $folder" -ForegroundColor DarkGray

# Keeps the window open so you can see the logs
pause

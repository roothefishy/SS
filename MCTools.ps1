# =========================================================
#          ELITE SCREENSHEARE TOOLKIT - V4.0
# =========================================================

# 1. WINDOW STYLING
$Host.UI.RawUI.WindowTitle = "PREMIUM SS TOOLKIT - SESSION ACTIVE"
$H = Get-Host
$W = $H.UI.RawUI
$buffer = $W.BufferSize
$buffer.Width = 120
$W.BufferSize = $buffer
$size = $W.WindowSize
$size.Width = 120
$size.Height = 35
$W.WindowSize = $size

# 2. ELEVATION CHECK
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell -Verb RunAs -ArgumentList "-ExecutionPolicy Bypass -File `"$($MyInvocation.MyCommand.Definition)`""
    exit 0
}

# 3. ENVIRONMENT SETUP
$folder = "C:\SS_Master"
if (-not (Test-Path $folder)) { New-Item -Path $folder -ItemType Directory -Force | Out-Null }
Set-Location $folder
Add-MpPreference -ExclusionPath $folder -ErrorAction SilentlyContinue

# 4. UI HEADER
cls
Write-Host "  __________________________________________________________________________________________________" -ForegroundColor Cyan
Write-Host " |                                                                                                  |" -ForegroundColor Cyan
Write-Host " |   ██████╗  ██████╗██████╗ ███████╗███████╗███╗   ██╗███████╗██╗  ██╗ █████╗ ██████╗ ███████╗     |" -ForegroundColor White
Write-Host " |   ██╔════╝ ██╔════╝██╔══██╗██╔════╝██╔════╝████╗  ██║██╔════╝██║  ██║██╔══██╗██╔══██╗██╔════╝     |" -ForegroundColor White
Write-Host " |   ███████╗ ██║     ██████╔╝█████╗  █████╗  ██╔██╗ ██║███████╗███████║███████║██████╔╝█████╗       |" -ForegroundColor White
Write-Host " |   ╚════██║ ██║     ██╔══██╗██╔══╝  ██╔══╝  ██║╚██╗██║╚════██║██╔══██║██╔══██║██╔══██╗██╔══╝       |" -ForegroundColor White
Write-Host " |   ███████║ ╚██████╗██║  ██║███████╗███████╗██║ ╚████║███████║██║  ██║██║  ██║██║  ██║███████╗     |" -ForegroundColor White
Write-Host " |   ╚══════╝  ╚═════╝╚═╝  ╚═╝╚══════╝╚══════╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝     |" -ForegroundColor White
Write-Host " |__________________________________________________________________________________________________|" -ForegroundColor Cyan
Write-Host "                        AUTOMATED ANALYSIS ENGINE | CLEANUP ENABLED                                   " -ForegroundColor DarkGray
Write-Host ""

# 5. CORE TOOLSET
$tools = @{
    "System Informer" = "https://github.com/winsiderss/si-builds/releases/download/3.2.25275.112/systeminformer-build-canary-setup.exe"
    "Everything"      = "https://www.voidtools.com/Everything-1.4.1.1029.x64-Setup.exe"
    "Hollows Hunter"  = "https://github.com/hasherezade/hollows_hunter/releases/download/v0.4.1.1/hollows_hunter32.exe"
    "Prefetch View"   = "https://www.nirsoft.net/utils/winprefetchview-x64.zip"
}

# 6. DOWNLOAD & LAUNCH ENGINE
$count = 0
foreach ($name in $tools.Keys) {
    $count++
    $url = $tools[$name]
    $file = Split-Path $url -Leaf
    $path = Join-Path $folder $file
    
    Write-Host "  [$count/4] Initializing $name..." -ForegroundColor Cyan -NoNewline
    
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest -Uri $url -OutFile $path -UseBasicParsing
        
        if ($file.EndsWith(".zip")) {
            Expand-Archive -Path $path -DestinationPath "$folder\$name" -Force
            Remove-Item $path
            Start-Process explorer.exe "$folder\$name"
            Write-Host " [READY]" -ForegroundColor Green
        } else {
            Start-Process $path
            Write-Host " [ACTIVE]" -ForegroundColor Green
        }
    } catch {
        Write-Host " [FAILED]" -ForegroundColor Red
    }
}

Write-Host "`n  ================================================================================__________________" -ForegroundColor Cyan
Write-Host "  [!] ALL TOOLS LOADED. CONDUCT YOUR SCAN NOW." -ForegroundColor Yellow
Write-Host "  [X] PRESS 'X' TO DELETE ALL TOOLS AND REMOVE EXCLUSIONS." -ForegroundColor Red
Write-Host "  ================================================================================__________________" -ForegroundColor Cyan

# 7. CLEANUP LOGIC (The "Delete All" feature)
$key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
if ($key.Character -eq 'x' -or $key.Character -eq 'X') {
    Write-Host "`n  [*] INITIATING PURGE..." -ForegroundColor Red
    
    # Close running processes first so files can be deleted
    Stop-Process -Name "SystemInformer", "Everything", "hollows_hunter32" -ErrorAction SilentlyContinue
    
    # Remove Defender Exclusion
    Remove-MpPreference -ExclusionPath $folder -ErrorAction SilentlyContinue
    
    # Remove Files
    Remove-Item -Path $folder -Recurse -Force -ErrorAction SilentlyContinue
    
    Write-Host "  [✓] Workspace wiped. Defender exclusions removed." -ForegroundColor Green
    Start-Sleep -Seconds 2
    exit
}

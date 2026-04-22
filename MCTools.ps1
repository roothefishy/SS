# =========================================================
#          ELITE SCREENSHEARE TOOLKIT - V6.0
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
Write-Host "                    HARD-PURGE ENABLED | TASKS PARSER | NAYXZ-CORE                                   " -ForegroundColor DarkGray
Write-Host ""

# 5. CORE TOOLSET
$tools = @{
    "System Informer" = "https://github.com/winsiderss/si-builds/releases/download/3.2.25275.112/systeminformer-build-canary-setup.exe"
    "Everything"      = "https://www.voidtools.com/Everything-1.4.1.1029.x64-Setup.exe"
    "Hollows Hunter"  = "https://github.com/hasherezade/hollows_hunter/releases/download/v0.4.1.1/hollows_hunter32.exe"
    "Prefetch View"   = "https://www.nirsoft.net/utils/winprefetchview-x64.zip"
    "Tasks Parser"    = "https://github.com/zedoonvm1/TasksParser/releases/download/1.1/Tasks.Parser.exe"
}

# 6. DOWNLOAD & LAUNCH ENGINE
$count = 0
foreach ($name in $tools.Keys) {
    $count++
    $url = $tools[$name]
    $file = Split-Path $url -Leaf
    $path = Join-Path $folder $file
    
    Write-Host "  [$count/5] Initializing $name..." -ForegroundColor Cyan -NoNewline
    
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest -Uri $url -OutFile $path -UseBasicParsing
        
        if ($file.EndsWith(".zip")) {
            Expand-Archive -Path $path -DestinationPath "$folder\$name" -Force
            Remove-Item $path
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
Write-Host "  [!] STATUS: OPERATIONAL." -ForegroundColor Yellow
Write-Host "  [X] PRESS 'X' TO INITIATE HARD-PURGE (FORCE DELETE ALL)." -ForegroundColor Red
Write-Host "  ================================================================================__________________" -ForegroundColor Cyan

# 7. ENHANCED PURGE LOGIC
while($true) {
    if ($Host.UI.RawUI.KeyAvailable) {
        $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        if ($key.Character -eq 'x' -or $key.Character -eq 'X') {
            Write-Host "`n  [*] KILLING PROCESSES..." -ForegroundColor Red
            
            # Force Kill based on common names and descriptions
            $killList = @("SystemInformer", "Everything", "hollows_hunter32", "Tasks.Parser", "winprefetchview")
            foreach ($p in $killList) { 
                Stop-Process -Name $p -Force -ErrorAction SilentlyContinue 
            }
            
            Write-Host "  [*] RELEASING FILE LOCKS..." -ForegroundColor Yellow
            Start-Sleep -Seconds 2 # Critical delay for Windows to let go of the files
            
            Write-Host "  [*] WIPING WORKSPACE..." -ForegroundColor Red
            Remove-MpPreference -ExclusionPath $folder -ErrorAction SilentlyContinue
            
            # Use cmd /c rd for a deeper, more aggressive delete than PowerShell's Remove-Item
            cmd /c "rd /s /q $folder" 2>$null
            
            if (Test-Path $folder) {
                Write-Host "  [!] Folder stubborn. Attempting final forced wipe..." -ForegroundColor Yellow
                Remove-Item -Path $folder -Recurse -Force -ErrorAction SilentlyContinue
            }
            
            Write-Host "  [✓] PURGE COMPLETE. SYSTEM CLEANED." -ForegroundColor Green
            Start-Sleep -Seconds 2
            exit
        }
    }
    Start-Sleep -Milliseconds 100
}

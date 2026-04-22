# =========================================================
#          ELITE SCREENSHEARE TOOLKIT - V7.0
# =========================================================

# 1. WINDOW STYLING
$Host.UI.RawUI.WindowTitle = "PREMIUM SS TOOLKIT - INTERACTIVE SETUP"
$H = Get-Host
$W = $H.UI.RawUI
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
Write-Host "                     NAYXZ SCREENSHARES | HARD-PURGE ENABLED | V7.0                                  " -ForegroundColor DarkGray
Write-Host ""

# 5. TOOL DEFINITIONS
$tools = @(
    @{ Name = "System Informer"; Url = "https://github.com/winsiderss/si-builds/releases/download/3.2.25275.112/systeminformer-build-canary-setup.exe" },
    @{ Name = "Everything";      Url = "https://www.voidtools.com/Everything-1.4.1.1029.x64-Setup.exe" },
    @{ Name = "Hollows Hunter";  Url = "https://github.com/hasherezade/hollows_hunter/releases/download/v0.4.1.1/hollows_hunter32.exe" },
    @{ Name = "Prefetch View";   Url = "https://www.nirsoft.net/utils/winprefetchview-x64.zip" },
    @{ Name = "Tasks Parser";    Url = "https://github.com/zedoonvm1/TasksParser/releases/download/1.1/Tasks.Parser.exe" }
)

# 6. INTERACTIVE DOWNLOAD LOGIC
Write-Host "  [?] SELECT TOOLS TO INSTALL (Y/N):`n" -ForegroundColor Yellow

foreach ($tool in $tools) {
    $choice = Read-Host "      > Install $($tool.Name)?"
    if ($choice -eq 'y' -or $choice -eq 'Y') {
        $file = Split-Path $tool.Url -Leaf
        $path = Join-Path $folder $file
        Write-Host "      [+] Downloading..." -ForegroundColor Cyan -NoNewline
        
        try {
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            Invoke-WebRequest -Uri $tool.Url -OutFile $path -UseBasicParsing
            
            if ($file.EndsWith(".zip")) {
                Expand-Archive -Path $path -DestinationPath "$folder\$($tool.Name)" -Force
                Remove-Item $path
                Write-Host " [READY]" -ForegroundColor Green
            } else {
                Start-Process $path
                Write-Host " [ACTIVE]" -ForegroundColor Green
            }
        } catch {
            Write-Host " [FAILED]" -ForegroundColor Red
        }
    } else {
        Write-Host "      [-] Skipping $($tool.Name)" -ForegroundColor DarkGray
    }
}

Write-Host "`n  ================================================================================__________________" -ForegroundColor Cyan
Write-Host "  [!] STATUS: SETUP COMPLETE." -ForegroundColor Yellow
Write-Host "  [X] PRESS 'X' TO INITIATE HARD-PURGE (FORCE DELETE ALL)." -ForegroundColor Red
Write-Host "  ================================================================================__________________" -ForegroundColor Cyan

# 7. ENHANCED PURGE LOGIC
while($true) {
    if ($Host.UI.RawUI.KeyAvailable) {
        $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        if ($key.Character -eq 'x' -or $key.Character -eq 'X') {
            Write-Host "`n  [*] KILLING PROCESSES..." -ForegroundColor Red
            $killList = @("SystemInformer", "Everything", "hollows_hunter32", "Tasks.Parser", "winprefetchview")
            foreach ($p in $killList) { Stop-Process -Name $p -Force -ErrorAction SilentlyContinue }
            
            Write-Host "  [*] RELEASING FILE LOCKS..." -ForegroundColor Yellow
            Start-Sleep -Seconds 2
            
            Write-Host "  [*] WIPING WORKSPACE..." -ForegroundColor Red
            Remove-MpPreference -ExclusionPath $folder -ErrorAction SilentlyContinue
            cmd /c "rd /s /q $folder" 2>$null
            
            Write-Host "  [✓] PURGE COMPLETE. SYSTEM CLEANED." -ForegroundColor Green
            Start-Sleep -Seconds 2
            exit
        }
    }
    Start-Sleep -Milliseconds 100
}

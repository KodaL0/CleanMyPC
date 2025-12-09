# ================================
# CleanPC_CLI.ps1
# Command Line Interface for CleanPC
# ================================

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("QuickClean", "DeepClean", "Repair", "Optimize", "Complete", "Menu")]
    [string]$Command = "Menu"
)

# Import core module
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$scriptPath\CleanPC_Core.ps1"
. "$scriptPath\CleanPC_Config.ps1"

# Check for administrator privileges
function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not (Test-Admin)) {
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "ADMINISTRATOR RIGHTS REQUIRED" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please run this script as Administrator" -ForegroundColor Yellow
    Write-Host "Right-click PowerShell and select 'Run as Administrator'" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Press Enter to exit"
    exit
}

function Show-Banner {
    Clear-Host
    Write-Host ""
    Write-Host "  ╔═══════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "  ║                                           ║" -ForegroundColor Cyan
    Write-Host "  ║            CLEANPC PRO v1.0               ║" -ForegroundColor Cyan
    Write-Host "  ║    Professional Windows Maintenance       ║" -ForegroundColor Cyan
    Write-Host "  ║                                           ║" -ForegroundColor Cyan
    Write-Host "  ╚═══════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
}

function Show-Menu {
    Show-Banner

    Write-Host "  MAINTENANCE OPTIONS:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  1. Quick Clean" -ForegroundColor Green -NoNewline
    Write-Host "          (5-10 min)  - Temp files & cache" -ForegroundColor Gray
    Write-Host "  2. Deep Clean" -ForegroundColor Green -NoNewline
    Write-Host "           (15-30 min) - Comprehensive cleanup" -ForegroundColor Gray
    Write-Host "  3. System Repair" -ForegroundColor Green -NoNewline
    Write-Host "        (20-40 min) - Fix system issues" -ForegroundColor Gray
    Write-Host "  4. Full Optimization" -ForegroundColor Green -NoNewline
    Write-Host "   (30-60 min) - Boost performance" -ForegroundColor Gray
    Write-Host "  5. Complete Maintenance" -ForegroundColor Green -NoNewline
    Write-Host " (60+ min)   - Everything" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  TOOLS:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  6. Update All Apps" -ForegroundColor Cyan
    Write-Host "  7. Remove Bloatware" -ForegroundColor Cyan
    Write-Host "  8. System Information" -ForegroundColor Cyan
    Write-Host "  9. Disk Space Analysis" -ForegroundColor Cyan
    Write-Host "  10. Create Restore Point" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  ADVANCED:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  11. Custom Operations" -ForegroundColor Magenta
    Write-Host "  12. Schedule Automation" -ForegroundColor Magenta
    Write-Host "  13. Configuration" -ForegroundColor Magenta
    Write-Host ""
    Write-Host "  0. Exit" -ForegroundColor Red
    Write-Host ""
    Write-Host "  ═══════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host ""
}

function Show-CustomMenu {
    Show-Banner
    Write-Host "  CUSTOM OPERATIONS:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  CLEANUP:" -ForegroundColor Cyan
    Write-Host "  1. Clean Temp Files" -ForegroundColor White
    Write-Host "  2. Clean Browsers" -ForegroundColor White
    Write-Host "  3. Clean System Logs" -ForegroundColor White
    Write-Host "  4. Clean Error Reports" -ForegroundColor White
    Write-Host "  5. Clear Activity History" -ForegroundColor White
    Write-Host ""
    Write-Host "  OPTIMIZATION:" -ForegroundColor Cyan
    Write-Host "  6. Optimize Startup" -ForegroundColor White
    Write-Host "  7. Optimize Services" -ForegroundColor White
    Write-Host "  8. Optimize Drives" -ForegroundColor White
    Write-Host "  9. Disable Telemetry" -ForegroundColor White
    Write-Host ""
    Write-Host "  REPAIR:" -ForegroundColor Cyan
    Write-Host "  10. Run SFC" -ForegroundColor White
    Write-Host "  11. Run DISM" -ForegroundColor White
    Write-Host "  12. Reset Network" -ForegroundColor White
    Write-Host ""
    Write-Host "  0. Back to Main Menu" -ForegroundColor Red
    Write-Host ""
}

function Invoke-MenuItem {
    param([string]$choice)

    switch ($choice) {
        "1" {
            Show-Banner
            Write-Host "Starting Quick Clean..." -ForegroundColor Green
            Write-Host ""
            Run-QuickClean
            Pause
        }
        "2" {
            Show-Banner
            Write-Host "Starting Deep Clean..." -ForegroundColor Green
            Write-Host ""
            Run-DeepClean
            Pause
        }
        "3" {
            Show-Banner
            Write-Host "Starting System Repair..." -ForegroundColor Green
            Write-Host ""
            Run-SystemRepair
            Pause
        }
        "4" {
            Show-Banner
            Write-Host "Starting Full Optimization..." -ForegroundColor Green
            Write-Host ""
            Run-FullOptimization
            Pause
        }
        "5" {
            Show-Banner
            $confirm = Read-Host "Complete Maintenance takes 60+ minutes. Continue? (Y/N)"
            if ($confirm -eq "Y" -or $confirm -eq "y") {
                Run-CompleteMaintenace
            }
            Pause
        }
        "6" {
            Show-Banner
            Write-Host "Updating all applications..." -ForegroundColor Green
            Write-Host ""
            Update-Apps
            Pause
        }
        "7" {
            Show-Banner
            Write-Host "Removing bloatware..." -ForegroundColor Green
            Write-Host ""
            Remove-Bloatware
            Pause
        }
        "8" {
            Show-Banner
            Get-SystemInfo
            Pause
        }
        "9" {
            Show-Banner
            Analyze-DiskSpace
            Pause
        }
        "10" {
            Show-Banner
            $desc = Read-Host "Enter restore point description (or press Enter for default)"
            if ([string]::IsNullOrWhiteSpace($desc)) {
                $desc = "CleanPC Manual Restore Point"
            }
            Create-RestorePoint -description $desc
            Pause
        }
        "11" {
            Invoke-CustomMenu
        }
        "12" {
            Show-Banner
            . "$scriptPath\CleanPC_Scheduler.ps1"
            Install-CleanPCAutomation
            Pause
        }
        "13" {
            Show-Banner
            Write-Host "Configuration options:" -ForegroundColor Yellow
            Write-Host ""
            Write-Host "1. Save current configuration" -ForegroundColor White
            Write-Host "2. Load configuration" -ForegroundColor White
            Write-Host "3. Reset to defaults" -ForegroundColor White
            Write-Host ""
            $configChoice = Read-Host "Select option (1-3)"

            switch ($configChoice) {
                "1" { Save-CleanPCConfig }
                "2" { Load-CleanPCConfig }
                "3" {
                    . "$scriptPath\CleanPC_Config.ps1"
                    Write-Host "Configuration reset to defaults" -ForegroundColor Green
                }
            }
            Pause
        }
        "0" {
            Show-Banner
            Write-Host "Thank you for using CleanPC!" -ForegroundColor Cyan
            Write-Host ""
            exit
        }
        default {
            Write-Host "Invalid selection. Please try again." -ForegroundColor Red
            Start-Sleep -Seconds 1
        }
    }
}

function Invoke-CustomMenu {
    do {
        Show-CustomMenu
        $choice = Read-Host "Select operation"

        switch ($choice) {
            "1" { Clean-Temp; Pause }
            "2" { Clean-Browsers; Pause }
            "3" { Clean-Logs; Pause }
            "4" { Clean-ErrorReports; Pause }
            "5" { Clear-ActivityHistory; Pause }
            "6" { Optimize-Startup; Pause }
            "7" { Optimize-Services; Pause }
            "8" { Optimize-Drives; Pause }
            "9" { Disable-Telemetry; Pause }
            "10" { Run-SFC; Pause }
            "11" { Run-DISM; Pause }
            "12" { Reset-NetworkStack; Pause }
            "0" { return }
            default {
                Write-Host "Invalid selection." -ForegroundColor Red
                Start-Sleep -Seconds 1
            }
        }
    } while ($true)
}

function Pause {
    Write-Host ""
    Write-Host "Press any key to continue..." -ForegroundColor Yellow
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

# Main execution
if ($Command -eq "Menu") {
    do {
        Show-Menu
        $choice = Read-Host "Select option"
        Invoke-MenuItem $choice
    } while ($true)
} else {
    Show-Banner
    switch ($Command) {
        "QuickClean" { Run-QuickClean }
        "DeepClean" { Run-DeepClean }
        "Repair" { Run-SystemRepair }
        "Optimize" { Run-FullOptimization }
        "Complete" { Run-CompleteMaintenace }
    }
    Write-Host ""
    Write-Host "Operation completed. Press any key to exit..." -ForegroundColor Yellow
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

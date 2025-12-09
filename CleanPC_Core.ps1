# ================================
# CleanPC_Core.ps1
# Professional Windows System Cleanup & Optimization
# ================================

$Global:CleanedSpace = 0
$Global:ErrorCount = 0

function Write-Log {
    param([string]$msg, [string]$type = "INFO")
    $timestamp = Get-Date -Format "HH:mm:ss"
    $coloredMsg = "[$timestamp] [$type] $msg"

    if ($Global:LogBox) {
        $Global:LogBox.AppendText("$coloredMsg`r`n")
        $Global:LogBox.ScrollToCaret()
    } else {
        Write-Host $coloredMsg
    }
}

function Get-FolderSize {
    param([string]$path)
    try {
        if (Test-Path $path) {
            $size = (Get-ChildItem $path -Recurse -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
            return [math]::Round($size / 1MB, 2)
        }
    } catch {}
    return 0
}

function Invoke-CommandSafe {
    param($cmd, [switch]$Silent)
    try {
        if (-not $Silent) { Write-Log "[RUNNING] $cmd" "EXEC" }
        Invoke-Expression $cmd
        if (-not $Silent) { Write-Log "[OK] Completed successfully" "SUCCESS" }
        return $true
    }
    catch {
        Write-Log "[ERROR] $($_.Exception.Message)" "ERROR"
        $Global:ErrorCount++
        return $false
    }
}

function Remove-ItemSafe {
    param([string]$path, [string]$description = "")
    try {
        if (Test-Path $path) {
            $sizeBefore = Get-FolderSize $path
            Remove-Item -Path $path -Recurse -Force -ErrorAction Stop
            $Global:CleanedSpace += $sizeBefore
            Write-Log "Cleaned: $description ($sizeBefore MB freed)" "SUCCESS"
            return $true
        }
    }
    catch {
        Write-Log "Failed to clean: $description - $($_.Exception.Message)" "WARNING"
        return $false
    }
}

# ==========================================
# 🧹 ADVANCED CLEANUP FUNCTIONS
# ==========================================

function Clean-Temp {
    Write-Log "=== TEMP FILES CLEANUP ===" "HEADER"
    $locations = @(
        @{Path="$env:TEMP\*"; Name="User Temp"},
        @{Path="C:\Windows\Temp\*"; Name="Windows Temp"},
        @{Path="C:\Windows\Prefetch\*"; Name="Prefetch"},
        @{Path="C:\Windows\SoftwareDistribution\Download\*"; Name="Windows Update Cache"},
        @{Path="$env:LOCALAPPDATA\Temp\*"; Name="Local App Temp"},
        @{Path="C:\`$Recycle.Bin\*"; Name="Recycle Bin"}
    )

    foreach ($loc in $locations) {
        Remove-ItemSafe -path $loc.Path -description $loc.Name
    }
    Write-Log "Temp cleanup completed - Total freed: $Global:CleanedSpace MB" "SUCCESS"
}

function Clean-Browsers {
    Write-Log "=== BROWSER CLEANUP ===" "HEADER"

    $browsers = @(
        @{Path="$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache\*"; Name="Chrome Cache"},
        @{Path="$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Code Cache\*"; Name="Chrome Code Cache"},
        @{Path="$env:LOCALAPPDATA\Google\Chrome\User Data\ShaderCache\*"; Name="Chrome Shader Cache"},
        @{Path="$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cache\*"; Name="Edge Cache"},
        @{Path="$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Code Cache\*"; Name="Edge Code Cache"},
        @{Path="$env:APPDATA\Mozilla\Firefox\Profiles\*\cache2\*"; Name="Firefox Cache"},
        @{Path="$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\Default\Cache\*"; Name="Brave Cache"},
        @{Path="$env:APPDATA\Opera Software\Opera Stable\Cache\*"; Name="Opera Cache"}
    )

    foreach ($browser in $browsers) {
        Remove-ItemSafe -path $browser.Path -description $browser.Name
    }
}

function Clean-WindowsApps {
    Write-Log "=== WINDOWS APPS CLEANUP ===" "HEADER"

    $appPaths = @(
        @{Path="$env:LOCALAPPDATA\Packages\*\AC\Temp\*"; Name="UWP App Temp"},
        @{Path="$env:LOCALAPPDATA\Packages\*\LocalCache\*"; Name="UWP Local Cache"},
        @{Path="$env:LOCALAPPDATA\Microsoft\Windows\Explorer\thumbcache_*.db"; Name="Thumbnail Cache"},
        @{Path="$env:LOCALAPPDATA\Microsoft\Windows\Explorer\IconCache.db"; Name="Icon Cache"}
    )

    foreach ($app in $appPaths) {
        Remove-ItemSafe -path $app.Path -description $app.Name
    }
}

function Clean-Logs {
    Write-Log "=== LOG FILES CLEANUP ===" "HEADER"

    $logPaths = @(
        @{Path="C:\Windows\Logs\CBS\*.log"; Name="CBS Logs"},
        @{Path="C:\Windows\Logs\DISM\*.log"; Name="DISM Logs"},
        @{Path="C:\Windows\Panther\*.log"; Name="Setup Logs"},
        @{Path="C:\Windows\INF\*.log"; Name="INF Logs"}
    )

    foreach ($log in $logPaths) {
        Remove-ItemSafe -path $log.Path -description $log.Name
    }
}

function Clean-ErrorReports {
    Write-Log "=== ERROR REPORTS CLEANUP ===" "HEADER"

    Remove-ItemSafe -path "C:\ProgramData\Microsoft\Windows\WER\ReportQueue\*" -description "Windows Error Reports"
    Remove-ItemSafe -path "C:\ProgramData\Microsoft\Windows\WER\ReportArchive\*" -description "Error Report Archive"
    Remove-ItemSafe -path "$env:LOCALAPPDATA\CrashDumps\*" -description "Crash Dumps"
}

function Clean-Downloads {
    Write-Log "=== DOWNLOADS CLEANUP ===" "HEADER"

    $downloadPath = "$env:USERPROFILE\Downloads"
    $oldDate = (Get-Date).AddDays(-90)

    try {
        $oldFiles = Get-ChildItem $downloadPath -Recurse -ErrorAction SilentlyContinue |
                    Where-Object { $_.LastWriteTime -lt $oldDate }

        foreach ($file in $oldFiles) {
            Remove-ItemSafe -path $file.FullName -description "Old download: $($file.Name)"
        }
    } catch {
        Write-Log "Unable to clean old downloads" "WARNING"
    }
}

function Clean-SystemRestore {
    Write-Log "=== SYSTEM RESTORE CLEANUP ===" "HEADER"

    try {
        $result = vssadmin delete shadows /for=c: /oldest /quiet
        Write-Log "Removed oldest system restore point" "SUCCESS"
    } catch {
        Write-Log "Unable to clean system restore points" "WARNING"
    }
}

# ==========================================
# 🔧 SYSTEM REPAIR FUNCTIONS
# ==========================================

function Run-SFC {
    Write-Log "=== SYSTEM FILE CHECKER ===" "HEADER"
    Write-Log "Running System File Checker (this may take 10-30 minutes)..." "INFO"

    $result = sfc /scannow

    if ($result -match "did not find any integrity violations") {
        Write-Log "System files are intact" "SUCCESS"
    } else {
        Write-Log "System files checked and repaired" "SUCCESS"
    }
}

function Run-DISM {
    Write-Log "=== DISM REPAIR ===" "HEADER"
    Write-Log "Running DISM CheckHealth..." "INFO"
    DISM /Online /Cleanup-Image /CheckHealth

    Write-Log "Running DISM ScanHealth..." "INFO"
    DISM /Online /Cleanup-Image /ScanHealth

    Write-Log "Running DISM RestoreHealth..." "INFO"
    DISM /Online /Cleanup-Image /RestoreHealth

    Write-Log "DISM repair completed" "SUCCESS"
}

function Repair-WindowsImage {
    Write-Log "=== WINDOWS IMAGE REPAIR ===" "HEADER"

    Run-DISM
    Run-SFC
}

function Reset-NetworkStack {
    Write-Log "=== NETWORK STACK RESET ===" "HEADER"

    $commands = @(
        "netsh winsock reset",
        "netsh int ip reset",
        "ipconfig /release",
        "ipconfig /renew",
        "ipconfig /flushdns"
    )

    foreach ($cmd in $commands) {
        Invoke-CommandSafe $cmd
    }

    Write-Log "Network stack reset complete. Restart required." "SUCCESS"
}

function Repair-WindowsStore {
    Write-Log "=== WINDOWS STORE REPAIR ===" "HEADER"

    Invoke-CommandSafe "wsreset.exe" -Silent
    Write-Log "Windows Store cache cleared" "SUCCESS"
}

# ==========================================
# ⚙️ APPS MANAGEMENT
# ==========================================

function Update-Apps {
    Write-Log "=== WINGET UPDATE ===" "HEADER"

    try {
        winget upgrade --all --silent --accept-source-agreements --accept-package-agreements
        Write-Log "All apps updated successfully" "SUCCESS"
    } catch {
        Write-Log "Error updating apps" "ERROR"
    }
}

function Get-InstalledApps {
    Write-Log "=== INSTALLED APPLICATIONS ===" "HEADER"

    try {
        $apps = winget list | Out-String
        Write-Log $apps "INFO"
        return $apps
    } catch {
        Write-Log "Unable to retrieve app list" "ERROR"
    }
}

function Uninstall-Apps {
    param([string[]]$appIds)

    Write-Log "=== APP UNINSTALLATION ===" "HEADER"

    if (-not $appIds -or $appIds.Count -eq 0) {
        $ids = Read-Host "Enter Winget IDs to uninstall (comma separated)"
        if ($ids) {
            $appIds = $ids -split "," | ForEach-Object { $_.Trim() }
        }
    }

    foreach ($id in $appIds) {
        if ($id) {
            Write-Log "Uninstalling: $id" "INFO"
            Invoke-CommandSafe "winget uninstall --id '$id' --silent --accept-source-agreements"
        }
    }
}

function Remove-Bloatware {
    Write-Log "=== BLOATWARE REMOVAL ===" "HEADER"

    $bloatware = @(
        "Microsoft.BingNews",
        "Microsoft.BingWeather",
        "Microsoft.GetHelp",
        "Microsoft.Getstarted",
        "Microsoft.Messaging",
        "Microsoft.Microsoft3DViewer",
        "Microsoft.MicrosoftSolitaireCollection",
        "Microsoft.MixedReality.Portal",
        "Microsoft.OneConnect",
        "Microsoft.People",
        "Microsoft.Print3D",
        "Microsoft.SkypeApp",
        "Microsoft.WindowsAlarms",
        "Microsoft.WindowsMaps",
        "Microsoft.Xbox.TCUI",
        "Microsoft.XboxApp",
        "Microsoft.XboxGameOverlay",
        "Microsoft.XboxGamingOverlay",
        "Microsoft.XboxIdentityProvider",
        "Microsoft.XboxSpeechToTextOverlay",
        "Microsoft.ZuneMusic",
        "Microsoft.ZuneVideo",
        "king.com.CandyCrushSaga",
        "king.com.CandyCrushSodaSaga"
    )

    foreach ($app in $bloatware) {
        try {
            Get-AppxPackage $app -ErrorAction SilentlyContinue | Remove-AppxPackage -ErrorAction Stop
            Write-Log "Removed: $app" "SUCCESS"
        } catch {
            Write-Log "Could not remove: $app" "WARNING"
        }
    }
}

# ==========================================
# 🚀 PERFORMANCE OPTIMIZATION
# ==========================================

function Optimize-Startup {
    Write-Log "=== STARTUP OPTIMIZATION ===" "HEADER"

    try {
        $items = Get-CimInstance Win32_StartupCommand
        $disabled = 0

        foreach ($item in $items) {
            if ($item.Name -notmatch "Windows|NVIDIA|AMD|Intel|Security|Defender|Audio|Realtek") {
                Write-Log "Disabling startup: $($item.Name)" "INFO"
                Invoke-CommandSafe "reg delete 'HKCU\Software\Microsoft\Windows\CurrentVersion\Run' /v '$($item.Name)' /f" -Silent
                $disabled++
            }
        }

        Write-Log "Disabled $disabled startup items" "SUCCESS"
    } catch {
        Write-Log "Error optimizing startup" "ERROR"
    }
}

function Optimize-Services {
    Write-Log "=== SERVICE OPTIMIZATION ===" "HEADER"

    $servicesToDisable = @(
        @{Name="DiagTrack"; Display="Connected User Experiences and Telemetry"},
        @{Name="dmwappushservice"; Display="WAP Push Message Routing"},
        @{Name="SysMain"; Display="Superfetch (if SSD)"},
        @{Name="WSearch"; Display="Windows Search"}
    )

    foreach ($svc in $servicesToDisable) {
        try {
            $service = Get-Service -Name $svc.Name -ErrorAction SilentlyContinue
            if ($service -and $service.StartType -ne "Disabled") {
                Stop-Service -Name $svc.Name -Force -ErrorAction Stop
                Set-Service -Name $svc.Name -StartupType Disabled -ErrorAction Stop
                Write-Log "Disabled: $($svc.Display)" "SUCCESS"
            }
        } catch {
            Write-Log "Could not disable: $($svc.Display)" "WARNING"
        }
    }
}

function Optimize-VisualEffects {
    Write-Log "=== VISUAL EFFECTS OPTIMIZATION ===" "HEADER"

    $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"

    try {
        Set-ItemProperty -Path $regPath -Name "VisualFXSetting" -Value 2 -ErrorAction Stop
        Write-Log "Visual effects set to 'Best Performance'" "SUCCESS"
    } catch {
        Write-Log "Unable to modify visual effects" "WARNING"
    }
}

function Optimize-PowerPlan {
    Write-Log "=== POWER PLAN OPTIMIZATION ===" "HEADER"

    try {
        powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
        Write-Log "Power plan set to 'High Performance'" "SUCCESS"
    } catch {
        Write-Log "Unable to change power plan" "WARNING"
    }
}

function Optimize-PageFile {
    Write-Log "=== PAGE FILE OPTIMIZATION ===" "HEADER"

    try {
        $computerSystem = Get-CimInstance Win32_ComputerSystem
        $ram = [math]::Round($computerSystem.TotalPhysicalMemory / 1GB)
        $pageFileSize = [math]::Round($ram * 1.5 * 1024)

        $regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management"
        Set-ItemProperty -Path $regPath -Name "PagingFiles" -Value "C:\pagefile.sys $pageFileSize $pageFileSize"

        Write-Log "Page file optimized for ${ram}GB RAM" "SUCCESS"
    } catch {
        Write-Log "Unable to optimize page file" "WARNING"
    }
}

# ==========================================
# 🔒 PRIVACY & SECURITY
# ==========================================

function Disable-Telemetry {
    Write-Log "=== TELEMETRY DISABLING ===" "HEADER"

    $regKeys = @(
        @{Path="HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"; Name="AllowTelemetry"; Value=0},
        @{Path="HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"; Name="AllowTelemetry"; Value=0},
        @{Path="HKCU:\Software\Microsoft\Windows\CurrentVersion\Privacy"; Name="TailoredExperiencesWithDiagnosticDataEnabled"; Value=0}
    )

    foreach ($key in $regKeys) {
        try {
            if (-not (Test-Path $key.Path)) {
                New-Item -Path $key.Path -Force | Out-Null
            }
            Set-ItemProperty -Path $key.Path -Name $key.Name -Value $key.Value -ErrorAction Stop
            Write-Log "Disabled: $($key.Path)\$($key.Name)" "SUCCESS"
        } catch {
            Write-Log "Could not modify: $($key.Path)" "WARNING"
        }
    }
}

function Clear-ActivityHistory {
    Write-Log "=== ACTIVITY HISTORY CLEANUP ===" "HEADER"

    Remove-ItemSafe -path "$env:LOCALAPPDATA\ConnectedDevicesPlatform\*" -description "Activity History"
}

function Clear-RecentItems {
    Write-Log "=== RECENT ITEMS CLEANUP ===" "HEADER"

    Remove-ItemSafe -path "$env:APPDATA\Microsoft\Windows\Recent\*" -description "Recent Items"
    Remove-ItemSafe -path "$env:APPDATA\Microsoft\Windows\Recent\AutomaticDestinations\*" -description "Jump Lists"
}

# ==========================================
# 💾 DISK OPERATIONS
# ==========================================

function Optimize-Drives {
    Write-Log "=== DRIVE OPTIMIZATION ===" "HEADER"

    try {
        $drives = Get-Volume | Where-Object { $_.DriveLetter -ne $null -and $_.DriveType -eq "Fixed" }

        foreach ($drive in $drives) {
            Write-Log "Optimizing drive $($drive.DriveLetter):" "INFO"
            Optimize-Volume -DriveLetter $drive.DriveLetter -Defragment -Verbose
        }

        Write-Log "Drive optimization completed" "SUCCESS"
    } catch {
        Write-Log "Error optimizing drives" "ERROR"
    }
}

function Run-DiskCleanup {
    Write-Log "=== DISK CLEANUP UTILITY ===" "HEADER"

    try {
        cleanmgr /sagerun:1
        Write-Log "Disk Cleanup completed" "SUCCESS"
    } catch {
        Write-Log "Error running Disk Cleanup" "ERROR"
    }
}

function Analyze-DiskSpace {
    Write-Log "=== DISK SPACE ANALYSIS ===" "HEADER"

    try {
        $drives = Get-PSDrive -PSProvider FileSystem

        foreach ($drive in $drives) {
            if ($drive.Used -and $drive.Free) {
                $used = [math]::Round($drive.Used / 1GB, 2)
                $free = [math]::Round($drive.Free / 1GB, 2)
                $total = $used + $free
                $percentFree = [math]::Round(($free / $total) * 100, 1)

                Write-Log "Drive $($drive.Name): $used GB used, $free GB free ($percentFree% free)" "INFO"
            }
        }
    } catch {
        Write-Log "Error analyzing disk space" "ERROR"
    }
}

# ==========================================
# 📊 SYSTEM DIAGNOSTICS
# ==========================================

function Get-SystemInfo {
    Write-Log "=== SYSTEM INFORMATION ===" "HEADER"

    try {
        $os = Get-CimInstance Win32_OperatingSystem
        $cpu = Get-CimInstance Win32_Processor
        $ram = Get-CimInstance Win32_ComputerSystem

        Write-Log "OS: $($os.Caption) $($os.Version)" "INFO"
        Write-Log "CPU: $($cpu.Name)" "INFO"
        Write-Log "RAM: $([math]::Round($ram.TotalPhysicalMemory / 1GB, 2)) GB" "INFO"
        Write-Log "Last Boot: $($os.LastBootUpTime)" "INFO"
    } catch {
        Write-Log "Error retrieving system info" "ERROR"
    }
}

function Test-SystemHealth {
    Write-Log "=== SYSTEM HEALTH CHECK ===" "HEADER"

    Analyze-DiskSpace

    try {
        $memory = Get-Counter '\Memory\Available MBytes'
        Write-Log "Available Memory: $($memory.CounterSamples[0].CookedValue) MB" "INFO"

        $cpu = Get-Counter '\Processor(_Total)\% Processor Time'
        Write-Log "CPU Usage: $([math]::Round($cpu.CounterSamples[0].CookedValue, 1))%" "INFO"
    } catch {
        Write-Log "Error checking system health" "WARNING"
    }
}

# ==========================================
# 🔄 BACKUP & RESTORE
# ==========================================

function Create-RestorePoint {
    param([string]$description = "CleanPC Maintenance")

    Write-Log "=== CREATING RESTORE POINT ===" "HEADER"

    try {
        Enable-ComputerRestore -Drive "C:\"
        Checkpoint-Computer -Description $description -RestorePointType "MODIFY_SETTINGS"
        Write-Log "Restore point created: $description" "SUCCESS"
    } catch {
        Write-Log "Unable to create restore point: $($_.Exception.Message)" "ERROR"
    }
}

# ==========================================
# 🎯 MASTER FUNCTIONS
# ==========================================

function Run-QuickClean {
    Write-Log "========================================" "HEADER"
    Write-Log "QUICK CLEAN STARTED" "HEADER"
    Write-Log "========================================" "HEADER"

    $Global:CleanedSpace = 0
    $Global:ErrorCount = 0

    Clean-Temp
    Clean-Browsers
    Clean-ErrorReports
    Clear-RecentItems

    Write-Log "========================================" "HEADER"
    Write-Log "QUICK CLEAN COMPLETED" "SUCCESS"
    Write-Log "Total Space Freed: $Global:CleanedSpace MB" "SUCCESS"
    Write-Log "Errors: $Global:ErrorCount" "INFO"
    Write-Log "========================================" "HEADER"
}

function Run-DeepClean {
    Write-Log "========================================" "HEADER"
    Write-Log "DEEP CLEAN STARTED" "HEADER"
    Write-Log "========================================" "HEADER"

    $Global:CleanedSpace = 0
    $Global:ErrorCount = 0

    Create-RestorePoint -description "Before CleanPC Deep Clean"

    Clean-Temp
    Clean-Browsers
    Clean-WindowsApps
    Clean-Logs
    Clean-ErrorReports
    Clean-Downloads
    Clear-ActivityHistory
    Clear-RecentItems
    Run-DiskCleanup

    Write-Log "========================================" "HEADER"
    Write-Log "DEEP CLEAN COMPLETED" "SUCCESS"
    Write-Log "Total Space Freed: $Global:CleanedSpace MB" "SUCCESS"
    Write-Log "Errors: $Global:ErrorCount" "INFO"
    Write-Log "========================================" "HEADER"
}

function Run-SystemRepair {
    Write-Log "========================================" "HEADER"
    Write-Log "SYSTEM REPAIR STARTED" "HEADER"
    Write-Log "========================================" "HEADER"

    Create-RestorePoint -description "Before CleanPC System Repair"

    Run-DISM
    Run-SFC
    Reset-NetworkStack
    Repair-WindowsStore

    Write-Log "========================================" "HEADER"
    Write-Log "SYSTEM REPAIR COMPLETED" "SUCCESS"
    Write-Log "RESTART RECOMMENDED" "WARNING"
    Write-Log "========================================" "HEADER"
}

function Run-FullOptimization {
    Write-Log "========================================" "HEADER"
    Write-Log "FULL OPTIMIZATION STARTED" "HEADER"
    Write-Log "========================================" "HEADER"

    Create-RestorePoint -description "Before CleanPC Full Optimization"

    Optimize-Startup
    Optimize-Services
    Optimize-VisualEffects
    Optimize-PowerPlan
    Disable-Telemetry
    Remove-Bloatware
    Optimize-Drives

    Write-Log "========================================" "HEADER"
    Write-Log "FULL OPTIMIZATION COMPLETED" "SUCCESS"
    Write-Log "RESTART REQUIRED" "WARNING"
    Write-Log "========================================" "HEADER"
}

function Run-CompleteMaintenace {
    Write-Log "========================================" "HEADER"
    Write-Log "COMPLETE MAINTENANCE STARTED" "HEADER"
    Write-Log "This will take 30-60 minutes" "WARNING"
    Write-Log "========================================" "HEADER"

    $Global:CleanedSpace = 0
    $Global:ErrorCount = 0

    Create-RestorePoint -description "Before CleanPC Complete Maintenance"

    Test-SystemHealth
    Run-DeepClean
    Run-SystemRepair
    Run-FullOptimization
    Update-Apps

    Write-Log "========================================" "HEADER"
    Write-Log "COMPLETE MAINTENANCE FINISHED" "SUCCESS"
    Write-Log "Total Space Freed: $Global:CleanedSpace MB" "SUCCESS"
    Write-Log "Errors: $Global:ErrorCount" "INFO"
    Write-Log "RESTART REQUIRED" "WARNING"
    Write-Log "========================================" "HEADER"
}

# ==========================================
# 📤 EXPORT FUNCTIONS
# ==========================================

Export-ModuleMember -Function *

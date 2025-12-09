# ================================
# CleanPC_Advanced.ps1
# Advanced premium features for power users
# ================================

function Find-DuplicateFiles {
    param(
        [Parameter(Mandatory=$false)]
        [string]$path = "$env:USERPROFILE",

        [Parameter(Mandatory=$false)]
        [int]$minSizeMB = 1
    )

    Write-Log "=== DUPLICATE FILE FINDER ===" "HEADER"
    Write-Log "Scanning: $path" "INFO"
    Write-Log "Minimum file size: $minSizeMB MB" "INFO"

    try {
        $files = Get-ChildItem -Path $path -Recurse -File -ErrorAction SilentlyContinue |
                 Where-Object { $_.Length -gt ($minSizeMB * 1MB) }

        Write-Log "Analyzing $($files.Count) files..." "INFO"

        $fileGroups = $files | Group-Object -Property Length

        $duplicates = @()

        foreach ($group in $fileGroups) {
            if ($group.Count -gt 1) {
                $hashTable = @{}

                foreach ($file in $group.Group) {
                    try {
                        $hash = (Get-FileHash -Path $file.FullName -Algorithm MD5).Hash

                        if ($hashTable.ContainsKey($hash)) {
                            $duplicates += [PSCustomObject]@{
                                OriginalFile = $hashTable[$hash]
                                DuplicateFile = $file.FullName
                                Size = [math]::Round($file.Length / 1MB, 2)
                                Hash = $hash
                            }
                        } else {
                            $hashTable[$hash] = $file.FullName
                        }
                    } catch {
                        continue
                    }
                }
            }
        }

        if ($duplicates.Count -gt 0) {
            Write-Log "Found $($duplicates.Count) duplicate files" "SUCCESS"

            $totalSpace = ($duplicates | Measure-Object -Property Size -Sum).Sum
            Write-Log "Potential space to free: $totalSpace MB" "INFO"

            $outputPath = "$env:TEMP\CleanPC_Duplicates_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"
            $duplicates | Export-Csv -Path $outputPath -NoTypeInformation

            Write-Log "Report saved to: $outputPath" "SUCCESS"

            return $duplicates
        } else {
            Write-Log "No duplicate files found" "INFO"
        }
    }
    catch {
        Write-Log "Error scanning for duplicates: $($_.Exception.Message)" "ERROR"
    }
}

function Find-LargeFiles {
    param(
        [Parameter(Mandatory=$false)]
        [string]$path = "C:\",

        [Parameter(Mandatory=$false)]
        [int]$minSizeMB = 100,

        [Parameter(Mandatory=$false)]
        [int]$topN = 50
    )

    Write-Log "=== LARGE FILE FINDER ===" "HEADER"
    Write-Log "Scanning: $path" "INFO"
    Write-Log "Finding files larger than: $minSizeMB MB" "INFO"

    try {
        $largeFiles = Get-ChildItem -Path $path -Recurse -File -ErrorAction SilentlyContinue |
                      Where-Object { $_.Length -gt ($minSizeMB * 1MB) } |
                      Sort-Object Length -Descending |
                      Select-Object -First $topN

        if ($largeFiles) {
            Write-Log "Found $($largeFiles.Count) large files" "SUCCESS"

            foreach ($file in $largeFiles) {
                $sizeMB = [math]::Round($file.Length / 1MB, 2)
                Write-Log "$sizeMB MB - $($file.FullName)" "INFO"
            }

            $outputPath = "$env:TEMP\CleanPC_LargeFiles_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"
            $largeFiles | Select-Object FullName, @{Name="SizeMB";Expression={[math]::Round($_.Length / 1MB, 2)}}, LastWriteTime |
                         Export-Csv -Path $outputPath -NoTypeInformation

            Write-Log "Report saved to: $outputPath" "SUCCESS"
        } else {
            Write-Log "No large files found" "INFO"
        }
    }
    catch {
        Write-Log "Error scanning for large files: $($_.Exception.Message)" "ERROR"
    }
}

function Backup-RegistryKeys {
    param(
        [Parameter(Mandatory=$false)]
        [string]$backupPath = "$env:USERPROFILE\Documents\CleanPC_Registry_Backups"
    )

    Write-Log "=== REGISTRY BACKUP ===" "HEADER"

    if (-not (Test-Path $backupPath)) {
        New-Item -Path $backupPath -ItemType Directory -Force | Out-Null
    }

    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $backupFile = "$backupPath\Registry_Backup_$timestamp.reg"

    $criticalKeys = @(
        "HKCU\Software\Microsoft\Windows\CurrentVersion\Run",
        "HKLM\Software\Microsoft\Windows\CurrentVersion\Run",
        "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer",
        "HKLM\System\CurrentControlSet\Services"
    )

    try {
        foreach ($key in $criticalKeys) {
            Write-Log "Backing up: $key" "INFO"
            reg export $key "$backupFile" /y | Out-Null
        }

        Write-Log "Registry backup completed: $backupFile" "SUCCESS"
        return $backupFile
    }
    catch {
        Write-Log "Error backing up registry: $($_.Exception.Message)" "ERROR"
    }
}

function Optimize-SSD {
    Write-Log "=== SSD OPTIMIZATION ===" "HEADER"

    try {
        $drives = Get-PhysicalDisk | Where-Object { $_.MediaType -eq "SSD" }

        if ($drives) {
            Write-Log "Found $($drives.Count) SSD(s)" "INFO"

            foreach ($drive in $drives) {
                Write-Log "Optimizing: $($drive.FriendlyName)" "INFO"
            }

            Write-Log "Disabling Superfetch for SSDs..." "INFO"
            Stop-Service -Name "SysMain" -Force -ErrorAction SilentlyContinue
            Set-Service -Name "SysMain" -StartupType Disabled -ErrorAction SilentlyContinue

            Write-Log "Disabling Prefetch for SSDs..." "INFO"
            Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" -Name "EnablePrefetcher" -Value 0 -ErrorAction SilentlyContinue

            Write-Log "Disabling Defragmentation for SSDs..." "INFO"
            Disable-ScheduledTask -TaskName "\Microsoft\Windows\Defrag\ScheduledDefrag" -ErrorAction SilentlyContinue

            Write-Log "Enabling TRIM for SSDs..." "INFO"
            fsutil behavior set DisableDeleteNotify 0

            Write-Log "SSD optimization completed" "SUCCESS"
        } else {
            Write-Log "No SSDs detected" "INFO"
        }
    }
    catch {
        Write-Log "Error optimizing SSD: $($_.Exception.Message)" "ERROR"
    }
}

function Clean-RegistrySafe {
    Write-Log "=== SAFE REGISTRY CLEANUP ===" "HEADER"
    Write-Log "Creating registry backup first..." "INFO"

    Backup-RegistryKeys

    try {
        $keysToClean = @(
            "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU",
            "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths",
            "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs"
        )

        foreach ($key in $keysToClean) {
            if (Test-Path $key) {
                Remove-Item -Path $key -Recurse -Force -ErrorAction Stop
                Write-Log "Cleaned: $key" "SUCCESS"
            }
        }

        Write-Log "Registry cleanup completed" "SUCCESS"
    }
    catch {
        Write-Log "Error cleaning registry: $($_.Exception.Message)" "ERROR"
    }
}

function Optimize-RAM {
    Write-Log "=== RAM OPTIMIZATION ===" "HEADER"

    try {
        Write-Log "Clearing standby memory..." "INFO"

        if (-not ([System.Management.Automation.PSTypeName]'MemoryManagement').Type) {
            Add-Type @"
            using System;
            using System.Runtime.InteropServices;

            public class MemoryManagement {
                [DllImport("kernel32.dll", SetLastError = true)]
                [return: MarshalAs(UnmanagedType.Bool)]
                public static extern bool SetProcessWorkingSetSize(IntPtr process, UIntPtr minimumWorkingSetSize, UIntPtr maximumWorkingSetSize);

                public static void FlushMemory() {
                    GC.Collect();
                    GC.WaitForPendingFinalizers();
                    if (Environment.OSVersion.Platform == PlatformID.Win32NT) {
                        SetProcessWorkingSetSize(System.Diagnostics.Process.GetCurrentProcess().Handle, (UIntPtr)0xFFFFFFFF, (UIntPtr)0xFFFFFFFF);
                    }
                }
            }
"@
        }

        [MemoryManagement]::FlushMemory()

        $memBefore = (Get-Counter '\Memory\Available MBytes').CounterSamples[0].CookedValue

        Get-Process | Where-Object { $_.WorkingSet -gt 50MB } | ForEach-Object {
            try {
                $_.MinWorkingSet = 1MB
                $_.MaxWorkingSet = 1MB
            } catch {}
        }

        Start-Sleep -Seconds 2

        $memAfter = (Get-Counter '\Memory\Available MBytes').CounterSamples[0].CookedValue
        $freed = [math]::Round($memAfter - $memBefore, 2)

        Write-Log "RAM optimization completed" "SUCCESS"
        Write-Log "Memory freed: $freed MB" "INFO"
    }
    catch {
        Write-Log "Error optimizing RAM: $($_.Exception.Message)" "ERROR"
    }
}

function Analyze-StartupImpact {
    Write-Log "=== STARTUP IMPACT ANALYSIS ===" "HEADER"

    try {
        $startupApps = Get-CimInstance Win32_StartupCommand

        $report = @()

        foreach ($app in $startupApps) {
            $impact = "Unknown"

            if ($app.Command -match "Microsoft|Windows|System") {
                $impact = "Low"
            } elseif ($app.Command -match "Security|Antivirus|Defender") {
                $impact = "Required"
            } else {
                $impact = "Medium-High"
            }

            $report += [PSCustomObject]@{
                Name = $app.Name
                Command = $app.Command
                Location = $app.Location
                User = $app.User
                Impact = $impact
            }
        }

        Write-Log "Found $($report.Count) startup items" "INFO"

        $report | Sort-Object Impact -Descending | Format-Table -AutoSize

        $outputPath = "$env:TEMP\CleanPC_StartupAnalysis_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"
        $report | Export-Csv -Path $outputPath -NoTypeInformation

        Write-Log "Analysis saved to: $outputPath" "SUCCESS"

        return $report
    }
    catch {
        Write-Log "Error analyzing startup: $($_.Exception.Message)" "ERROR"
    }
}

function Monitor-SystemPerformance {
    param(
        [Parameter(Mandatory=$false)]
        [int]$durationSeconds = 60
    )

    Write-Log "=== PERFORMANCE MONITORING ===" "HEADER"
    Write-Log "Monitoring for $durationSeconds seconds..." "INFO"

    $samples = @()
    $interval = 5
    $iterations = [math]::Ceiling($durationSeconds / $interval)

    try {
        for ($i = 0; $i -lt $iterations; $i++) {
            $cpu = (Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples[0].CookedValue
            $memory = (Get-Counter '\Memory\Available MBytes').CounterSamples[0].CookedValue
            $disk = (Get-Counter '\PhysicalDisk(_Total)\% Disk Time').CounterSamples[0].CookedValue

            $samples += [PSCustomObject]@{
                Timestamp = Get-Date
                CPU = [math]::Round($cpu, 2)
                AvailableMemoryMB = [math]::Round($memory, 2)
                DiskUsage = [math]::Round($disk, 2)
            }

            Write-Log "CPU: $([math]::Round($cpu, 1))% | RAM: $([math]::Round($memory, 0)) MB | Disk: $([math]::Round($disk, 1))%" "INFO"

            Start-Sleep -Seconds $interval
        }

        $avgCPU = ($samples | Measure-Object -Property CPU -Average).Average
        $avgMemory = ($samples | Measure-Object -Property AvailableMemoryMB -Average).Average
        $avgDisk = ($samples | Measure-Object -Property DiskUsage -Average).Average

        Write-Log "Average CPU: $([math]::Round($avgCPU, 1))%" "INFO"
        Write-Log "Average Available RAM: $([math]::Round($avgMemory, 0)) MB" "INFO"
        Write-Log "Average Disk Usage: $([math]::Round($avgDisk, 1))%" "INFO"

        $outputPath = "$env:TEMP\CleanPC_Performance_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"
        $samples | Export-Csv -Path $outputPath -NoTypeInformation

        Write-Log "Performance report saved to: $outputPath" "SUCCESS"
    }
    catch {
        Write-Log "Error monitoring performance: $($_.Exception.Message)" "ERROR"
    }
}

function Repair-WindowsComponents {
    Write-Log "=== WINDOWS COMPONENTS REPAIR ===" "HEADER"

    Create-RestorePoint -description "Before Component Repair"

    try {
        Write-Log "Repairing Windows Store..." "INFO"
        wsreset.exe -ErrorAction SilentlyContinue

        Write-Log "Repairing Windows Update..." "INFO"
        Stop-Service -Name wuauserv -Force -ErrorAction SilentlyContinue
        Stop-Service -Name bits -Force -ErrorAction SilentlyContinue
        Remove-Item -Path "C:\Windows\SoftwareDistribution" -Recurse -Force -ErrorAction SilentlyContinue
        Start-Service -Name wuauserv -ErrorAction SilentlyContinue
        Start-Service -Name bits -ErrorAction SilentlyContinue

        Write-Log "Re-registering Windows components..." "INFO"
        Get-AppxPackage -AllUsers | ForEach-Object {
            try {
                Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml" -ErrorAction SilentlyContinue
            } catch {}
        }

        Write-Log "Component repair completed" "SUCCESS"
    }
    catch {
        Write-Log "Error repairing components: $($_.Exception.Message)" "ERROR"
    }
}

function Export-SystemReport {
    param(
        [Parameter(Mandatory=$false)]
        [string]$outputPath = "$env:USERPROFILE\Documents\CleanPC_SystemReport_$(Get-Date -Format 'yyyyMMdd_HHmmss').html"
    )

    Write-Log "=== GENERATING SYSTEM REPORT ===" "HEADER"

    try {
        $os = Get-CimInstance Win32_OperatingSystem
        $cpu = Get-CimInstance Win32_Processor
        $ram = Get-CimInstance Win32_ComputerSystem
        $disk = Get-CimInstance Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 }

        $html = @"
<!DOCTYPE html>
<html>
<head>
    <title>CleanPC System Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; background: #f5f5f5; }
        .container { max-width: 1200px; margin: 0 auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        h1 { color: #2c3e50; border-bottom: 3px solid #3498db; padding-bottom: 10px; }
        h2 { color: #34495e; margin-top: 30px; }
        table { width: 100%; border-collapse: collapse; margin: 20px 0; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background-color: #3498db; color: white; }
        tr:hover { background-color: #f5f5f5; }
        .metric { display: inline-block; margin: 10px 20px 10px 0; padding: 15px; background: #ecf0f1; border-radius: 5px; }
        .metric-value { font-size: 24px; font-weight: bold; color: #2980b9; }
        .metric-label { font-size: 12px; color: #7f8c8d; }
    </style>
</head>
<body>
    <div class="container">
        <h1>CleanPC System Report</h1>
        <p>Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")</p>

        <h2>System Information</h2>
        <table>
            <tr><th>Property</th><th>Value</th></tr>
            <tr><td>Operating System</td><td>$($os.Caption)</td></tr>
            <tr><td>Version</td><td>$($os.Version)</td></tr>
            <tr><td>Architecture</td><td>$($os.OSArchitecture)</td></tr>
            <tr><td>Computer Name</td><td>$($ram.Name)</td></tr>
            <tr><td>Last Boot</td><td>$($os.LastBootUpTime)</td></tr>
        </table>

        <h2>Hardware</h2>
        <table>
            <tr><th>Component</th><th>Details</th></tr>
            <tr><td>Processor</td><td>$($cpu.Name)</td></tr>
            <tr><td>Cores</td><td>$($cpu.NumberOfCores)</td></tr>
            <tr><td>Logical Processors</td><td>$($cpu.NumberOfLogicalProcessors)</td></tr>
            <tr><td>RAM</td><td>$([math]::Round($ram.TotalPhysicalMemory / 1GB, 2)) GB</td></tr>
        </table>

        <h2>Storage</h2>
        <table>
            <tr><th>Drive</th><th>Total Size</th><th>Free Space</th><th>Used</th></tr>
"@

        foreach ($d in $disk) {
            $totalGB = [math]::Round($d.Size / 1GB, 2)
            $freeGB = [math]::Round($d.FreeSpace / 1GB, 2)
            $usedPercent = [math]::Round((($d.Size - $d.FreeSpace) / $d.Size) * 100, 1)

            $html += "<tr><td>$($d.DeviceID)</td><td>$totalGB GB</td><td>$freeGB GB</td><td>$usedPercent%</td></tr>`n"
        }

        $html += @"
        </table>

        <h2>Performance Metrics</h2>
        <div>
            <div class="metric">
                <div class="metric-value">$([math]::Round((Get-Counter '\Processor(_Total)\% Processor Time').CounterSamples[0].CookedValue, 1))%</div>
                <div class="metric-label">CPU Usage</div>
            </div>
            <div class="metric">
                <div class="metric-value">$([math]::Round((Get-Counter '\Memory\Available MBytes').CounterSamples[0].CookedValue, 0)) MB</div>
                <div class="metric-label">Available Memory</div>
            </div>
        </div>

        <footer style="margin-top: 40px; padding-top: 20px; border-top: 1px solid #ddd; color: #7f8c8d; text-align: center;">
            <p>Generated by CleanPC Pro | $(Get-Date -Format "yyyy")</p>
        </footer>
    </div>
</body>
</html>
"@

        $html | Out-File -FilePath $outputPath -Encoding UTF8

        Write-Log "System report generated: $outputPath" "SUCCESS"

        Start-Process $outputPath
    }
    catch {
        Write-Log "Error generating report: $($_.Exception.Message)" "ERROR"
    }
}

Export-ModuleMember -Function *

# ================================
# KODAL Cleaner GUI - Ultra Premium Edition
# Powered by CleanPC Framework
# ================================
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Import backend modules
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$scriptPath\CleanPC_Core.ps1"
. "$scriptPath\CleanPC_Advanced.ps1"
. "$scriptPath\CleanPC_Config.ps1"

# ======================================================
# GLOBAL SETTINGS & PREMIUM COLORS
# ======================================================
$Global:Theme = "Dark"
$Global:LogBox = $null
$Global:PrimaryBlue = [System.Drawing.Color]::FromArgb(6, 147, 227)
$Global:DarkBlue = [System.Drawing.Color]::FromArgb(4, 99, 180)
$Global:LightBlue = [System.Drawing.Color]::FromArgb(100, 200, 255)
$Global:DeepDark = [System.Drawing.Color]::FromArgb(13, 17, 27)
$Global:CardDark = [System.Drawing.Color]::FromArgb(22, 28, 42)
$Global:BorderColor = [System.Drawing.Color]::FromArgb(40, 60, 90)
$Global:AccentGreen = [System.Drawing.Color]::FromArgb(34, 197, 94)
$Global:AccentOrange = [System.Drawing.Color]::FromArgb(249, 115, 22)

# ======================================================
# REMOVE ALL ROUNDEDBUTTON CLASS CODE COMPLETELY
# ======================================================



# ======================================================
# LOGGING
# ======================================================
function Write-Log {
    param([string]$msg)
    if ($Global:LogBox) {
        $timestamp = (Get-Date).ToString("HH:mm:ss")
        $Global:LogBox.AppendText("[$timestamp] $msg`r`n")
        $Global:LogBox.ScrollToCaret()
    }
}

# ======================================================
# MAIN FORM - ULTRA PREMIUM
# ======================================================
$form = New-Object System.Windows.Forms.Form
$form.Text = "KODAL Cleaner - Premium Edition"
$form.Size = New-Object System.Drawing.Size(1400, 950)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "None"
$form.BackColor = $Global:DeepDark
$form.DoubleBuffered = $true

# Add border effect
$borderPanel = New-Object System.Windows.Forms.Panel
$borderPanel.Dock = "Fill"
$borderPanel.BackColor = $Global:DeepDark
$borderPanel.Padding = New-Object System.Windows.Forms.Padding(1)

$mainPanel = New-Object System.Windows.Forms.Panel
$mainPanel.Dock = "Fill"
$mainPanel.BackColor = $Global:DeepDark
$borderPanel.Controls.Add($mainPanel)
$form.Controls.Add($borderPanel)

# ======================================================
# PREMIUM HEADER
# ======================================================
$headerPanel = New-Object System.Windows.Forms.Panel
$headerPanel.Size = New-Object System.Drawing.Size(1400, 120)
$headerPanel.Location = New-Object System.Drawing.Point(0, 0)
$headerPanel.BackColor = $Global:CardDark
$headerPanel.Dock = "Top"

$headerGradient = New-Object System.Windows.Forms.Panel
$headerGradient.Dock = "Top"
$headerGradient.Height = 3
$headerGradient.BackColor = $Global:PrimaryBlue
$headerPanel.Controls.Add($headerGradient)

$lblLogo = New-Object System.Windows.Forms.Label
$lblLogo.Text = "◆"
$lblLogo.Font = New-Object System.Drawing.Font("Segoe UI", 32, [System.Drawing.FontStyle]::Bold)
$lblLogo.Location = New-Object System.Drawing.Point(40, 30)
$lblLogo.Size = New-Object System.Drawing.Size(70, 70)
$lblLogo.ForeColor = $Global:PrimaryBlue
$headerPanel.Controls.Add($lblLogo)

$lblTitle = New-Object System.Windows.Forms.Label
$lblTitle.Text = "KODAL Cleaner"
$lblTitle.Font = New-Object System.Drawing.Font("Segoe UI", 28, [System.Drawing.FontStyle]::Bold)
$lblTitle.Location = New-Object System.Drawing.Point(120, 30)
$lblTitle.Size = New-Object System.Drawing.Size(400, 45)
$lblTitle.ForeColor = [System.Drawing.Color]::White
$headerPanel.Controls.Add($lblTitle)

$lblSubtitle = New-Object System.Windows.Forms.Label
$lblSubtitle.Text = "Professional System Optimization Suite"
$lblSubtitle.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Regular)
$lblSubtitle.Location = New-Object System.Drawing.Point(120, 75)
$lblSubtitle.Size = New-Object System.Drawing.Size(350, 25)
$lblSubtitle.ForeColor = [System.Drawing.Color]::FromArgb(150, 170, 200)
$headerPanel.Controls.Add($lblSubtitle)

$mainPanel.Controls.Add($headerPanel)

# ======================================================
# TAB CONTROL - PREMIUM STYLING
# ======================================================
$tabs = New-Object System.Windows.Forms.TabControl
$tabs.Size = New-Object System.Drawing.Size(1360, 750)
$tabs.Location = New-Object System.Drawing.Point(20, 140)
$tabs.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::SemiBold)
$tabs.Appearance = "FlatButtons"
$tabs.SizeMode = "Fixed"
$tabs.ItemSize = New-Object System.Drawing.Size(220, 50)
$tabs.BackColor = $Global:DeepDark
$tabs.ForeColor = [System.Drawing.Color]::White

$tabDashboard = New-Object System.Windows.Forms.TabPage
$tabDashboard.Text = "    DASHBOARD"
$tabDashboard.BackColor = $Global:DeepDark

$tabCleanup = New-Object System.Windows.Forms.TabPage
$tabCleanup.Text = "    CLEANUP"
$tabCleanup.BackColor = $Global:DeepDark

$tabRepairs = New-Object System.Windows.Forms.TabPage
$tabRepairs.Text = "    REPAIRS"
$tabRepairs.BackColor = $Global:DeepDark

$tabApps = New-Object System.Windows.Forms.TabPage
$tabApps.Text = "    APPS"
$tabApps.BackColor = $Global:DeepDark

$tabAdvanced = New-Object System.Windows.Forms.TabPage
$tabAdvanced.Text = "    ADVANCED"
$tabAdvanced.BackColor = $Global:DeepDark

$tabs.Controls.AddRange(@($tabDashboard, $tabCleanup, $tabRepairs, $tabApps, $tabAdvanced))
$mainPanel.Controls.Add($tabs)

# ======================================================
# DASHBOARD - LUXURY DESIGN
# ======================================================
$dashScroll = New-Object System.Windows.Forms.Panel
$dashScroll.AutoScroll = $true
$dashScroll.Dock = "Fill"
$dashScroll.BackColor = $Global:DeepDark
$tabDashboard.Controls.Add($dashScroll)

$dashContent = New-Object System.Windows.Forms.Panel
$dashContent.AutoSize = $true
$dashContent.AutoSizeMode = "GrowAndShrink"
$dashContent.BackColor = $Global:DeepDark
$dashContent.Padding = New-Object System.Windows.Forms.Padding(30)
$dashScroll.Controls.Add($dashContent)

$statusTitle = New-Object System.Windows.Forms.Label
$statusTitle.Text = "SYSTEM STATUS"
$statusTitle.Font = New-Object System.Drawing.Font("Segoe UI", 18, [System.Drawing.FontStyle]::Bold)
$statusTitle.Location = New-Object System.Drawing.Point(30, 30)
$statusTitle.Size = New-Object System.Drawing.Size(500, 40)
$statusTitle.ForeColor = [System.Drawing.Color]::White
$dashContent.Controls.Add($statusTitle)

# CPU Card
$cpuCard = New-Object System.Windows.Forms.Panel
$cpuCard.Location = New-Object System.Drawing.Point(30, 80)
$cpuCard.Size = New-Object System.Drawing.Size(350, 280)
$cpuCard.BackColor = $Global:CardDark
$cpuCard.Padding = New-Object System.Windows.Forms.Padding(1)

$cpuCardBorder = New-Object System.Windows.Forms.Panel
$cpuCardBorder.Dock = "Fill"
$cpuCardBorder.BackColor = $Global:CardDark
$cpuCardBorder.Padding = New-Object System.Windows.Forms.Padding(20)

$cpuIcon = New-Object System.Windows.Forms.Label
$cpuIcon.Text = "◈"
$cpuIcon.Font = New-Object System.Drawing.Font("Segoe UI", 24, [System.Drawing.FontStyle]::Bold)
$cpuIcon.Location = New-Object System.Drawing.Point(20, 20)
$cpuIcon.Size = New-Object System.Drawing.Size(50, 50)
$cpuIcon.ForeColor = $Global:PrimaryBlue
$cpuCardBorder.Controls.Add($cpuIcon)

$cpuValueLbl = New-Object System.Windows.Forms.Label
$cpuValueLbl.Text = "0%"
$cpuValueLbl.Font = New-Object System.Drawing.Font("Segoe UI", 42, [System.Drawing.FontStyle]::Bold)
$cpuValueLbl.Location = New-Object System.Drawing.Point(20, 70)
$cpuValueLbl.Size = New-Object System.Drawing.Size(300, 60)
$cpuValueLbl.ForeColor = $Global:PrimaryBlue
$cpuValueLbl.TextAlign = "TopLeft"
$cpuCardBorder.Controls.Add($cpuValueLbl)

$cpuLabelLbl = New-Object System.Windows.Forms.Label
$cpuLabelLbl.Text = "CPU Usage"
$cpuLabelLbl.Font = New-Object System.Drawing.Font("Segoe UI", 13, [System.Drawing.FontStyle]::Regular)
$cpuLabelLbl.Location = New-Object System.Drawing.Point(20, 140)
$cpuLabelLbl.Size = New-Object System.Drawing.Size(300, 30)
$cpuLabelLbl.ForeColor = [System.Drawing.Color]::FromArgb(150, 170, 200)
$cpuCardBorder.Controls.Add($cpuLabelLbl)

$cpuDetailLbl = New-Object System.Windows.Forms.Label
$cpuDetailLbl.Text = "System utilization"
$cpuDetailLbl.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Regular)
$cpuDetailLbl.Location = New-Object System.Drawing.Point(20, 175)
$cpuDetailLbl.Size = New-Object System.Drawing.Size(300, 80)
$cpuDetailLbl.ForeColor = [System.Drawing.Color]::FromArgb(100, 120, 150)
$cpuDetailLbl.AutoSize = $false
$cpuCardBorder.Controls.Add($cpuDetailLbl)

$cpuCard.Controls.Add($cpuCardBorder)
$dashContent.Controls.Add($cpuCard)

# RAM Card
$ramCard = New-Object System.Windows.Forms.Panel
$ramCard.Location = New-Object System.Drawing.Point(410, 80)
$ramCard.Size = New-Object System.Drawing.Size(350, 280)
$ramCard.BackColor = $Global:CardDark

$ramCardBorder = New-Object System.Windows.Forms.Panel
$ramCardBorder.Dock = "Fill"
$ramCardBorder.BackColor = $Global:CardDark
$ramCardBorder.Padding = New-Object System.Windows.Forms.Padding(20)

$ramIcon = New-Object System.Windows.Forms.Label
$ramIcon.Text = "▥"
$ramIcon.Font = New-Object System.Drawing.Font("Segoe UI", 24, [System.Drawing.FontStyle]::Bold)
$ramIcon.Location = New-Object System.Drawing.Point(20, 20)
$ramIcon.Size = New-Object System.Drawing.Size(50, 50)
$ramIcon.ForeColor = $Global:AccentGreen
$ramCardBorder.Controls.Add($ramIcon)

$ramValueLbl = New-Object System.Windows.Forms.Label
$ramValueLbl.Text = "0%"
$ramValueLbl.Font = New-Object System.Drawing.Font("Segoe UI", 42, [System.Drawing.FontStyle]::Bold)
$ramValueLbl.Location = New-Object System.Drawing.Point(20, 70)
$ramValueLbl.Size = New-Object System.Drawing.Size(300, 60)
$ramValueLbl.ForeColor = $Global:AccentGreen
$ramValueLbl.TextAlign = "TopLeft"
$ramCardBorder.Controls.Add($ramValueLbl)

$ramLabelLbl = New-Object System.Windows.Forms.Label
$ramLabelLbl.Text = "Memory Usage"
$ramLabelLbl.Font = New-Object System.Drawing.Font("Segoe UI", 13, [System.Drawing.FontStyle]::Regular)
$ramLabelLbl.Location = New-Object System.Drawing.Point(20, 140)
$ramLabelLbl.Size = New-Object System.Drawing.Size(300, 30)
$ramLabelLbl.ForeColor = [System.Drawing.Color]::FromArgb(150, 170, 200)
$ramCardBorder.Controls.Add($ramLabelLbl)

$ramDetailLbl = New-Object System.Windows.Forms.Label
$ramDetailLbl.Text = "RAM allocation"
$ramDetailLbl.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Regular)
$ramDetailLbl.Location = New-Object System.Drawing.Point(20, 175)
$ramDetailLbl.Size = New-Object System.Drawing.Size(300, 80)
$ramDetailLbl.ForeColor = [System.Drawing.Color]::FromArgb(100, 120, 150)
$ramDetailLbl.AutoSize = $false
$ramCardBorder.Controls.Add($ramDetailLbl)

$ramCard.Controls.Add($ramCardBorder)
$dashContent.Controls.Add($ramCard)

# Disk Card
$diskCard = New-Object System.Windows.Forms.Panel
$diskCard.Location = New-Object System.Drawing.Point(790, 80)
$diskCard.Size = New-Object System.Drawing.Size(350, 280)
$diskCard.BackColor = $Global:CardDark

$diskCardBorder = New-Object System.Windows.Forms.Panel
$diskCardBorder.Dock = "Fill"
$diskCardBorder.BackColor = $Global:CardDark
$diskCardBorder.Padding = New-Object System.Windows.Forms.Padding(20)

$diskIcon = New-Object System.Windows.Forms.Label
$diskIcon.Text = "◉"
$diskIcon.Font = New-Object System.Drawing.Font("Segoe UI", 24, [System.Drawing.FontStyle]::Bold)
$diskIcon.Location = New-Object System.Drawing.Point(20, 20)
$diskIcon.Size = New-Object System.Drawing.Size(50, 50)
$diskIcon.ForeColor = $Global:AccentOrange
$diskCardBorder.Controls.Add($diskIcon)

$diskValueLbl = New-Object System.Windows.Forms.Label
$diskValueLbl.Text = "0%"
$diskValueLbl.Font = New-Object System.Drawing.Font("Segoe UI", 42, [System.Drawing.FontStyle]::Bold)
$diskValueLbl.Location = New-Object System.Drawing.Point(20, 70)
$diskValueLbl.Size = New-Object System.Drawing.Size(300, 60)
$diskValueLbl.ForeColor = $Global:AccentOrange
$diskValueLbl.TextAlign = "TopLeft"
$diskCardBorder.Controls.Add($diskValueLbl)

$diskLabelLbl = New-Object System.Windows.Forms.Label
$diskLabelLbl.Text = "Disk Usage"
$diskLabelLbl.Font = New-Object System.Drawing.Font("Segoe UI", 13, [System.Drawing.FontStyle]::Regular)
$diskLabelLbl.Location = New-Object System.Drawing.Point(20, 140)
$diskLabelLbl.Size = New-Object System.Drawing.Size(300, 30)
$diskLabelLbl.ForeColor = [System.Drawing.Color]::FromArgb(150, 170, 200)
$diskCardBorder.Controls.Add($diskLabelLbl)

$diskDetailLbl = New-Object System.Windows.Forms.Label
$diskDetailLbl.Text = "Storage capacity"
$diskDetailLbl.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Regular)
$diskDetailLbl.Location = New-Object System.Drawing.Point(20, 175)
$diskDetailLbl.Size = New-Object System.Drawing.Size(300, 80)
$diskDetailLbl.ForeColor = [System.Drawing.Color]::FromArgb(100, 120, 150)
$diskDetailLbl.AutoSize = $false
$diskCardBorder.Controls.Add($diskDetailLbl)

$diskCard.Controls.Add($diskCardBorder)
$dashContent.Controls.Add($diskCard)

# System Info Card
$infoCard = New-Object System.Windows.Forms.Panel
$infoCard.Location = New-Object System.Drawing.Point(30, 390)
$infoCard.Size = New-Object System.Drawing.Size(1100, 200)
$infoCard.BackColor = $Global:CardDark
$infoCard.Padding = New-Object System.Windows.Forms.Padding(1)

$infoCardBorder = New-Object System.Windows.Forms.Panel
$infoCardBorder.Dock = "Fill"
$infoCardBorder.BackColor = $Global:CardDark
$infoCardBorder.Padding = New-Object System.Windows.Forms.Padding(25)

$infoTitle = New-Object System.Windows.Forms.Label
$infoTitle.Text = "SYSTEM INFORMATION"
$infoTitle.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
$infoTitle.Location = New-Object System.Drawing.Point(25, 15)
$infoTitle.Size = New-Object System.Drawing.Size(400, 30)
$infoTitle.ForeColor = [System.Drawing.Color]::White
$infoCardBorder.Controls.Add($infoTitle)

$sysInfoLbl = New-Object System.Windows.Forms.Label
$sysInfoLbl.Text = "Windows Version: -- | Uptime: -- | Processor: --"
$sysInfoLbl.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Regular)
$sysInfoLbl.Location = New-Object System.Drawing.Point(25, 55)
$sysInfoLbl.Size = New-Object System.Drawing.Size(1000, 110)
$sysInfoLbl.ForeColor = [System.Drawing.Color]::FromArgb(150, 170, 200)
$sysInfoLbl.AutoSize = $false
$infoCardBorder.Controls.Add($sysInfoLbl)

$infoCard.Controls.Add($infoCardBorder)
$dashContent.Controls.Add($infoCard)

function Get-CPUUsage {
    $cpu = Get-Counter '\Processor(_Total)\% Processor Time' 2>$null
    return [math]::Round($cpu.CounterSamples.CookedValue, 1)
}

function Get-RAM {
    $os = Get-CimInstance Win32_OperatingSystem 2>$null
    $total = [math]::Round($os.TotalVisibleMemorySize / 1MB, 1)
    $free = [math]::Round($os.FreePhysicalMemory / 1MB, 1)
    return @{ Total = $total; Free = $free; Used = $total - $free }
}

function Get-Disk {
    $c = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'" 2>$null
    $free = [math]::Round($c.FreeSpace / 1GB, 2)
    $total = [math]::Round($c.Size / 1GB, 2)
    return @{ Free = $free; Total = $total; Used = $total - $free }
}

function Refresh-Dashboard {
    try {
        $cpu = Get-CPUUsage
        $ram = Get-RAM
        $disk = Get-Disk
        $os = Get-CimInstance Win32_OperatingSystem 2>$null
        $proc = Get-CimInstance Win32_Processor 2>$null

        $cpuValueLbl.Text = "$cpu%"
        $ramPercent = [math]::Round(($ram.Used / $ram.Total) * 100, 0)
        $ramValueLbl.Text = "$ramPercent%"
        $diskPercent = [math]::Round(($disk.Used / $disk.Total) * 100, 0)
        $diskValueLbl.Text = "$diskPercent%"

        $uptime = (Get-Date) - $os.LastBootUpTime
        $cpuDetailLbl.Text = "Current: $cpu% | Cores: $($proc.NumberOfCores)"
        $ramDetailLbl.Text = "Used: $([math]::Round($ram.Used, 1)) GB`nTotal: $([math]::Round($ram.Total, 1)) GB`nFree: $([math]::Round($ram.Free, 1)) GB"
        $diskDetailLbl.Text = "Free: $($disk.Free) GB`nTotal: $($disk.Total) GB`nUsed: $($disk.Used) GB"
        $sysInfoLbl.Text = "Windows: $($os.Caption) | Uptime: $($uptime.Days)d $($uptime.Hours)h $($uptime.Minutes)m | CPU: $($proc.Name)"
    } catch {
        Write-Log "Dashboard refresh error: $_"
    }
}

$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 5000
$timer.Add_Tick({ Refresh-Dashboard })
$timer.Start()
Refresh-Dashboard

# ======================================================
# CLEANUP TAB - PREMIUM BUTTONS
# ======================================================
$cleanupScroll = New-Object System.Windows.Forms.Panel
$cleanupScroll.AutoScroll = $true
$cleanupScroll.Dock = "Fill"
$cleanupScroll.BackColor = $Global:DeepDark
$tabCleanup.Controls.Add($cleanupScroll)

$cleanupContent = New-Object System.Windows.Forms.Panel
$cleanupContent.AutoSize = $true
$cleanupContent.AutoSizeMode = "GrowAndShrink"
$cleanupContent.BackColor = $Global:DeepDark
$cleanupContent.Padding = New-Object System.Windows.Forms.Padding(30)
$cleanupScroll.Controls.Add($cleanupContent)

$cleanTitle = New-Object System.Windows.Forms.Label
$cleanTitle.Text = "SYSTEM CLEANUP"
$cleanTitle.Font = New-Object System.Drawing.Font("Segoe UI", 18, [System.Drawing.FontStyle]::Bold)
$cleanTitle.Location = New-Object System.Drawing.Point(30, 30)
$cleanTitle.Size = New-Object System.Drawing.Size(500, 40)
$cleanTitle.ForeColor = [System.Drawing.Color]::White
$cleanupContent.Controls.Add($cleanTitle)

$cleanDesc = New-Object System.Windows.Forms.Label
$cleanDesc.Text = "Select cleanup operations to optimize your system"
$cleanDesc.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Regular)
$cleanDesc.Location = New-Object System.Drawing.Point(30, 75)
$cleanDesc.Size = New-Object System.Drawing.Size(600, 25)
$cleanDesc.ForeColor = [System.Drawing.Color]::FromArgb(150, 170, 200)
$cleanupContent.Controls.Add($cleanDesc)

$btnTemp = New-Object System.Windows.Forms.Button
$btnTemp.Text = "CLEAN TEMP FILES"
$btnTemp.Location = New-Object System.Drawing.Point(30, 130)
$btnTemp.Size = New-Object System.Drawing.Size(320, 70)
$btnTemp.BackColor = $Global:PrimaryBlue
$btnTemp.Radius = 25
$btnTemp.Add_Click({
    Write-Log "Starting temporary files cleanup..."
    Clean-Temp
    Write-Log "Temporary files cleanup completed"
    $btnTemp.BackColor = $Global:DarkBlue
    Start-Sleep -Milliseconds 200
    $btnTemp.BackColor = $Global:PrimaryBlue
})
$cleanupContent.Controls.Add($btnTemp)

$lblTempDesc = New-Object System.Windows.Forms.Label
$lblTempDesc.Text = "Remove temporary system files and cache data"
$lblTempDesc.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Regular)
$lblTempDesc.Location = New-Object System.Drawing.Point(30, 205)
$lblTempDesc.Size = New-Object System.Drawing.Size(320, 40)
$lblTempDesc.ForeColor = [System.Drawing.Color]::FromArgb(120, 140, 170)
$lblTempDesc.AutoSize = $false
$cleanupContent.Controls.Add($lblTempDesc)

$btnBrowsers = New-Object System.Windows.Forms.Button
$btnBrowsers.Text = "CLEAN BROWSER CACHE"
$btnBrowsers.Location = New-Object System.Drawing.Point(385, 130)
$btnBrowsers.Size = New-Object System.Drawing.Size(320, 70)
$btnBrowsers.BackColor = $Global:PrimaryBlue
$btnBrowsers.Radius = 25
$btnBrowsers.Add_Click({
    Write-Log "Starting browser cache cleanup..."
    Clean-Browsers
    Write-Log "Browser cache cleanup completed"
    $btnBrowsers.BackColor = $Global:DarkBlue
    Start-Sleep -Milliseconds 200
    $btnBrowsers.BackColor = $Global:PrimaryBlue
})
$cleanupContent.Controls.Add($btnBrowsers)

$lblBrowserDesc = New-Object System.Windows.Forms.Label
$lblBrowserDesc.Text = "Clear browser caches, cookies, and history files"
$lblBrowserDesc.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Regular)
$lblBrowserDesc.Location = New-Object System.Drawing.Point(385, 205)
$lblBrowserDesc.Size = New-Object System.Drawing.Size(320, 40)
$lblBrowserDesc.ForeColor = [System.Drawing.Color]::FromArgb(120, 140, 170)
$lblBrowserDesc.AutoSize = $false
$cleanupContent.Controls.Add($lblBrowserDesc)

$btnDeep = New-Object System.Windows.Forms.Button
$btnDeep.Text = "DEEP DISK CLEAN"
$btnDeep.Location = New-Object System.Drawing.Point(740, 130)
$btnDeep.Size = New-Object System.Drawing.Size(320, 70)
$btnDeep.BackColor = $Global:AccentOrange
$btnDeep.Radius = 25
$btnDeep.Add_Click({
    Write-Log "Starting deep disk cleanup..."
    Deep-Clean
    Write-Log "Deep disk cleanup completed"
    $btnDeep.BackColor = [System.Drawing.Color]::FromArgb(200, 80, 10)
    Start-Sleep -Milliseconds 200
    $btnDeep.BackColor = $Global:AccentOrange
})
$cleanupContent.Controls.Add($btnDeep)

$lblDeepDesc = New-Object System.Windows.Forms.Label
$lblDeepDesc.Text = "Comprehensive system-wide cleanup operation"
$lblDeepDesc.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Regular)
$lblDeepDesc.Location = New-Object System.Drawing.Point(740, 205)
$lblDeepDesc.Size = New-Object System.Drawing.Size(320, 40)
$lblDeepDesc.ForeColor = [System.Drawing.Color]::FromArgb(120, 140, 170)
$lblDeepDesc.AutoSize = $false
$cleanupContent.Controls.Add($lblDeepDesc)

# ======================================================
# REPAIRS TAB
# ======================================================
$repairScroll = New-Object System.Windows.Forms.Panel
$repairScroll.AutoScroll = $true
$repairScroll.Dock = "Fill"
$repairScroll.BackColor = $Global:DeepDark
$tabRepairs.Controls.Add($repairScroll)

$repairContent = New-Object System.Windows.Forms.Panel
$repairContent.AutoSize = $true
$repairContent.AutoSizeMode = "GrowAndShrink"
$repairContent.BackColor = $Global:DeepDark
$repairContent.Padding = New-Object System.Windows.Forms.Padding(30)
$repairScroll.Controls.Add($repairContent)

$repairTitle = New-Object System.Windows.Forms.Label
$repairTitle.Text = "SYSTEM REPAIRS"
$repairTitle.Font = New-Object System.Drawing.Font("Segoe UI", 18, [System.Drawing.FontStyle]::Bold)
$repairTitle.Location = New-Object System.Drawing.Point(30, 30)
$repairTitle.Size = New-Object System.Drawing.Size(500, 40)
$repairTitle.ForeColor = [System.Drawing.Color]::White
$repairContent.Controls.Add($repairTitle)

$repairDesc = New-Object System.Windows.Forms.Label
$repairDesc.Text = "Advanced system repair and optimization tools"
$repairDesc.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Regular)
$repairDesc.Location = New-Object System.Drawing.Point(30, 75)
$repairDesc.Size = New-Object System.Drawing.Size(600, 25)
$repairDesc.ForeColor = [System.Drawing.Color]::FromArgb(150, 170, 200)
$repairContent.Controls.Add($repairDesc)

$btnSFC = New-Object System.Windows.Forms.Button
$btnSFC.Text = "RUN SFC SCAN"
$btnSFC.Location = New-Object System.Drawing.Point(30, 130)
$btnSFC.Size = New-Object System.Drawing.Size(650, 70)
$btnSFC.BackColor = $Global:PrimaryBlue
$btnSFC.Radius = 25
$btnSFC.Add_Click({
    Write-Log "Starting SFC scan (this may take several minutes)..."
    Run-SFC
    Write-Log "SFC scan completed"
    $btnSFC.BackColor = $Global:DarkBlue
    Start-Sleep -Milliseconds 200
    $btnSFC.BackColor = $Global:PrimaryBlue
})
$repairContent.Controls.Add($btnSFC)

$lblSFCDesc = New-Object System.Windows.Forms.Label
$lblSFCDesc.Text = "Scan and repair corrupted Windows system files automatically"
$lblSFCDesc.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Regular)
$lblSFCDesc.Location = New-Object System.Drawing.Point(30, 205)
$lblSFCDesc.Size = New-Object System.Drawing.Size(650, 40)
$lblSFCDesc.ForeColor = [System.Drawing.Color]::FromArgb(120, 140, 170)
$lblSFCDesc.AutoSize = $false
$repairContent.Controls.Add($lblSFCDesc)

$btnDISM = New-Object System.Windows.Forms.Button
$btnDISM.Text = "RUN DISM REPAIR"
$btnDISM.Location = New-Object System.Drawing.Point(30, 275)
$btnDISM.Size = New-Object System.Drawing.Size(650, 70)
$btnDISM.BackColor = [System.Drawing.Color]::FromArgb(255, 69, 58)
$btnDISM.Radius = 25
$btnDISM.Add_Click({
    Write-Log "Starting DISM repair (this may take several minutes)..."
    Run-DISM
    Write-Log "DISM repair completed"
    $btnDISM.BackColor = [System.Drawing.Color]::FromArgb(200, 40, 30)
    Start-Sleep -Milliseconds 200
    $btnDISM.BackColor = [System.Drawing.Color]::FromArgb(255, 69, 58)
})
$repairContent.Controls.Add($btnDISM)

$lblDISMDesc = New-Object System.Windows.Forms.Label
$lblDISMDesc.Text = "Repair Windows image and component store for stability"
$lblDISMDesc.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Regular)
$lblDISMDesc.Location = New-Object System.Drawing.Point(30, 350)
$lblDISMDesc.Size = New-Object System.Drawing.Size(650, 40)
$lblDISMDesc.ForeColor = [System.Drawing.Color]::FromArgb(120, 140, 170)
$lblDISMDesc.AutoSize = $false
$repairContent.Controls.Add($lblDISMDesc)

# ======================================================
# APPS TAB
# ======================================================
$appsScroll = New-Object System.Windows.Forms.Panel
$appsScroll.AutoScroll = $true
$appsScroll.Dock = "Fill"
$appsScroll.BackColor = $Global:DeepDark
$tabApps.Controls.Add($appsScroll)

$appsContent = New-Object System.Windows.Forms.Panel
$appsContent.AutoSize = $true
$appsContent.AutoSizeMode = "GrowAndShrink"
$appsContent.BackColor = $Global:DeepDark
$appsContent.Padding = New-Object System.Windows.Forms.Padding(30)
$appsScroll.Controls.Add($appsContent)

$appsTitle = New-Object System.Windows.Forms.Label
$appsTitle.Text = "APPLICATION MANAGER"
$appsTitle.Font = New-Object System.Drawing.Font("Segoe UI", 18, [System.Drawing.FontStyle]::Bold)
$appsTitle.Location = New-Object System.Drawing.Point(30, 30)
$appsTitle.Size = New-Object System.Drawing.Size(500, 40)
$appsTitle.ForeColor = [System.Drawing.Color]::White
$appsContent.Controls.Add($appsTitle)

$appsDesc = New-Object System.Windows.Forms.Label
$appsDesc.Text = "Keep your applications updated and secure"
$appsDesc.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Regular)
$appsDesc.Location = New-Object System.Drawing.Point(30, 75)
$appsDesc.Size = New-Object System.Drawing.Size(600, 25)
$appsDesc.ForeColor = [System.Drawing.Color]::FromArgb(150, 170, 200)
$appsContent.Controls.Add($appsDesc)

$btnUpdate = New-Object System.Windows.Forms.Button
$btnUpdate.Text = "UPDATE ALL APPLICATIONS"
$btnUpdate.Location = New-Object System.Drawing.Point(30, 130)
$btnUpdate.Size = New-Object System.Drawing.Size(1060, 70)
$btnUpdate.BackColor = $Global:AccentGreen
$btnUpdate.Radius = 25
$btnUpdate.Add_Click({
    Write-Log "Checking for application updates..."
    Update-Apps
    Write-Log "Application update check completed"
    $btnUpdate.BackColor = [System.Drawing.Color]::FromArgb(20, 150, 60)
    Start-Sleep -Milliseconds 200
    $btnUpdate.BackColor = $Global:AccentGreen
})
$appsContent.Controls.Add($btnUpdate)

$lblUpdateDesc = New-Object System.Windows.Forms.Label
$lblUpdateDesc.Text = "Automatically check and install the latest updates for all installed applications"
$lblUpdateDesc.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Regular)
$lblUpdateDesc.Location = New-Object System.Drawing.Point(30, 205)
$lblUpdateDesc.Size = New-Object System.Drawing.Size(1060, 40)
$lblUpdateDesc.ForeColor = [System.Drawing.Color]::FromArgb(120, 140, 170)
$lblUpdateDesc.AutoSize = $false
$appsContent.Controls.Add($lblUpdateDesc)

# ======================================================
# ADVANCED TAB
# ======================================================
$advScroll = New-Object System.Windows.Forms.Panel
$advScroll.AutoScroll = $true
$advScroll.Dock = "Fill"
$advScroll.BackColor = $Global:DeepDark
$tabAdvanced.Controls.Add($advScroll)

$advContent = New-Object System.Windows.Forms.Panel
$advContent.AutoSize = $true
$advContent.AutoSizeMode = "GrowAndShrink"
$advContent.BackColor = $Global:DeepDark
$advContent.Padding = New-Object System.Windows.Forms.Padding(30)
$advScroll.Controls.Add($advContent)

$advTitle = New-Object System.Windows.Forms.Label
$advTitle.Text = "ADVANCED TOOLS"
$advTitle.Font = New-Object System.Drawing.Font("Segoe UI", 18, [System.Drawing.FontStyle]::Bold)
$advTitle.Location = New-Object System.Drawing.Point(30, 30)
$advTitle.Size = New-Object System.Drawing.Size(500, 40)
$advTitle.ForeColor = [System.Drawing.Color]::White
$advContent.Controls.Add($advTitle)

$advDesc = New-Object System.Windows.Forms.Label
$advDesc.Text = "Power user tools for advanced system optimization"
$advDesc.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Regular)
$advDesc.Location = New-Object System.Drawing.Point(30, 75)
$advDesc.Size = New-Object System.Drawing.Size(600, 25)
$advDesc.ForeColor = [System.Drawing.Color]::FromArgb(150, 170, 200)
$advContent.Controls.Add($advDesc)

$btnSSD = New-Object System.Windows.Forms.Button
$btnSSD.Text = "OPTIMIZE SSD"
$btnSSD.Location = New-Object System.Drawing.Point(30, 130)
$btnSSD.Size = New-Object System.Drawing.Size(320, 70)
$btnSSD.BackColor = $Global:PrimaryBlue
$btnSSD.Radius = 25
$btnSSD.Add_Click({
    Write-Log "Starting SSD optimization..."
    Optimize-SSD
    Write-Log "SSD optimization completed"
    $btnSSD.BackColor = $Global:DarkBlue
    Start-Sleep -Milliseconds 200
    $btnSSD.BackColor = $Global:PrimaryBlue
})
$advContent.Controls.Add($btnSSD)

$lblSSDDesc = New-Object System.Windows.Forms.Label
$lblSSDDesc.Text = "Optimize SSD performance and lifespan"
$lblSSDDesc.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Regular)
$lblSSDDesc.Location = New-Object System.Drawing.Point(30, 205)
$lblSSDDesc.Size = New-Object System.Drawing.Size(320, 40)
$lblSSDDesc.ForeColor = [System.Drawing.Color]::FromArgb(120, 140, 170)
$lblSSDDesc.AutoSize = $false
$advContent.Controls.Add($lblSSDDesc)

$btnDuplicates = New-Object System.Windows.Forms.Button
$btnDuplicates.Text = "FIND DUPLICATES"
$btnDuplicates.Location = New-Object System.Drawing.Point(385, 130)
$btnDuplicates.Size = New-Object System.Drawing.Size(320, 70)
$btnDuplicates.BackColor = $Global:PrimaryBlue
$btnDuplicates.Radius = 25
$btnDuplicates.Add_Click({
    Write-Log "Scanning for duplicate files..."
    Find-DuplicateFiles
    Write-Log "Duplicate file search completed"
    $btnDuplicates.BackColor = $Global:DarkBlue
    Start-Sleep -Milliseconds 200
    $btnDuplicates.BackColor = $Global:PrimaryBlue
})
$advContent.Controls.Add($btnDuplicates)

$lblDupDesc = New-Object System.Windows.Forms.Label
$lblDupDesc.Text = "Scan and remove redundant files"
$lblDupDesc.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Regular)
$lblDupDesc.Location = New-Object System.Drawing.Point(385, 205)
$lblDupDesc.Size = New-Object System.Drawing.Size(320, 40)
$lblDupDesc.ForeColor = [System.Drawing.Color]::FromArgb(120, 140, 170)
$lblDupDesc.AutoSize = $false
$advContent.Controls.Add($lblDupDesc)

$btnReport = New-Object System.Windows.Forms.Button
$btnReport.Text = "SYSTEM REPORT"
$btnReport.Location = New-Object System.Drawing.Point(740, 130)
$btnReport.Size = New-Object System.Drawing.Size(320, 70)
$btnReport.BackColor = $Global:PrimaryBlue
$btnReport.Radius = 25
$btnReport.Add_Click({
    Write-Log "Generating comprehensive system report..."
    Export-SystemReport
    Write-Log "System report generated and exported"
    $btnReport.BackColor = $Global:DarkBlue
    Start-Sleep -Milliseconds 200
    $btnReport.BackColor = $Global:PrimaryBlue
})
$advContent.Controls.Add($btnReport)

$lblReportDesc = New-Object System.Windows.Forms.Label
$lblReportDesc.Text = "Export detailed diagnostics report"
$lblReportDesc.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Regular)
$lblReportDesc.Location = New-Object System.Drawing.Point(740, 205)
$lblReportDesc.Size = New-Object System.Drawing.Size(320, 40)
$lblReportDesc.ForeColor = [System.Drawing.Color]::FromArgb(120, 140, 170)
$lblReportDesc.AutoSize = $false
$advContent.Controls.Add($lblReportDesc)

# ======================================================
# PREMIUM LOG BOX
# ======================================================
$logPanel = New-Object System.Windows.Forms.Panel
$logPanel.Size = New-Object System.Drawing.Size(1360, 80)
$logPanel.Location = New-Object System.Drawing.Point(20, 900)
$logPanel.BackColor = $Global:CardDark
$logPanel.Dock = "Bottom"

$logTopBorder = New-Object System.Windows.Forms.Panel
$logTopBorder.Height = 1
$logTopBorder.Dock = "Top"
$logTopBorder.BackColor = $Global:BorderColor
$logPanel.Controls.Add($logTopBorder)

$lblLogTitle = New-Object System.Windows.Forms.Label
$lblLogTitle.Text = "  ACTIVITY LOG"
$lblLogTitle.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$lblLogTitle.Location = New-Object System.Drawing.Point(10, 8)
$lblLogTitle.Size = New-Object System.Drawing.Size(200, 20)
$lblLogTitle.ForeColor = [System.Drawing.Color]::FromArgb(100, 150, 220)
$logPanel.Controls.Add($lblLogTitle)

$Global:LogBox = New-Object System.Windows.Forms.TextBox
$Global:LogBox.Multiline = $true
$Global:LogBox.ScrollBars = "Vertical"
$Global:LogBox.ReadOnly = $true
$Global:LogBox.Font = New-Object System.Drawing.Font("Consolas", 9)
$Global:LogBox.Size = New-Object System.Drawing.Size(1340, 50)
$Global:LogBox.Location = New-Object System.Drawing.Point(10, 28)
$Global:LogBox.BackColor = $Global:DeepDark
$Global:LogBox.ForeColor = [System.Drawing.Color]::FromArgb(100, 200, 255)
$Global:LogBox.BorderStyle = "None"
$logPanel.Controls.Add($Global:LogBox)

$mainPanel.Controls.Add($logPanel)

# ======================================================
# START APPLICATION
# ======================================================
Write-Log "⬤ KODAL Cleaner Premium Edition initialized"
Write-Log "⬤ All systems operational and ready"
[void]$form.ShowDialog()

# ================================
# CleanPC_Config.ps1
# Configuration settings for CleanPC
# ================================

$Global:CleanPCConfig = @{
    # Cleanup Settings
    Cleanup = @{
        DeleteDownloadsOlderThanDays = 90
        ClearRecycleBin = $true
        ClearThumbnailCache = $true
        ClearErrorReports = $true
        ClearWindowsUpdateCache = $true
    }

    # Browser Settings
    Browsers = @{
        ClearChrome = $true
        ClearEdge = $true
        ClearFirefox = $true
        ClearBrave = $true
        ClearOpera = $true
    }

    # Optimization Settings
    Optimization = @{
        DisableStartupApps = $true
        OptimizeServices = $true
        SetHighPerformancePower = $false
        OptimizeVisualEffects = $false
        DefragmentDrives = $false
    }

    # Privacy Settings
    Privacy = @{
        DisableTelemetry = $true
        ClearActivityHistory = $true
        ClearRecentItems = $true
    }

    # Safety Settings
    Safety = @{
        CreateRestorePoint = $true
        RestorePointDescription = "CleanPC Automatic Backup"
        RequireAdminConfirmation = $true
    }

    # Bloatware to Remove
    Bloatware = @(
        "Microsoft.BingNews",
        "Microsoft.BingWeather",
        "Microsoft.GetHelp",
        "Microsoft.Getstarted",
        "Microsoft.Microsoft3DViewer",
        "Microsoft.MicrosoftSolitaireCollection",
        "Microsoft.MixedReality.Portal",
        "Microsoft.People",
        "Microsoft.SkypeApp",
        "Microsoft.Xbox.TCUI",
        "Microsoft.XboxApp",
        "Microsoft.XboxGameOverlay",
        "Microsoft.XboxGamingOverlay",
        "Microsoft.ZuneMusic",
        "Microsoft.ZuneVideo",
        "king.com.CandyCrushSaga",
        "king.com.CandyCrushSodaSaga"
    )

    # Services to Disable (for optimization)
    ServicesToDisable = @(
        @{Name="DiagTrack"; Display="Telemetry"},
        @{Name="dmwappushservice"; Display="WAP Push"},
        @{Name="WSearch"; Display="Windows Search (Optional)"}
    )

    # Protected Items (Never Clean)
    ProtectedPaths = @(
        "$env:USERPROFILE\Documents",
        "$env:USERPROFILE\Pictures",
        "$env:USERPROFILE\Videos",
        "$env:USERPROFILE\Music",
        "$env:USERPROFILE\Desktop"
    )

    # Logging Settings
    Logging = @{
        EnableLogging = $true
        LogPath = "$env:TEMP\CleanPC_Logs"
        MaxLogSizeMB = 10
        KeepLogsForDays = 30
    }

    # Update Settings
    Updates = @{
        AutoUpdateApps = $false
        CheckForUpdates = $true
        UpdateWinget = $true
    }
}

# Function to save configuration
function Save-CleanPCConfig {
    param([string]$configPath = "$env:APPDATA\CleanPC\config.json")

    try {
        $dir = Split-Path $configPath
        if (-not (Test-Path $dir)) {
            New-Item -Path $dir -ItemType Directory -Force | Out-Null
        }

        $Global:CleanPCConfig | ConvertTo-Json -Depth 10 | Set-Content -Path $configPath
        Write-Host "Configuration saved to: $configPath"
    } catch {
        Write-Host "Error saving configuration: $($_.Exception.Message)"
    }
}

# Function to load configuration
function Load-CleanPCConfig {
    param([string]$configPath = "$env:APPDATA\CleanPC\config.json")

    try {
        if (Test-Path $configPath) {
            $Global:CleanPCConfig = Get-Content -Path $configPath | ConvertFrom-Json -AsHashtable
            Write-Host "Configuration loaded from: $configPath"
        } else {
            Write-Host "No configuration file found. Using defaults."
        }
    } catch {
        Write-Host "Error loading configuration: $($_.Exception.Message)"
        Write-Host "Using default configuration."
    }
}

Export-ModuleMember -Function *
Export-ModuleMember -Variable CleanPCConfig

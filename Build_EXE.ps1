# ================================
# Build_EXE.ps1
# Builds KODAL Cleaner (CLI & GUI) executables
# ================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "KODAL Cleaner EXE Builder" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Ensure PS2EXE is available
$ps2exeInstalled = Get-Module -ListAvailable -Name ps2exe
if (-not $ps2exeInstalled) {
    Write-Host "PS2EXE module not found. Installing..." -ForegroundColor Yellow
    try {
        Install-Module ps2exe -Scope CurrentUser -Force -AllowClobber
        Write-Host "PS2EXE installed successfully!" -ForegroundColor Green
    } catch {
        Write-Host "❌ Error installing PS2EXE: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "Please install manually using:" -ForegroundColor Yellow
        Write-Host "Install-Module ps2exe -Scope CurrentUser" -ForegroundColor White
        exit
    }
}
Import-Module ps2exe -ErrorAction SilentlyContinue

$scriptPath = $PSScriptRoot
$outputPath = "$scriptPath\build"

# Create / reset output folder
if (Test-Path $outputPath) {
    Remove-Item $outputPath -Recurse -Force
}
New-Item -Path $outputPath -ItemType Directory | Out-Null

Write-Host "Select build type:" -ForegroundColor Yellow
Write-Host "1. CLI Version (console-based)"
Write-Host "2. GUI Version (no console)"
Write-Host "3. Build Both"
Write-Host ""
$choice = Read-Host "Enter your choice (1-3)"

# Create launcher scripts
$launcherCLI = @"
# KODAL Cleaner CLI Launcher
`$scriptPath = `$PSScriptRoot
. "`$scriptPath\CleanPC_Core.ps1"
. "`$scriptPath\CleanPC_Config.ps1"
. "`$scriptPath\CleanPC_Advanced.ps1"
. "`$scriptPath\CleanPC_Scheduler.ps1"
. "`$scriptPath\CleanPC_CLI.ps1"
"@

$launcherGUI = @"
# KODAL Cleaner GUI Launcher
`$scriptPath = `$PSScriptRoot
. "`$scriptPath\CleanPC_Core.ps1"
. "`$scriptPath\CleanPC_Config.ps1"
. "`$scriptPath\CleanPC_Advanced.ps1"
. "`$scriptPath\CleanPC_Scheduler.ps1"
. "`$scriptPath\CleanPC_GUI.ps1"
"@

$launcherCLIPath = "$scriptPath\KODAL_Cleaner_CLI_Launcher.ps1"
$launcherGUIPath = "$scriptPath\KODAL_Cleaner_GUI_Launcher.ps1"

Set-Content -Path $launcherCLIPath -Value $launcherCLI
Set-Content -Path $launcherGUIPath -Value $launcherGUI

# Function to build exe
function Build-Executable {
    param (
        [string]$inputFile,
        [string]$outputFile,
        [switch]$noConsole
    )

    try {
        $args = @{
            InputFile  = $inputFile
            OutputFile = $outputFile
            Title      = "KODAL Cleaner"
            Company    = "KODAL Software"
            Product    = "KODAL Cleaner"
            Description= "Professional PC Cleaning & Optimization Suite"
            Version    = "1.0.0.0"
            RequireAdmin = $true
            NoError = $true
        }

        if ($noConsole) {
            $args["NoConsole"] = $true
        }

        Invoke-PS2EXE @args
        Write-Host "✅ Built: $outputFile" -ForegroundColor Green
    }
    catch {
        Write-Host "❌ Build failed: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Build process
if ($choice -eq "1" -or $choice -eq "3") {
    Write-Host "🔨 Building CLI executable..." -ForegroundColor Cyan
    Build-Executable -inputFile $launcherCLIPath -outputFile "$outputPath\KODAL_Cleaner_CLI.exe"
}

if ($choice -eq "2" -or $choice -eq "3") {
    Write-Host "🪟 Building GUI executable..." -ForegroundColor Cyan
    Build-Executable -inputFile $launcherGUIPath -outputFile "$outputPath\KODAL_Cleaner_GUI.exe" -noConsole
}

# Copy dependency modules
Write-Host ""
Write-Host "📦 Copying required modules..." -ForegroundColor Yellow

$filesToCopy = @(
    "CleanPC_Core.ps1",
    "CleanPC_Config.ps1",
    "CleanPC_Advanced.ps1",
    "CleanPC_Scheduler.ps1",
    "README_CLEANPC.md",
    "QUICKSTART.md"
)

foreach ($file in $filesToCopy) {
    $src = Join-Path $scriptPath $file
    if (Test-Path $src) {
        Copy-Item $src -Destination $outputPath -Force
    }
}

Write-Host "✅ All files copied to build folder" -ForegroundColor Green
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "BUILD COMPLETE" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "📁 Output Folder: $outputPath" -ForegroundColor Cyan
Write-Host ""

$open = Read-Host "Open build folder? (Y/N)"
if ($open -eq "Y" -or $open -eq "y") {
    Start-Process explorer.exe -ArgumentList $outputPath
}

Write-Host ""
Write-Host "Press any key to exit..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

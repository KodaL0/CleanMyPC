# ================================
# Test_CleanPC.ps1
# Test CleanPC functionality before building
# ================================

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "CleanPC System Test" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$testResults = @()
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path

function Test-FileExists {
    param([string]$file, [string]$description)

    $path = Join-Path $scriptPath $file
    $exists = Test-Path $path

    $testResults += [PSCustomObject]@{
        Test = $description
        Status = if ($exists) { "PASS" } else { "FAIL" }
        Details = if ($exists) { "Found" } else { "Missing: $file" }
    }

    if ($exists) {
        Write-Host "[PASS]" -ForegroundColor Green -NoNewline
        Write-Host " $description" -ForegroundColor White
    } else {
        Write-Host "[FAIL]" -ForegroundColor Red -NoNewline
        Write-Host " $description - Missing: $file" -ForegroundColor Yellow
    }
}

function Test-ModuleImport {
    param([string]$file, [string]$description)

    $path = Join-Path $scriptPath $file

    try {
        . $path
        $testResults += [PSCustomObject]@{
            Test = $description
            Status = "PASS"
            Details = "Module loaded successfully"
        }
        Write-Host "[PASS]" -ForegroundColor Green -NoNewline
        Write-Host " $description" -ForegroundColor White
        return $true
    } catch {
        $testResults += [PSCustomObject]@{
            Test = $description
            Status = "FAIL"
            Details = $_.Exception.Message
        }
        Write-Host "[FAIL]" -ForegroundColor Red -NoNewline
        Write-Host " $description - $($_.Exception.Message)" -ForegroundColor Yellow
        return $false
    }
}

function Test-AdminRights {
    $currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    $isAdmin = $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

    $testResults += [PSCustomObject]@{
        Test = "Administrator Rights"
        Status = if ($isAdmin) { "PASS" } else { "WARNING" }
        Details = if ($isAdmin) { "Running with admin rights" } else { "Not running as admin (required for full functionality)" }
    }

    if ($isAdmin) {
        Write-Host "[PASS]" -ForegroundColor Green -NoNewline
        Write-Host " Administrator Rights" -ForegroundColor White
    } else {
        Write-Host "[WARN]" -ForegroundColor Yellow -NoNewline
        Write-Host " Administrator Rights - Not running as admin" -ForegroundColor Yellow
    }

    return $isAdmin
}

function Test-PowerShellVersion {
    $version = $PSVersionTable.PSVersion

    $isCompatible = $version.Major -ge 5

    $testResults += [PSCustomObject]@{
        Test = "PowerShell Version"
        Status = if ($isCompatible) { "PASS" } else { "FAIL" }
        Details = "Version: $($version.Major).$($version.Minor)"
    }

    if ($isCompatible) {
        Write-Host "[PASS]" -ForegroundColor Green -NoNewline
        Write-Host " PowerShell Version: $($version.Major).$($version.Minor)" -ForegroundColor White
    } else {
        Write-Host "[FAIL]" -ForegroundColor Red -NoNewline
        Write-Host " PowerShell Version: $($version.Major).$($version.Minor) - Requires 5.1+" -ForegroundColor Yellow
    }

    return $isCompatible
}

function Test-DiskSpace {
    $systemDrive = Get-PSDrive C

    $freeSpaceGB = [math]::Round($systemDrive.Free / 1GB, 2)
    $hasSufficientSpace = $freeSpaceGB -gt 5

    $testResults += [PSCustomObject]@{
        Test = "Disk Space"
        Status = if ($hasSufficientSpace) { "PASS" } else { "WARNING" }
        Details = "Free: $freeSpaceGB GB"
    }

    if ($hasSufficientSpace) {
        Write-Host "[PASS]" -ForegroundColor Green -NoNewline
        Write-Host " Disk Space: $freeSpaceGB GB available" -ForegroundColor White
    } else {
        Write-Host "[WARN]" -ForegroundColor Yellow -NoNewline
        Write-Host " Disk Space: Only $freeSpaceGB GB available" -ForegroundColor Yellow
    }

    return $hasSufficientSpace
}

function Test-WingetAvailable {
    try {
        $null = winget --version
        $testResults += [PSCustomObject]@{
            Test = "Winget Package Manager"
            Status = "PASS"
            Details = "Winget is installed"
        }
        Write-Host "[PASS]" -ForegroundColor Green -NoNewline
        Write-Host " Winget Package Manager" -ForegroundColor White
        return $true
    } catch {
        $testResults += [PSCustomObject]@{
            Test = "Winget Package Manager"
            Status = "WARNING"
            Details = "Winget not found (app management features will be limited)"
        }
        Write-Host "[WARN]" -ForegroundColor Yellow -NoNewline
        Write-Host " Winget Package Manager - Not installed" -ForegroundColor Yellow
        return $false
    }
}

function Test-Function {
    param([string]$functionName)

    $exists = Get-Command $functionName -ErrorAction SilentlyContinue

    if ($exists) {
        $testResults += [PSCustomObject]@{
            Test = "Function: $functionName"
            Status = "PASS"
            Details = "Function is available"
        }
        Write-Host "[PASS]" -ForegroundColor Green -NoNewline
        Write-Host " Function: $functionName" -ForegroundColor White
        return $true
    } else {
        $testResults += [PSCustomObject]@{
            Test = "Function: $functionName"
            Status = "FAIL"
            Details = "Function not found"
        }
        Write-Host "[FAIL]" -ForegroundColor Red -NoNewline
        Write-Host " Function: $functionName" -ForegroundColor Yellow
        return $false
    }
}

Write-Host "SYSTEM REQUIREMENTS:" -ForegroundColor Yellow
Write-Host ""

Test-PowerShellVersion
Test-AdminRights
Test-DiskSpace
Test-WingetAvailable

Write-Host ""
Write-Host "FILE INTEGRITY:" -ForegroundColor Yellow
Write-Host ""

Test-FileExists "CleanPC_Core.ps1" "Core Module"
Test-FileExists "CleanPC_Config.ps1" "Configuration Module"
Test-FileExists "CleanPC_CLI.ps1" "CLI Interface"
Test-FileExists "CleanPC_Scheduler.ps1" "Scheduler Module"
Test-FileExists "CleanPC_Advanced.ps1" "Advanced Features"
Test-FileExists "Build_EXE.ps1" "EXE Builder"
Test-FileExists "README_CLEANPC.md" "Documentation"
Test-FileExists "QUICKSTART.md" "Quick Start Guide"

Write-Host ""
Write-Host "MODULE LOADING:" -ForegroundColor Yellow
Write-Host ""

$coreLoaded = Test-ModuleImport "CleanPC_Core.ps1" "Core Module Import"
$configLoaded = Test-ModuleImport "CleanPC_Config.ps1" "Config Module Import"
$advancedLoaded = Test-ModuleImport "CleanPC_Advanced.ps1" "Advanced Module Import"

if ($coreLoaded) {
    Write-Host ""
    Write-Host "FUNCTION AVAILABILITY:" -ForegroundColor Yellow
    Write-Host ""

    Test-Function "Clean-Temp"
    Test-Function "Clean-Browsers"
    Test-Function "Run-SFC"
    Test-Function "Run-DISM"
    Test-Function "Optimize-Startup"
    Test-Function "Run-QuickClean"
    Test-Function "Run-DeepClean"
    Test-Function "Run-SystemRepair"
    Test-Function "Run-FullOptimization"
    Test-Function "Run-CompleteMaintenace"
}

if ($advancedLoaded) {
    Test-Function "Find-DuplicateFiles"
    Test-Function "Optimize-SSD"
    Test-Function "Export-SystemReport"
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "TEST SUMMARY" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$passCount = ($testResults | Where-Object { $_.Status -eq "PASS" }).Count
$failCount = ($testResults | Where-Object { $_.Status -eq "FAIL" }).Count
$warnCount = ($testResults | Where-Object { $_.Status -eq "WARNING" }).Count
$totalCount = $testResults.Count

Write-Host "Total Tests: $totalCount" -ForegroundColor White
Write-Host "Passed: $passCount" -ForegroundColor Green
Write-Host "Failed: $failCount" -ForegroundColor Red
Write-Host "Warnings: $warnCount" -ForegroundColor Yellow

Write-Host ""

if ($failCount -eq 0) {
    Write-Host "✓ ALL TESTS PASSED!" -ForegroundColor Green
    Write-Host ""
    Write-Host "CleanPC is ready to use!" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "1. Run: .\CleanPC_CLI.ps1 (to start the CLI)" -ForegroundColor White
    Write-Host "2. Run: .\Build_EXE.ps1 (to create executable)" -ForegroundColor White
} else {
    Write-Host "✗ SOME TESTS FAILED" -ForegroundColor Red
    Write-Host ""
    Write-Host "Please fix the issues above before proceeding." -ForegroundColor Yellow
}

Write-Host ""

$exportPath = "$scriptPath\CleanPC_TestResults_$(Get-Date -Format 'yyyyMMdd_HHmmss').csv"
$testResults | Export-Csv -Path $exportPath -NoTypeInformation
Write-Host "Full test report saved to: $exportPath" -ForegroundColor Cyan

Write-Host ""
Write-Host "Press any key to exit..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

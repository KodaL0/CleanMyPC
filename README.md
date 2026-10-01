# CleanMyPC

A Windows PowerShell maintenance toolkit for transparent cleanup, repair, diagnostics, and guided maintenance workflows on Windows 10 and 11.

## What it can do

- Clean temporary files, application caches, browser caches, logs, crash reports, activity history, and recent-item data.
- Run Windows repair tools including SFC, DISM, network-stack reset, and Windows Store cache reset.
- Manage selected startup, service, power, visual, privacy, and application-maintenance settings.
- Update applications through Winget and remove configured bloatware packages.
- Provide both a command-line menu and a WinForms GUI entry point.

## Requirements

- Windows 10 or Windows 11
- PowerShell 5.1 or later
- An elevated PowerShell session for operations that require administrator access
- Winget for application-management features

## Quick start

Open an elevated PowerShell session in the project folder.

```powershell
.\CleanPC_CLI.ps1
```

Available command modes include:

```powershell
.\CleanPC_CLI.ps1 -Command QuickClean
.\CleanPC_CLI.ps1 -Command DeepClean
.\CleanPC_CLI.ps1 -Command Repair
.\CleanPC_CLI.ps1 -Command Optimize
.\CleanPC_CLI.ps1 -Command Complete
```

The WinForms entry point is:

```powershell
.\CleanPC_FINAL.ps1
```

## Safety

Some workflows delete caches, reset networking, alter system settings, uninstall configured applications, or invoke Windows repair tools. Review the selected operation, back up important data, and test on a non-critical machine first.

The deeper cleanup, repair, optimization, and complete-maintenance workflows attempt to create a restore point before major changes.

## Project layout

- `CleanPC_Core.ps1`: cleanup, repair, diagnostics, and maintenance workflows.
- `CleanPC_Config.ps1`: defaults plus configuration save/load support.
- `CleanPC_Advanced.ps1`: large-file analysis, registry backup, SSD/RAM tools, and reports.
- `CleanPC_CLI.ps1`: menu and command-mode interface.
- `CleanPC_FINAL.ps1`: WinForms GUI.
- `Test_CleanPC.ps1`: preflight checks.
- `Build_EXE.ps1`: interactive PS2EXE packaging helper.

## Notes

This repository is a personal Windows maintenance toolkit. It is not a substitute for a tested backup strategy, professional IT support, or a clean Windows installation when hardware or operating-system faults are involved.

Some auxiliary files referenced by the historical scripts are not currently committed. Treat packaging and scheduler-related functionality as work in progress until those references are resolved.

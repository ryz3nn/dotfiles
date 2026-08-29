# ==============================================================================
# SAFE WINGET APP INSTALLER
# ==============================================================================

# Add the apps you want to INSTALL here (One per line, '#' for comments):
$InstallText = @"
# Must install
    Microsoft.Edge
    7zip.7zip
    VideoLAN.VLC
    voidtools.Everything
    Microsoft.WindowsTerminal
    Neovim.Neovim
    Notepad++.Notepad++
    WinDirStat.WinDirStat
    RandyRants.SharpKeys
    Git.Git
# Addon
    Syncthing.Syncthing
    SoftDeluxe.FreeDownloadManager
    glzr-io.glazewm
    sharkdp.fd
    BurntSushi.ripgrep.MSVC
# Programming
    Python.Python.3.14
    Microsoft.VisualStudio.2022.BuildTools
    Rustlang.Rustup
"@

# ==============================================================================
# Parse list: strips whitespace, empty lines, and comment lines starting with '#'
$AppsToInstall = $InstallText -split "`r?`n" | 
    ForEach-Object { $_.Trim() } | 
    Where-Object { $_ -ne "" -and -not $_.StartsWith("#") }

Write-Host "Starting Winget App Installer..." -ForegroundColor Cyan
Write-Host "`n[+] INSTALLING APPS" -ForegroundColor Green

foreach ($app in $AppsToInstall) {
    Write-Host " -> Processing install for: $app" -ForegroundColor White
    
    $argumentList = @(
        "install",
        "--id", $app,
        "--exact",
        "--silent",
        "--disable-interactivity",
        "--accept-package-agreements",
        "--accept-source-agreements"
    )
    
    $process = Start-Process -FilePath "winget" -ArgumentList $argumentList -NoNewWindow -Wait -PassThru
    
    switch ($process.ExitCode) {
        0 {
            Write-Host "    Successfully installed $app!" -ForegroundColor Green
        }
        2316632068 { # 0x8A150004: Package already installed
            Write-Host "    $app is already installed." -ForegroundColor DarkGray
        }
        2316632065 { # 0x8A150001: No package found matching input criteria
            Write-Host "    $app not found in repository." -ForegroundColor Red
        }
        default {
            Write-Host "    Finished with exit code $($process.ExitCode)." -ForegroundColor DarkYellow
        }
    }
}

Write-Host "`nAll installation tasks complete!" -ForegroundColor Cyan

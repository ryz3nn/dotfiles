# ==============================================================================
# WINDOWS STOW-TO-NATIVE SYMLINK SCRIPT (Placed in /scripts)
# ==============================================================================

$DotfilesRoot = Split-Path -Path $PSScriptRoot -Parent

# Explicit Windows target destinations for each Stow package
# Source folder inside package -> Native Windows target path
$AppTargets = @{
    "nvim"       = "$env:LOCALAPPDATA\nvim"                       # nvim/.config/nvim -> %LOCALAPPDATA%\nvim
    "glazewm"    = "$env:USERPROFILE\.glzr\glazewm"               # glazewm/.config/glazewm -> ~\.glzr\glazewm
    "warpd"      = "$env:APPDATA\warpd"
    "vim"        = "$env:USERPROFILE\.vimrc"
}

Write-Host "Dotfiles Root: $DotfilesRoot" -ForegroundColor Cyan

foreach ($pkgName in $AppTargets.Keys) {
    $pkgDir = Join-Path $DotfilesRoot $pkgName
    
    if (-not (Test-Path -Path $pkgDir)) {
        continue
    }

    $targetPath = $AppTargets[$pkgName]

    # Find the deepest config folder or root file inside the package
    # Example: finds 'dotfiles/nvim/.config/nvim'
    $sourceItem = Get-ChildItem -Path $pkgDir -Recurse -Directory | 
        Where-Object { (Get-ChildItem -Path $_.FullName -Directory).Count -eq 0 } | 
        Select-Object -First 1

    # Fallback to single file if no subfolder exists (e.g., tmux/.tmux.conf)
    if (-not $sourceItem) {
        $sourceItem = Get-ChildItem -Path $pkgDir -File | Select-Object -First 1
    }

    if (-not $sourceItem) {
        Write-Host " [!] No files or folders found in $pkgName" -ForegroundColor Yellow
        continue
    }

    $sourcePath = $sourceItem.FullName

    # 1. Ensure target parent directory exists
    $targetParent = Split-Path -Path $targetPath -Parent
    if (-not (Test-Path -Path $targetParent)) {
        New-Item -ItemType Directory -Path $targetParent -Force | Out-Null
    }

    # 2. Check if already linked correctly
    if (Test-Path -Path $targetPath) {
        $existing = Get-Item -Path $targetPath -Force
        if ($existing.LinkType -eq "SymbolicLink" -and $existing.Target -contains $sourcePath) {
            Write-Host " [=] Already linked: $pkgName -> $targetPath" -ForegroundColor DarkGray
            continue
        }

        # Backup existing config before overwriting
        $backupPath = "$targetPath.bak-$(Get-Date -Format 'yyyyMMddHHmmss')"
        Write-Host " [*] Backing up existing config to: $backupPath" -ForegroundColor DarkYellow
        Move-Item -Path $targetPath -Destination $backupPath -Force
    }

    # 3. Create symlink to the end folder/file
    try {
        New-Item -ItemType SymbolicLink -Path $targetPath -Value $sourcePath -Force | Out-Null
        Write-Host " [+] Linked: $pkgName ($($sourceItem.Name)) -> $targetPath" -ForegroundColor Green
    }
    catch {
	Write-Host " [x] Failed to link $($pkgName): $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`nAll Windows symlinks configured!" -ForegroundColor Cyan

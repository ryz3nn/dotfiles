{ config, pkgs, ... }:

{
  # 1. Primary: Fast in-RAM compressed swap (zram)
  # Uses zstd compression; higher priority means it fills up before touching the disk.
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 100; # Allocates a virtual swap device up to ~4GB (compressed data takes less actual RAM)
    priority = 100;
  };

  # 2. Secondary: Fallback swapfile on disk (4GB)
  # Lower priority (5) means it's only touched if zram is completely full.
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 4096; # 4 GiB
      priority = 5;
    }
  ];

  # 3. Kernel memory tuning for low RAM + zram
  boot.kernel.sysctl = {
    # High swappiness tells the kernel to aggressively push anonymous memory into zram
    "vm.swappiness" = 180;
    # Tell kernel not to drop page cache aggressively
    "vm.vfs_cache_pressure" = 50;
    # Avoid dirty page writeback stalls on slow disks
    "vm.dirty_background_ratio" = 5;
    "vm.dirty_ratio" = 10;
  };

  # 4. Proactive OOM prevention
  # Earlyoom prevents hard freezes when memory runs completely dry
  services.earlyoom = {
    enable = true;
    freeMemThreshold = 5;      # Trigger when RAM drops below 5%
    freeSwapThreshold = 10;    # Trigger when total swap drops below 10%
    enableNotifications = true;
  };

  # 5. Build limits for Nix
  # Avoid system lockups during 'nixos-rebuild switch'
  nix.settings = {
    cores = 2;              # Adjust to your core count / avoid maxing out CPU
    max-jobs = 1;           # Only compile 1 derivation at a time
    auto-optimise-store = true;
  };
}

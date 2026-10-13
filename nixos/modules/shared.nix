{ pkgs, inputs, ... }:
{
  virtualisation.vmware.guest.enable = true;

  time.timeZone = "Asia/Ho_Chi_Minh";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
          fcitx5-gtk
          kdePackages.fcitx5-qt
          kdePackages.fcitx5-configtool
          fcitx5-bamboo
      ];
    };
  };

  environment.variables = {
#    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
  };

  users.users.derek = {
    isNormalUser = true;
    initialPassword = "12345";
    extraGroups = [
      "wheel"
        "networkmanager"
    ];	
    shell = pkgs.zsh;
  };
  security.sudo.wheelNeedsPassword = true;

  programs.git.enable = true;
  programs.zsh.enable = true;
  services.cloudflare-warp.enable = true;
  environment.systemPackages = with pkgs; [
    git
      curl
      wget
      htop	
      nix-search-cli
      papirus-icon-theme
      adwaita-icon-theme
      cloudflare-warp
      steam-run
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
      font-awesome
  ];

  networking.networkmanager.enable = true;
  services.openssh.enable = true;
  nixpkgs.config.allowUnfree = true;
  hardware.enableAllFirmware = true;

  nix.settings.experimental-features = [
    "nix-command"
      "flakes"
  ];


  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  nix.settings.auto-optimise-store = true;

# Audio: Pipewire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = false;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  security.rtkit.enable = true;

# Nix-ld
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Wayland dependencies
    wayland
    wayland-protocols
    libxkbcommon

    # Graphics & Rendering (required by wgpu / winit / opengl / vulkan)
    libGL
    vulkan-loader

    # X11 fallback (if winit falls back to XWayland)
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libXrandr
  ];
# wshowkeys
  programs.wshowkeys = {
    enable = true;
    package = inputs.wshowkeys.packages.${pkgs.system}.default;
  };

# SSD
fileSystems."/mnt/data" = {
  device = "/dev/disk/by-uuid/YOUR-SSD-UUID-HERE";
  fsType = "ntfs3"; # or "exfat"
  options = [
    "defaults"
    "nofail"
    "uid=1000"     # ID of your normal user (check with `id -u`)
    "gid=100"      # ID of your group (check with `id -g`, typically 100 for 'users')
    "dmask=0022"   # Folder permissions: 755
    "fmask=0133"   # File permissions: 644
  ];
};
}

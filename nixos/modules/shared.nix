{ pkgs, ... }:
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
  environment.systemPackages = with pkgs; [
    git
      curl
      wget
      htop	
      nix-search-cli
      papirus-icon-theme
      adwaita-icon-theme
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
}

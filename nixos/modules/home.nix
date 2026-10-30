{ config, pkgs, inputs, ... }:

let
  stream-session = pkgs.writeShellScriptBin "stream" ''
    wshowkeys -a bottom -m 60 -F 'JetBrains Mono Bold 26' -b '#1a1b26cc' -f '#c0caf5ff' -l 500 -t 800 &
    steam-run "$HOME/.local/opt/veadotube-mini-linux-x64/veadotube-mini" &
    obs
  '';
in
{
  home.username = "derek";
  home.homeDirectory = "/home/derek";
  programs.home-manager.enable = true;
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    # Tools required by the stream script
    stream-session
    obs-studio

    # Wayland apps
    foot
    fuzzel
    waybar
    mako
    swaybg
    grim
    slurp
    wl-clipboard
    wlsunset

    # Daily 
    btop
    fastfetch
    ripgrep
    fzf
    neovim
    tmux
    stow
    tree
    jq
    ncdu
    kdePackages.ark
    unrar
    unzip
    p7zip
    yazi
    yt-dlp
    ffmpeg
    fd
    seahorse

    # Programs
    vlc
    mpv
    pavucontrol
    firefox
    thunar
    gh
    inputs.antigravity-nix.packages.x86_64-linux.google-antigravity-cli # CLI
    tomat
  ];

  programs.git = {
    enable = true;
    settings.user.name = "ryz3nn";
    settings.user.email = "cklove2211@gmail.com";
    extraConfig = {
      credential.helper = "store";
    };
  };
  services.wlsunset = {
    enable = true;
    temperature = {
      day = 6500;
      night = 6000;
    };
    sunrise = "07:00";
    sunset = "18:00";
  };

  # Registers "Stream Setup" into Fuzzel / application launchers
  xdg.desktopEntries.stream = {
    name = "Stream Setup";
    comment = "Launch wshowkeys, veadotube, and OBS";
    exec = "stream";
    terminal = false;
    categories = [ "AudioVideo" "Recorder" ];
  };
}

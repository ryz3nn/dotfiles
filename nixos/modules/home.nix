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
    _7zz
    yazi

    # Programs
    vlc
    mpv
    pavucontrol
    firefox
    thunar
    gh
  ];

  programs.git = {
    enable = true;
    settings.user.name = "ryz3nn";
    settings.user.email = "cklove2211@gmail.com";
    extraConfig = {
      credential.helper = "store";
    };
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

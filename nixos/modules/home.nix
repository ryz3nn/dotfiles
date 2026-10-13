
{ config, pkgs, ... }:
{
	home.username = "derek";
	home.homeDirectory = "/home/derek";

	home.packages = with pkgs; [
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
    droidcam
    cloudflare-warp

	];
	programs.git = {
		enable = true;
		settings.user.name = "ryz3nn";
		settings.user.email = "cklove2211@gmail.com";
    extraConfig = {
        credential.helper = "store";
      };
	};
	programs.home-manager.enable = true;
	home.stateVersion = "26.05";
}

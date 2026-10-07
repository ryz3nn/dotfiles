
{ config, pkgs, ... }:
{
	home.username = "derek";
	home.homeDirectory = "/home/derek";

	home.packages = with pkgs; [
# Wayland apps
    foot
    fuzzel
    yambar
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
# Programs
    firefox
    thunar

	];
	programs.git = {
		enable = true;
		settings.user.name = "ryz3nn";
		settings.user.email = "cklove2211@gmail.com";
	};
	programs.home-manager.enable = true;
	home.stateVersion = "26.05";
}

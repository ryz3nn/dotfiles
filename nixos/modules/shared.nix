{ pkgs, ... }:
{
	time.timeZone = "Asia/Ho_Chi_Minh";
	i18n.defaultLocale = "en_US.UTF-8";

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
	];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    font-awesome
  ];

	networking.networkmanager.enable = true;
	services.openssh.enable = true;
	nixpkgs.config.allowUnfree = true;

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

  virtualisation.vmware.guest.enable = true;
}

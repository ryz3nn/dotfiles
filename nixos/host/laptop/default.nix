{ ... }:
{
	imports = [
		./hardware-configuration.nix
		../../modules/shared.nix	
		../../modules/gpt.nix	
		../../modules/niri.nix	
		../../modules/dm.nix	
		../../modules/swapfile.nix	
		../../modules/cron.nix	
	];
	
	networking.hostName = "laptop";
	system.stateVersion = "26.05";
}

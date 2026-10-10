{ ... }:
{
	imports = [
		./hardware-configuration.nix
		../../modules/shared.nix	
		../../modules/gpt.nix	
		../../modules/niri.nix	
		../../modules/dm.nix	
		../../modules/cron.nix	
	];
	
	networking.hostName = "amd-pc";
	system.stateVersion = "26.05";
}

{ ... }:
{
	imports = [
		./hardware-configuration.nix
		../../modules/shared.nix	
		../../modules/gpt.nix	
		../../modules/niri.nix	
		../../modules/dm.nix	
	];
	
	networking.hostName = "amd-pc";
	system.stateVersion = "26.05";
}

{
	description = "Nixos configuration";
	
	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
	
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};
	
	outputs = {self, nixpkgs, home-manager, ...} : {
		nixosConfigurations = {
			amd-pc = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				modules = [
					./host/amd-pc
					home-manager.nixosModules.home-manager {
						home-manager.useGlobalPkgs = true;	
						home-manager.useUserPackages = true;	
						home-manager.users.derek = import ./host/amd-pc/home.nix;	
					}
				];			
			};
		};
	};
}

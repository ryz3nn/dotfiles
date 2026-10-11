{
  description = "Nixos configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    bluevein.url = "github:meowrch/BlueVein";
  };

  outputs = {self, nixpkgs, home-manager, bluevein, ...} : {
    nixosConfigurations = {
      amd-pc = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./host/amd-pc
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;	
            home-manager.useUserPackages = true;	
            home-manager.users.derek = import ./modules/home.nix;	
          }
          bluevein.nixosModules.default
          {
            services.bluevein.enable = true;
            # Optional: pin the EFI device with a stable path
            services.bluevein.efiDevice = "/dev/disk/by-uuid/38E5-B4C3";
          }
        ];			
      };
      laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./host/laptop
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;	
              home-manager.useUserPackages = true;	
              home-manager.users.derek = import ./modules/home.nix;	
            }
        ];			
      };
    };
  };
}

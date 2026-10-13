{
  description = "Nixos configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    bluevein.url = "github:meowrch/BlueVein";

    wshowkeys = {
      url = "github:DreamMaoMao/wshowkeys";
      inputs.nixpkgs.follows = "nixpkgs"; # optional
    };
  };

  # 1. Capture inputs here using `@inputs`
  outputs = { self, nixpkgs, home-manager, bluevein, ... }@inputs: {
    nixosConfigurations = {
      amd-pc = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs; };
        modules = [
          ./host/amd-pc
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            # 2. Pass inputs into Home Manager modules
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.derek = import ./modules/home.nix;
          }
          bluevein.nixosModules.default
          {
            services.bluevein.enable = true;
            services.bluevein.efiDevice = "/dev/disk/by-uuid/5204-DADB";
          }
        ];
      };

      laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs; };
        modules = [
          ./host/laptop
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            # 2. Pass inputs here as well
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.derek = import ./modules/home.nix;
          }
        ];
      };
    };
  };
}

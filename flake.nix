{
    # ref: https://github.com/ryan4yin/nix-config
    description = "Base (flake) NixOS Configuration";

    inputs = {
        # NixOS official package source, unstable (i.e. rolling release)
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        # home-manager, used for managing user configuration
        home-manager = {
            url = "github:nix-community/home-manager";
            # The `follows` keyword in inputs is used for inheritance.
            # Here, `inputs.nixpkgs` of home-manager is kept consistent with
            # the `inputs.nixpkgs` of the current flake,
            # to avoid problems caused by different versions of nixpkgs.
            inputs.nixpkgs.follows = "nixpkgs";
        };
        catppuccin-bat = {
            url = "github:catppuccin/bat";
            flake = false;
        };
        nixvim = {
            url = "github:nix-community/nixvim";
	    inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = inputs @ {
        self,
        nixpkgs,
        home-manager,
        ...
    }: {
        nixosConfigurations = {
        # Modularize for different hosts
            utm-aarch64 = nixpkgs.lib.nixosSystem {
		specialArgs = { inherit inputs; };
                modules = [
                    # System-wide configurations (i.e. when also root)
                    ./hosts/utm-aarch64

                    # home-manager (deploy automatically as module)
                    home-manager.nixosModules.home-manager
                    {
                        home-manager.useGlobalPkgs = true;
                        home-manager.useUserPackages = true;
			home-manager.backupFileExtension = "backup";

                        home-manager.extraSpecialArgs = inputs;
                        home-manager.users.balisong = import ./home;
                    }
                ];
            };
        };
    };
}

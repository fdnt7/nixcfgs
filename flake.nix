{
  description = "My NixOS configuration files";

  inputs = {
    catppuccin.url = "github:catppuccin/nix";

    # devenv.url = "github:cachix/devenv";
    devenv.url = "github:cachix/devenv/v1.11.2";

    # Home manager
    # home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    impermanence.url = "github:nix-community/impermanence";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.3";

      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixcord.url = "github:kaylorben/nixcord";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Nixpkgs
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.

    nixvim = {
      url = "github:nix-community/nixvim";
      # If you are not running an unstable channel of nixpkgs, select the corresponding branch of nixvim.
      # url = "github:nix-community/nixvim/nixos-25.05";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    solaar = {
      #url = "https://flakehub.com/f/Svenum/Solaar-Flake/*.tar.gz"; # For latest stable version
      #url = "https://flakehub.com/f/Svenum/Solaar-Flake/0.1.1.tar.gz"; # uncomment line for solaar version 1.1.13
      url = "github:Svenum/Solaar-Flake/main"; # Uncomment line for latest unstable version
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";

    xdg-ninja.url = "github:b3nj5m1n/xdg-ninja";

    yazi.url = "github:sxyazi/yazi";

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      # IMPORTANT: we're using "libgbm" and is only available in unstable so ensure
      # to have it up-to-date or simply don't specify the nixpkgs input
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      # Supported systems for your flake packages, shell, etc.
      systems = [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      # This is a function that generates an attribute by calling a function you
      # pass to it, with each system as an argument
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      # Your custom packages
      # Accessible through 'nix build', 'nix shell', etc
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      # Formatter for your nix files, available through 'nix fmt'
      # Other options beside 'alejandra' include 'nixpkgs-fmt'
      # formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);

      # Your custom packages and modifications, exported as overlays
      overlays = import ./overlays { inherit inputs; };
      # Reusable nixos modules you might want to export
      # These are usually stuff you would upstream into nixpkgs
      nixosModules = import ./modules/nixos;
      # Reusable home-manager modules you might want to export
      # These are usually stuff you would upstream into home-manager
      homeManagerModules = import ./modules/home-manager;

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations =
        let
          hostConfigs = {
            cuties-only = {
              nixcfgs = rec {
                name = "nixcfgs";
                uname = "fdnt";
                gname = name;
                hostName = "cuties-only";
                flake = "/etc/${name}";
                persistVol = "persist";
                persist = "/${persistVol}";
                sopsAgeKeyFile = "${persist}/var/lib/sops-nix/key.txt";
                enableWinBoat = true;
              };
            };

            lavender-pilled = {
              nixcfgs = rec {
                name = "nixcfgs";
                uname = "fdl";
                gname = name;
                hostName = "lavender-pilled";
                flake = "/etc/${name}";
                persistVol = "persist";
                persist = "/${persistVol}";
                sopsAgeKeyFile = "${persist}/var/lib/sops-nix/key.txt";
                githubUname = "fdnt7";
              };
            };

            # Add more hosts here...
          };
        in
        builtins.mapAttrs (
          hostName: cfg:
          nixpkgs.lib.nixosSystem {
            specialArgs = {
              inherit inputs outputs;
              nixcfgs = cfg.nixcfgs;
            };

            modules = [
              ./hosts/${hostName}/nixos/configuration.nix
            ];
          }
        ) hostConfigs;

      # use home-manager as a nixos module to comply with impermanence

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      # homeConfigurations = {
      #   "your-username@your-hostname" = home-manager.lib.homeManagerConfiguration {
      #     pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
      #     extraSpecialArgs = {inherit inputs outputs;};
      #     modules = [
      #       # > Our main home-manager configuration file <
      #       ./home-manager/home.nix
      #     ];
      #   };
      # };
    };
}

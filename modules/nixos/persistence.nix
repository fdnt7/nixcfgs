{
  config,
  inputs,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkMerge
    mkOption
    types
    ;
  inherit (types) str;
  cfg = config.persist;
in
{
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  options.persist = {
    root = mkOption {
      type = str;
      description = "The persistence root directory.";
    };

    networkmanager = mkEnableOption "NetworkManager system connections persistence";

    machineId = mkEnableOption "Machine ID persistence";

    backlight = mkEnableOption "Systemd Backlight persistence";

    nixos = mkEnableOption "NixOS libraries persistence";

    sudo = mkEnableOption "Sudo database persistence";

    flake = {
      enable = mkEnableOption "flake directory persistence";

      root = mkOption {
        type = str;
        description = "The flake root directory.";
      };

      group = mkOption {
        type = str;
        description = "The flake root directory's owning group.";
      };
    };

    secureboot = mkEnableOption "Secure boot keys persistence";
  };

  config = mkMerge [
    (mkIf cfg.networkmanager {
      environment.persistence.${cfg.root}.directories = [
        "/etc/NetworkManager/system-connections"
      ];
    })

    (mkIf cfg.machineId {
      environment.persistence.${cfg.root}.files = [ "/etc/machine-id" ];
    })

    (mkIf cfg.backlight {
      environment.persistence.${cfg.root}.directories = [ "/var/lib/systemd/backlight" ];
    })

    (mkIf cfg.sudo {
      environment.persistence.${cfg.root}.directories = [ "/var/db/sudo" ];
    })

    (mkIf cfg.nixos {
      environment.persistence.${cfg.root}.directories = [ "/var/lib/nixos" ];
    })

    (mkIf cfg.secureboot {
      environment.persistence.${cfg.root}.directories = [ config.boot.lanzaboote.pkiBundle ];
    })

    (mkIf cfg.flake.enable {
      environment.persistence.${cfg.root}.directories =
        let
          inherit (cfg.flake) root group;
        in
        [
          {
            directory = root;
            group = group;
            mode = "u=rwx,g=rwx,o=";
          }
        ];
    })
  ];
}

{
  config,
  inputs,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    mkOption
    mkMerge
    mkEnableOption
    types
    ;
  inherit (types) str path;
  cfg = config.secrets;
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  options.secrets = {
    key = mkOption {
      type = str;
      description = "SOPS age key file";
    };

    file = mkOption {
      type = path;
      description = "SOPS secrets file";
    };

    userPassword = {
      enable = mkEnableOption "User password secrets management";

      name = mkOption {
        type = str;
        description = "User name";
      };

      path = mkOption {
        type = str;
        default = "nixos/users/users/0/hashedPassword";
        description = "Path to store the secrets at runtime";
      };
    };
  };

  config = mkMerge [
    {
      sops =
        let
          inherit (cfg) file key;
        in
        {
          defaultSopsFile = file;
          defaultSopsFormat = "yaml";

          age.keyFile = key;
        };
    }

    (
      let
        inherit (cfg.userPassword) enable name path;
      in
      mkIf enable {
        users.users.${name}.hashedPasswordFile = config.sops.secrets.${path}.path;

        sops.secrets.${path}.neededForUsers = true;
      }
    )
  ];
}

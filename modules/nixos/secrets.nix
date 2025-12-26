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
  tPath = types.path;
  inherit (types) str;
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
      type = tPath;
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
        pwdCfg = cfg.userPassword;
        pwdPath = pwdCfg.path;
        inherit (pwdCfg) enable name;
      in
      mkIf enable {
        users.users.${name}.hashedPasswordFile = config.sops.secrets.${pwdPath}.path;

        sops.secrets.${pwdPath}.neededForUsers = true;
      }
    )
  ];
}

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
    generators
    removePrefix
    ;
  inherit (types) str listOf;
  tPath = types.path; # `builtins.path` != `lib.types.path`
  cfg = config.secrets;
in
{
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  options.secrets = {
    enable = mkEnableOption "global secrets management with sops-nix";

    key = mkOption {
      type = str;
      description = "SOPS age key file";
    };

    file = mkOption {
      type = tPath;
      description = "SOPS secrets file";
    };

    nixAccessTokens = {
      enable = mkEnableOption "nix access token secrets management";

      paths = mkOption {
        type = listOf str;
        default = [ "home-manager/nix/extraOptions/extra-access-tokens/0" ];
        description = "List of secret keys (paths in SOPS) to manage as nix access tokens.";
      };
    };

    wakatimeApiKey = {
      enable = mkEnableOption "Wakatime API key";

      path = mkOption {
        type = str;
        default = "home-manager/programs/wakatime/apiKey";
        description = "Path to the Wakatime API key file";
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    # Base secrets setup
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

      systemd.user.services.mbsync.unitConfig.After = [ "sops-nix.service" ];
    }

    # Conditional inner secrets management modules
    (mkIf cfg.nixAccessTokens.enable (
      let
        secretsSet = builtins.listToAttrs (
          map (p: {
            name = p;
            value = { };
          }) cfg.nixAccessTokens.paths
        );
        includeLines = builtins.concatStringsSep "\n" (
          map (p: "!include ${config.sops.secrets.${p}.path}") cfg.nixAccessTokens.paths
        );
      in
      {
        sops.secrets = secretsSet;
        nix.extraOptions = includeLines;
      }
    ))

    (
      let
        inherit (cfg) wakatimeApiKey;
      in
      mkIf wakatimeApiKey.enable (
        let
          xdgConfigHome = removePrefix config.home.homeDirectory config.xdg.configHome;
          configDir = if config.home.preferXdgDirectories then "${xdgConfigHome}/wakatime" else ".wakatime";
          keyPath = wakatimeApiKey.path;
        in
        {
          sops.secrets.${keyPath} = { };

          home.file."${configDir}/.wakatime.cfg" = {
            text = generators.toINI { } {
              settings.api_key_vault_cmd = "cat ${config.sops.secrets.${keyPath}.path}";
            };
          };
        }
      )
    )
  ]);
}

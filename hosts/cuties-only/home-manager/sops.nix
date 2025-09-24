{
  config,
  inputs,
  lib,
  nixcfgs,
  ...
}: let
  sopsSecrets = config.sops.secrets;
  homeManager = "home-manager";
  githubPat = "${homeManager}/nix/settings/extra-access-tokens/github-pat";
  wakatimeApiKey = "${homeManager}/wakatime/api_key";
in {
  imports = [inputs.sops-nix.homeManagerModules.sops];

  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";

    age.keyFile = nixcfgs.sopsAgeKeyFile;

    # these are not no-op;
    # `secrets.<key> = {};` tells sops-nix to use it
    secrets = {
      ${githubPat} = {};
      "${wakatimeApiKey}" = {};
    };
  };

  systemd.user.services.mbsync.unitConfig.After = ["sops-nix.service"];

  nix.extraOptions = "!include ${sopsSecrets.${githubPat}.path}";

  xdg.configFile."wakatime".text = lib.generators.toINI {} {
    settings.api_key_vault_cmd = "cat ${sopsSecrets.${wakatimeApiKey}.path}";
  };
}

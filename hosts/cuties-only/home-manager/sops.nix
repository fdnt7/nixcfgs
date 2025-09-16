{
  config,
  inputs,
  nixcfgs,
  ...
}: let
  githubPat = "home-manager/nix/settings/extra-access-tokens/github-pat";
in {
  imports = [inputs.sops-nix.homeManagerModules.sops];

  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";

    age.keyFile = nixcfgs.sopsAgeKeyFile;

    # this is not no-op;
    # `secrets.<key> = {};` tells sops-nix to use it
    secrets.${githubPat} = {};
  };

  systemd.user.services.mbsync.unitConfig.After = ["sops-nix.service"];

  nix.extraOptions = "!include ${config.sops.secrets.${githubPat}.path}";
}

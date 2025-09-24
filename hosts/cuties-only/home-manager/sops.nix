{
  config,
  inputs,
  lib,
  nixcfgs,
  ...
}: {
  imports = [inputs.sops-nix.homeManagerModules.sops];

  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";

    age.keyFile = nixcfgs.sopsAgeKeyFile;
  };

  systemd.user.services.mbsync.unitConfig.After = ["sops-nix.service"];
}

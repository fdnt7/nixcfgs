{
  config,
  inputs,
  nixcfgs,
  ...
}: let
  hashedPassword = "nixos/users/users/0/hashedPassword";
in {
  imports = [inputs.sops-nix.nixosModules.sops];

  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";

    age.keyFile = nixcfgs.sopsAgeKeyFile;

    secrets.${hashedPassword}.neededForUsers = true;
  };

  users.users.${nixcfgs.uname}.hashedPasswordFile = config.sops.secrets.${hashedPassword}.path;
}

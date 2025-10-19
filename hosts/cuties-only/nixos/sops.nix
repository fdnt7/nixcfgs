{
  config,
  inputs,
  nixcfgs,
  ...
}:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";

    age.keyFile = nixcfgs.sopsAgeKeyFile;
  };
}

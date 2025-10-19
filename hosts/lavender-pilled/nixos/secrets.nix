{
  nixcfgs,
  outputs,
  ...
}:
{
  imports = [ outputs.nixosModules.secrets ];

  secrets = {
    file = ../secrets/secrets.yaml;
    key = nixcfgs.sopsAgeKeyFile;
  };
}

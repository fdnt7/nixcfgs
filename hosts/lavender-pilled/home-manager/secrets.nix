{
  nixcfgs,
  outputs,
  ...
}:
{
  imports = [ outputs.homeManagerModules.secrets ];

  secrets = {
    enable = true;
    file = ../secrets/secrets.yaml;
    key = nixcfgs.sopsAgeKeyFile;
  };
}

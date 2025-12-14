{
  inputs,
  nixcfgs,
  ...
}:
{
  imports = [ inputs.self.homeManagerModules.secrets ];

  secrets = {
    enable = true;
    file = ../secrets/secrets.yaml;
    key = nixcfgs.sopsAgeKeyFile;
  };
}

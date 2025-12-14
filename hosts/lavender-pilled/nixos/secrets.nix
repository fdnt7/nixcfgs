{
  inputs,
  nixcfgs,
  ...
}:
{
  imports = [ inputs.self.nixosModules.secrets ];

  secrets = {
    file = ../secrets/secrets.yaml;
    key = nixcfgs.sopsAgeKeyFile;
  };
}

{ inputs, ... }:
{
  imports = [ inputs.solaar.nixosModules.default ];

  services.solaar = {
    enable = false;
    window = "only";
  };
}

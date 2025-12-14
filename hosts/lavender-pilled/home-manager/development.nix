{ inputs, ... }:
{
  imports = [ inputs.self.homeManagerModules.development ];

  development = {
    enable = true;
    nix.enable = true;
  };
}

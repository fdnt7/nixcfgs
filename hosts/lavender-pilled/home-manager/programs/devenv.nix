{ inputs, ... }:
{
  imports = [ inputs.self.homeManagerModules.devenv ];

  programs.devenv = {
    enable = true;
    cache.enable = true;
  };
}

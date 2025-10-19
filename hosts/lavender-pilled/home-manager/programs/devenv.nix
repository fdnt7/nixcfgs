{ outputs, ... }:
{
  imports = [ outputs.homeManagerModules.devenv ];

  programs.devenv = {
    enable = true;
    cache.enable = true;
  };
}

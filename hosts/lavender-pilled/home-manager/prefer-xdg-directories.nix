{ inputs, ... }:
{
  imports = [ inputs.self.homeManagerModules.prefer-xdg-directories ];

  home.preferXdgDirectories = true;
}

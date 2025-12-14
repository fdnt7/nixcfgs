{
  inputs,
  ...
}:
{
  imports = [ inputs.self.homeManagerModules.xdg-ninja ];

  xdg-ninja = {
    enable = true;
    installPackage = true;
  };
}

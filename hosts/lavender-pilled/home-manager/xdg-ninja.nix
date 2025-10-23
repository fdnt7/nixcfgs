{
  outputs,
  ...
}:
{
  imports = [ outputs.homeManagerModules.xdg-ninja ];

  xdg-ninja = {
    enable = true;
    installPackage = true;
  };
}

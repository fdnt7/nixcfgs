{outputs, ...}: {
  imports = [outputs.homeManagerModules.rebuild];

  programs.rebuild.enable = true;
}

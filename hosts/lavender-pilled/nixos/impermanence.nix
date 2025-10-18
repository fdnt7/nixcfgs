{outputs, ...}: {
  imports = [outputs.nixosModules.impermanence];

  impermanence.enable = true;
}

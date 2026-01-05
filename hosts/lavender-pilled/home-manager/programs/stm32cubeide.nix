{
  inputs,
  pkgs,
  ...
}:
{
  home.packages = [
    inputs.stm32cubeide.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}

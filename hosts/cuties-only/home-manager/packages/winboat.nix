{
  inputs,
  pkgs,
  ...
}:
{
  home.packages = [
    pkgs.freerdp

    inputs.winboat.packages.${pkgs.stdenv.hostPlatform.system}.winboat
  ];
}

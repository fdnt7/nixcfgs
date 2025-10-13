{
  inputs,
  pkgs,
  ...
}: {
  home.packages = [inputs.winboat.packages.${pkgs.stdenv.hostPlatform.system}.winboat];
}

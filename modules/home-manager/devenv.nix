{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.programs.devenv;
in {
  options.programs.devenv = {
    enable = mkEnableOption "devenv";
    cache.enable = mkEnableOption "the usage of devenv's binary cache";
  };

  config = mkIf cfg.enable {
    home.packages = [
      inputs.devenv.packages.${pkgs.stdenv.hostPlatform.system}.devenv
    ];

    nix.settings = mkIf cfg.cache.enable {
      extra-substituters = ["https://devenv.cachix.org"];
      extra-trusted-substituters = ["https://devenv.cachix.org"];
      extra-trusted-public-keys = [
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      ];
    };
  };
}

{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf mkMerge;
  cfg = config.development;
in
{
  options.development = {
    enable = mkEnableOption "development tools";
    nix.enable = mkEnableOption "nix development tools";
  };

  config = mkIf cfg.enable (mkMerge [
    (
      let
        nixd = inputs.nixd.packages.${pkgs.stdenv.hostPlatform.system}.default;
        extraPackages = [
          nixd
          pkgs.nixfmt
        ];
      in
      mkIf cfg.nix.enable {
        programs = {
          nixvim.extraPackages = extraPackages;
          zed-editor.extraPackages = extraPackages;
        };
      }
    )
  ]);
}

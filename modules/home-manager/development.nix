{
  config,
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
        inherit (pkgs) nixd nixfmt;
        extraPackages = [
          nixd
          nixfmt
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

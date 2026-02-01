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
    python.enable = mkEnableOption "python development tools";
  };

  config = mkIf cfg.enable (
    let
      inherit (pkgs)
        basedpyright
        nixd
        nixfmt
        ruff
        ;
      nix = [
        nixd
        nixfmt
      ];
      python = [
        basedpyright
        ruff
      ];
    in
    mkMerge [
      (mkIf cfg.nix.enable {
        programs = {
          nixvim.extraPackages = nix;
          zed-editor.extraPackages = nix;
        };
      })
      (mkIf cfg.python.enable {
        programs = {
          nixvim.extraPackages = python;
          zed-editor.extraPackages = python;
        };
      })
    ]
  );
}

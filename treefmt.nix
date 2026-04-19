{ lib, ... }:
{
  # Used to find the project root
  projectRootFile = "flake.nix";

  programs = {
    mdformat = {
      enable = true;
      settings.wrap = 80;
    };
    nixfmt.enable = true;
    oxfmt = {
      enable = true;
      includes = [
        "*.css"
        "*.jsonc"
      ];
    };
    stylua.enable = true;
    taplo.enable = true;
    typos.enable = true;
    yamlfmt.enable = true;
  };

  # exclude `--write-changes` from options so it doesn't automatically fix typos
  # because it could break code
  settings.formatter.typos.options = lib.mkForce [ "--force-exclude" ];
}

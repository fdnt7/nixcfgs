{
  # Used to find the project root
  projectRootFile = "flake.nix";

  programs = {
    biome = {
      enable = true;
      includes = [ "*.jsonc" ];
    };
    nixfmt.enable = true;
    prettier = {
      enable = true;
      includes = [
        "*.css"
        "*.md"
        "*.yaml"
      ];
      settings.proseWrap = "always";
    };
    stylua.enable = true;
  };
}

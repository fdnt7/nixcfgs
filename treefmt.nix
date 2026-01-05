{
  # Used to find the project root
  projectRootFile = "flake.nix";

  programs = {
    nixfmt.enable = true;
    prettier = {
      enable = true;
      includes = [
        "*.css"
        "*.md"
        "*.yaml"
      ];
    };
    stylua.enable = true;
  };
}

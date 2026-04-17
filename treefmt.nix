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
    yamlfmt.enable = true;
  };
}

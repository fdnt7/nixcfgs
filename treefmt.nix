{
  # Used to find the project root
  projectRootFile = "flake.nix";

  programs = {
    mdformat.enable = true;
    nixfmt.enable = true;
    stylua.enable = true;
    yamlfmt.enable = true;
  };
}

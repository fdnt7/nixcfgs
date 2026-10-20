{
  # Used to find the project root
  projectRootFile = "flake.nix";

  settings.excludes = [
    # No formatter reads ssh's allowed signers format
    "home/f/global/allowed-signers"
    # Laid out by hand: kdlfmt drops the blank lines and one-line blocks
    "*.kdl"
    # Written by sops, which would fight a formatter over the layout
    "hosts/*/secrets.yaml"
  ];

  programs = {
    mdformat = {
      enable = true;
      settings.wrap = 80;
    };
    nixfmt.enable = true;
    oxfmt = {
      enable = true;
      includes = [ "*.jsonc" ];
    };
    shfmt = {
      enable = true;
      includes = [ ".envrc" ];
    };
    stylua.enable = true;
    taplo.enable = true;
    yamlfmt.enable = true;
  };
}

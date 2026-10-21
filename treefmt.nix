# What this repository adds to the formatting devshell gives every project
# (mdformat, nixfmt, shfmt for .envrc, taplo).
{
  settings.excludes = [
    # No formatter reads ssh's allowed signers format
    "home/f/global/allowed-signers"
    # Laid out by hand: kdlfmt drops the blank lines and one-line blocks
    "*.kdl"
    # Written by sops, which would fight a formatter over the layout
    "hosts/*/secrets.yaml"
  ];

  programs = {
    oxfmt = {
      enable = true;
      includes = [ "*.jsonc" ];
    };
    stylua.enable = true;
    yamlfmt.enable = true;
  };
}

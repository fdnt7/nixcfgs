{ pkgs, ... }:
{
  # The Nix language server and formatter, for editors outside a project's
  # own development shell.
  home.packages = [
    pkgs.nixd
    pkgs.nixfmt
  ];
}

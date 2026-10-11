{ inputs, ... }:
{
  # A prebuilt index of which package provides which file, so nothing has to
  # be indexed locally. `, program` runs a program without installing it, and
  # the shell suggests a package when a command is not found.
  imports = [ inputs.nix-index-database.homeModules.nix-index ];

  programs.nix-index.enable = true;
  programs.nix-index-database.comma.enable = true;
}

{ inputs, ... }:
{
  imports = [ inputs.catppuccin.homeModules.catppuccin ];

  catppuccin = {
    flavor = "mocha";
    accent = "lavender";

    # disabled because it uses `substituters` and `trusted-public-keys` which
    # entirely replaces the entire list. the `extra-` functionality should be
    # used instead.

    # cache.enable = true;
  };

  nix.settings = {
    extra-substituters = [ "https://catppuccin.cachix.org" ];
    extra-trusted-public-keys = [
      "catppuccin.cachix.org-1:noG/4HkbhJb+lUAdKrph6LaozJvAeEEZj4N732IysmU="
    ];
  };
}

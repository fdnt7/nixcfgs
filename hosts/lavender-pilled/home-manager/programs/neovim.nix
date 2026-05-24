{ inputs, pkgs, ... }:
{
  imports = [ inputs.nixvim.homeModules.nixvim ];

  programs.fish.shellAbbrs = {
    v = "vi";
  };

  programs.nixvim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    opts = {
      number = true;
      relativenumber = true;

      expandtab = true;
      tabstop = 2;
      shiftwidth = 2;
      softtabstop = 2;
    };
    extraPackages = [ pkgs.wl-clipboard ];

    # Acknowledge that `inputs.nixvim.inputs.nixpkgs.follows = "nixpkgs"`
    # overrides nixvim's pinned rev. Silences the upstream warning; accepts
    # drift risk in exchange for not pulling a second nixpkgs into the closure.
    #
    # Refs: https://github.com/nix-community/nixvim/commit/f58f0568829de0cac5183844e822c697dd0aeeb8
    nixpkgs.source = pkgs.path;
  };
}

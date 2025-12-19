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
  };
}

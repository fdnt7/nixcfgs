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
      shiftwidth = 2;
      textwidth = 80;
    };
    extraPackages = [ pkgs.wl-clipboard ];
  };
}

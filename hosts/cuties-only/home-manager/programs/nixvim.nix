{inputs, ...}: {
  imports = [inputs.nixvim.homeModules.nixvim];

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
      termguicolors = true;
      shiftwidth = 2;
      textwidth = 80;
    };

    colorschemes.catppuccin = {
      enable = true;
      settings = {
        transparent_background = true;
        flavour = "mocha";
      };
    };
  };
}

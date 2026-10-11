{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
    withPython3 = false;
    withRuby = false;

    # For the system clipboard under Wayland.
    extraPackages = [ pkgs.wl-clipboard ];

    initLua = ''
      vim.o.number = true
      vim.o.relativenumber = true

      vim.o.expandtab = true
      vim.o.tabstop = 2
      vim.o.shiftwidth = 2
      vim.o.softtabstop = 2
    '';
  };
}

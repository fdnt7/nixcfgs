{ pkgs, ... }:
{
  # Terminal file manager. `y` is the shell wrapper that changes directory
  # on exit.
  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
    initLua = ./init.lua;
    plugins.full-border = pkgs.yaziPlugins.full-border;
    settings.mgr.show_hidden = true;
    theme = {
      indicator.preview.reversed = true;
      status = {
        sep_left = {
          open = "";
          close = "";
        };
        sep_right = {
          open = "";
          close = "";
        };
      };
    };
  };
}

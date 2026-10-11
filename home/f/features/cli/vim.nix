{ config, ... }:
{
  programs.vim = {
    enable = true;
    extraConfig = ''
      set viminfofile=${config.xdg.stateHome}/vim/viminfo
    '';
  };

  # Vim does not create the directory itself.
  xdg.stateFile."vim/.keep".text = "";
}

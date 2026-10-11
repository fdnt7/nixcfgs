# Home configuration shared by every host this user has an account on.
{ config, ... }:
{
  home = {
    username = "f";
    homeDirectory = "/home/f";

    # Keep dotfiles out of ~: modules that know how follow the XDG base
    # directories, and each feature points its program at them where the
    # program needs to be told.
    preferXdgDirectories = true;

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "26.05";
  };

  xdg.enable = true;

  # Lets Home Manager set session variables such as SSH_AUTH_SOCK. Bash only
  # reads its startup files from ~, so those three links have to stay.
  programs.bash = {
    enable = true;
    historyFile = "${config.xdg.stateHome}/bash/history";
  };
}

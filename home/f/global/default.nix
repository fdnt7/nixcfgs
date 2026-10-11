# Home configuration shared by every host this user has an account on.
{
  home = {
    username = "f";
    homeDirectory = "/home/f";

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "26.05";
  };

  # Lets Home Manager set session variables such as SSH_AUTH_SOCK.
  programs.bash.enable = true;
}

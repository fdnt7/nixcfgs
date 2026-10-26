# Home configuration shared by every host this user has an account on.
{
  imports = [
    ./secrets.nix
    ./ssh.nix
  ];

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

  programs.git.settings = {
    user = {
      name = "Fridella Nythell";
      email = "git@frdl.la";
    };
    # Keys whose signatures `git log --show-signature` accepts as mine.
    gpg.ssh.allowedSignersFile = "${./allowed-signers}";
  };
}

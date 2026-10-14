# Home configuration shared by every host this user has an account on.
{ config, ... }:
{
  home = {
    username = "k";
    homeDirectory = "/home/k";

    # Keep dotfiles out of ~: modules that know how follow the XDG base
    # directories, and each feature points its program at them where the
    # program needs to be told.
    preferXdgDirectories = true;

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "26.11";
  };

  xdg.enable = true;

  # Keys whose signatures `git log --show-signature` accepts as mine. The
  # principal is the key's own name rather than an address, which would
  # say who this is.
  programs.git.settings.gpg.ssh.allowedSignersFile = "${./allowed-signers}";

  # Who commits is not written here: this repository is public. The name
  # and address are in a file kept on the machine, as `[user]` settings.
  # A second file overrides the address for university work: it applies
  # to any repository with a directory named University somewhere above
  # it, such as ~/Documents/University and ~/Projects/University.
  programs.git.includes = [
    { path = "${config.xdg.configHome}/git/identity"; }
    {
      condition = "gitdir:**/University/**";
      path = "${config.xdg.configHome}/git/identity-university";
    }
  ];
}

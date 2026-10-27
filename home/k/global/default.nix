# Home configuration shared by every host this user has an account on.
{ osConfig, ... }:
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

  # Who commits, and with which key, is kept out of this public repository:
  # the name, both addresses and the allowed-signers line for k's own key
  # are encrypted, in ../../../hosts/fw12/secrets.nix. The signing key is
  # ~/.ssh/id_ecdsa, which is never published.
  programs.git = {
    settings.gpg.ssh.allowedSignersFile = osConfig.sops.templates."git/allowed-signers".path;

    includes = [
      { path = osConfig.sops.secrets."git/identity".path; }

      # University work, under the university address: any repository
      # with a directory named University somewhere above it, such as
      # ~/Documents/University and ~/Projects/University.
      {
        condition = "gitdir:**/University/**";
        path = osConfig.sops.secrets."git/identity-university".path;
      }

      # This configuration, under f's public identity and a key of its
      # own, so nothing it publishes ties back to k. The key is f's on
      # GitHub, for signing and for pushing. Its shared connection gets a
      # socket of its own too: sockets are told apart by host, port and
      # user, not by key, so it would otherwise be k's, logged in as k.
      {
        condition = "gitdir:~/.config/nixos/";
        contents = {
          user = {
            name = "Fridella Nythell";
            email = "git@frdl.la";
            signingKey = "~/.ssh/id_ecdsa_fdnt7.pub";
          };
          core.sshCommand = "ssh -i ~/.ssh/id_ecdsa_fdnt7.pub -o IdentitiesOnly=yes -o 'ControlPath=\${XDG_RUNTIME_DIR}/ssh-fdnt7-%C'";
        };
      }
    ];
  };
}

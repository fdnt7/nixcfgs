# Home configuration shared by every host this user has an account on.
{ config, osConfig, ... }:
{
  home = {
    username = "k";
    homeDirectory = "/home/k";

    # Keep dotfiles out of ~: modules that know how follow the XDG base
    # directories, and each feature points its program at them where the
    # program needs to be told.
    preferXdgDirectories = true;

    # elan, Lean's toolchain manager, is not installed from here, so no
    # feature speaks for it: left alone it keeps its toolchains in ~/.elan.
    sessionVariables.ELAN_HOME = "${config.xdg.dataHome}/elan";

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "26.11";
  };

  xdg.enable = true;

  # GitHub as k, and only as k: left to offer every key the agent holds, a
  # bare ssh was refused with k's own and then accepted with fdnt7's, and
  # logged in as fdnt7.
  programs.ssh.settings."github.com" = {
    IdentityFile = "~/.ssh/id_ecdsa.pub";
    IdentitiesOnly = true;
  };

  # GitHub as fdnt7, under a name of its own, which the repository below
  # reaches it by. Naming fdnt7's key on ssh's command line was not enough:
  # that adds to the keys the host above lists, and ssh offers those the
  # agent holds in the agent's order, k's first, which GitHub accepts and
  # then refuses the push. The connection is otherwise the one f's
  # settings make to GitHub, read from their file as this option cannot
  # be read back while it is being set, on a socket of its own: sockets
  # are told apart by host, port and user, not by key, so it would
  # otherwise be k's, logged in as k.
  programs.ssh.settings."github.com-fdnt7" =
    (import ../../f/features/cli/ssh.nix).programs.ssh.settings."github.com"
    // {
      IdentityFile = "~/.ssh/id_ecdsa_fdnt7.pub";
      IdentitiesOnly = true;
      ControlPath = "\${XDG_RUNTIME_DIR}/ssh-fdnt7-%C";
    };

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
      # GitHub, for signing and for pushing: every GitHub remote here is
      # reached as github.com-fdnt7, the host above that offers only it.
      {
        condition = "gitdir:~/.config/nixos/";
        contents = {
          user = {
            name = "Fridella Nythell";
            email = "git@frdl.la";
            signingKey = "~/.ssh/id_ecdsa_fdnt7.pub";
          };
          url."git@github.com-fdnt7:".insteadOf = "git@github.com:";
        };
      }
    ];
  };
}

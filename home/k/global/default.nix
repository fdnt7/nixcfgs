# Home configuration shared by every host this user has an account on.
{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  # All the ssh settings there are for git in this configuration's
  # repository, which runs ssh on this file in place of ~/.ssh/config: with
  # that one unread, k's key is in no list ssh could take it from, whatever
  # the host is called. The connection to GitHub is the one f's settings
  # make, read from their file, on a socket of its own: sockets are told
  # apart by host, port and user, not by key, so it would otherwise be
  # k's, logged in as k.
  sshAsFdnt7 =
    let
      github = (import ../../f/features/cli/ssh.nix).programs.ssh.settings."github.com" // {
        ControlPath = "\${XDG_RUNTIME_DIR}/ssh-fdnt7-%C";
      };
    in
    pkgs.writeText "ssh-config-fdnt7" ''
      Host github.com
      ${lib.concatStrings (lib.mapAttrsToList (name: value: "  ${name} ${toString value}\n") github)}
      Host *
        IdentityFile ~/.ssh/id_ecdsa_fdnt7.pub
        IdentitiesOnly yes
    '';
in
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

  # Two accounts on GitHub, never to be taken for one another: k's
  # everywhere, and fdnt7's in this configuration's repository alone.
  #
  # Everywhere: ssh offers a host only the keys named for it, or k's own
  # where none is, and never whatever else the agent holds. Left to offer
  # them all, a bare ssh to GitHub was once refused with k's key, accepted
  # with fdnt7's, and logged in as fdnt7.
  programs.ssh.settings."*".IdentitiesOnly = true;
  programs.ssh.settings."github.com".IdentityFile = "~/.ssh/id_ecdsa.pub";

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
      # GitHub, for signing and for pushing, and the only key git's ssh is
      # given here. Naming it with ssh -i was not enough: that adds to the
      # keys ~/.ssh/config lists for the host, and ssh offers those the
      # agent holds in the agent's order, k's first, which GitHub accepts
      # and then refuses the push.
      {
        condition = "gitdir:~/.config/nixos/";
        contents = {
          user = {
            name = "Fridella Nythell";
            email = "git@frdl.la";
            signingKey = "~/.ssh/id_ecdsa_fdnt7.pub";
          };
          core.sshCommand = "ssh -F ${sshAsFdnt7}";
        };
      }
    ];
  };
}

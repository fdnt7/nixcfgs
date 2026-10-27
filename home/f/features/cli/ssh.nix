{
  programs.ssh = {
    enable = true;
    # The module's old defaults restate OpenSSH's own; nothing here wants them.
    enableDefaultConfig = false;

    # One connection to GitHub, shared: the first ssh logs in and leaves a
    # socket, and every fetch, push and note push after it goes through
    # that, with no new handshake and no new signature from the TPM-held key.
    # A round trip comes down from about 3.4 seconds to 0.8.
    #
    # The socket is told apart by host, port and user, not by key. k reaches
    # GitHub as two accounts, so its second one names a socket of its own:
    # ../../../k/global/default.nix.
    settings."github.com" = {
      # Over port 443, which GitHub serves SSH on as well: the home network
      # lets nothing out to port 22, to any host, so without Mullvad every
      # ssh to github.com hung. The host key is the same, and the alias
      # finds it under github.com, where ../../../../nixos/global/ssh.nix
      # puts it.
      Hostname = "ssh.github.com";
      Port = 443;
      HostKeyAlias = "github.com";

      ControlMaster = "auto";
      # In the runtime directory: private to the user, gone at logout, and
      # short, as a socket's path must be under 108 bytes.
      ControlPath = "\${XDG_RUNTIME_DIR}/ssh-%C";
      # Open until a sleep ends it: ../../../../nixos/global/ssh.nix.
      ControlPersist = "yes";
      # A connection that died under a suspend or a change of network is
      # given up within 20 seconds, rather than holding up whatever waits
      # on it.
      ServerAliveInterval = 10;
      ServerAliveCountMax = 2;
    };
  };
}

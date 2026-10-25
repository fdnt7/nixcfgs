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
    # Here and not with the shared features, which k has too: the socket is
    # told apart by host, port and user, not by key, and k reaches GitHub as
    # two accounts, so a push could go out logged in as the wrong one.
    settings."github.com" = {
      ControlMaster = "auto";
      # In the runtime directory: private to the user, gone at logout, and
      # short, as a socket's path must be under 108 bytes.
      ControlPath = "\${XDG_RUNTIME_DIR}/ssh-%C";
      ControlPersist = "5m";
      # A connection that died under a suspend or a change of network is
      # given up within 20 seconds, rather than holding up whatever waits
      # on it.
      ServerAliveInterval = 10;
      ServerAliveCountMax = 2;
    };
  };
}

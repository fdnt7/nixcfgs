{
  imports = [
    ./global

    # The terminal and development tools are f's, followed as they are.
    ../f/features/cli
    ./features/cli/git-abbreviations.nix
    ./features/cli/nix-tools.nix

    # Plasma brings its own shell, file manager, viewers and clipboard, so
    # only the programs are taken from f's desktop features.
    ../f/features/desktop/discord.nix
    ../f/features/desktop/fonts.nix
    ../f/features/desktop/kitty.nix
    ../f/features/desktop/mullvad.nix
    ../f/features/desktop/zed-editor.nix
    ../f/features/desktop/zen-browser.nix

    ./features/desktop/fonts-thai-cjk.nix
    ./features/desktop/haruna.nix
    ./features/desktop/line.nix
    ./features/desktop/obs-studio.nix
    ./features/desktop/okular.nix
    ./features/desktop/plasma.nix
    ./features/desktop/tailscale-systray.nix
    ./features/desktop/xournalpp.nix
  ];

  # f's machine, over the tailnet, as f, for work to run there: with the
  # key ssh-tpm-agent holds, sealed by this machine's TPM, named by its
  # public half. By its tailnet address, as MagicDNS is not taking the
  # system's DNS.
  programs.ssh.settings."fw16" = {
    Hostname = "100.127.15.43";
    User = "f";
    IdentityFile = "~/.ssh/id_ecdsa_fw16.pub";
    IdentitiesOnly = true;

    # Shared as GitHub's is (../f/features/cli/ssh.nix), and kept alive,
    # so that a long session is not given up on a quiet minute.
    ControlMaster = "auto";
    ControlPath = "\${XDG_RUNTIME_DIR}/ssh-%C";
    ControlPersist = "10m";
    ServerAliveInterval = 10;
    ServerAliveCountMax = 2;
  };
}

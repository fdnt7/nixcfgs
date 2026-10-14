{
  # Who commits is per user: ../../global, and ../../../k/global.
  programs.git = {
    enable = true;
    # The private half never leaves the machine's TPM; see ./ssh-tpm-agent.nix.
    signing = {
      format = "ssh";
      key = "~/.ssh/id_ecdsa.pub";
      signByDefault = true;
    };
  };
}

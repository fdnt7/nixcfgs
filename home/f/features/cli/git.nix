{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Fridella Nythell";
        email = "git@frdl.la";
      };
      # Keys whose signatures `git log --show-signature` accepts as mine.
      gpg.ssh.allowedSignersFile = "${./allowed-signers}";
    };
    # The private half never leaves the machine's TPM; see ./ssh-tpm-agent.nix.
    signing = {
      format = "ssh";
      key = "~/.ssh/id_ecdsa.pub";
      signByDefault = true;
    };
  };
}

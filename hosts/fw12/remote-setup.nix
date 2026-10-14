# TEMPORARY: lets fw16 finish this machine's setup over SSH. Remove this
# file and its import once that is done.
{ config, ... }:
{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
    # Straight on the persistent volume: generating a key through the
    # link that impermanence leaves in /etc would replace the link.
    hostKeys = [
      {
        path = "${config.impermanence.persist}/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
  };

  # f@fw16, whose private half is held by fw16's TPM. As root, because the
  # work needs it and sudo would ask for a password.
  users.users.root.openssh.authorizedKeys.keys = [
    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBG/rxf+jXjMCavVCHWPSN4pDiWzGW9wfp6HG/73bJiKKhE0+cX7FbGT7MPdExLcudQ52rUP+Vz9ny6BH9E2iLS4= f@fw16"
  ];
}

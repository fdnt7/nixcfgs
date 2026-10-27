# What would identify this machine's user, kept encrypted in ./secrets.yaml.
# Edit on this machine with
#   sudo SOPS_AGE_KEY_FILE=/persist/var/lib/sops-nix/key.txt \
#     sops edit hosts/fw12/secrets.yaml
# or on fw16, with f's key.
{ config, ... }:
let
  forK = {
    owner = "k";
    mode = "0400";
  };
in
{
  sops = {
    defaultSopsFile = ./secrets.yaml;

    # Git configuration, as included by ../../home/k/global: a `[user]`
    # section with the name and personal address, and one with the
    # university address.
    secrets."git/identity" = forK;
    secrets."git/identity-university" = forK;

    # The allowed-signers line for k's own signing key.
    secrets."git/allowed-signer" = forK;

    # Every key git on this machine accepts signatures from: f's, which
    # include the key this machine signs the configuration with, and k's.
    templates."git/allowed-signers" = forK // {
      content = ''
        ${builtins.readFile ../../home/f/global/allowed-signers}${
          config.sops.placeholder."git/allowed-signer"
        }
      '';
    };
  };
}

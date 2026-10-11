# Secure Boot with our own keys. Lanzaboote installs systemd-boot itself and
# signs the boot files, so import this in place of ./systemd-boot.nix.
#
# The keys are created once with `sbctl create-keys` and then enrolled into the
# firmware while it is in Setup Mode.
{
  config,
  inputs,
  pkgs,
  ...
}:
{
  imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
    configurationLimit = 20;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  environment.systemPackages = [
    # For debugging and troubleshooting Secure Boot.
    pkgs.sbctl
  ];

  environment.persistence.${config.impermanence.persist}.directories = [
    config.boot.lanzaboote.pkiBundle
  ];
}

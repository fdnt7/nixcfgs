# inputs needs to be added to your 'specialArgs' in the lib.nixosSystem call.
# In some setups, individual inputs are passed to specialArgs directly and as
# such your setup may differ just a little bit. Note that if you are not using
# flakes, inputs will not be available at all. In which case, you must manually
# fetch impermanence with fetchTarball, or use the appropriate channel. I
# recommend using flakes since they offer a better UX overall.
{
  inputs,
  nixcfgs,
  ...
}:
with nixcfgs;
{
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  environment.persistence.${persist} = {
    directories = [
      # "/etc/nixos"
      #"/etc/secureboot"
      "/var/db/sudo"

      "/var/lib/nixos"
      "/var/lib/systemd/backlight"

      {
        directory = flake;
        group = gname;
        mode = "u=rwx,g=rwx,o=";
      }
    ];

    files = [
      "/etc/machine-id"

      # Required for SSH. If you have keys with different algorithms, then
      # you must also persist them here.
      # "/etc/ssh/ssh_host_ed25519_key"
      # "/etc/ssh/ssh_host_ed25519_key.pub"
      # "/etc/ssh/ssh_host_rsa_key"
      # "/etc/ssh/ssh_host_rsa_key.pub"
      # if you use docker or LXD, also persist their directories
    ];
  };
}

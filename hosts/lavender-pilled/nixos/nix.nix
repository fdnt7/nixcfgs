{ nixcfgs, ... }:
{
  nix = {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Opinionated: disable global registry
      flake-registry = "";

      extra-trusted-users = [ nixcfgs.uname ];
    };
    # Opinionated: disable channels
    channel.enable = false;
  };
}

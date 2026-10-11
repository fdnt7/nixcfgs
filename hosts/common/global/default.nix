# Configuration shared by every host.
{
  imports = [
    ./impermanence.nix
    ./locale.nix
    ./nix.nix
    ./packages.nix
    ./sudo.nix
    ./users.nix
  ];
}

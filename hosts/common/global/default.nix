# Configuration shared by every host.
{
  imports = [
    ./fish.nix
    ./impermanence.nix
    ./locale.nix
    ./nix.nix
    ./packages.nix
    ./ssh.nix
    ./sudo.nix
    ./users.nix
  ];
}

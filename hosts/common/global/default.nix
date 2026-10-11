# Configuration shared by every host.
{
  imports = [
    ./bash.nix
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

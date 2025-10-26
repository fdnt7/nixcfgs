{
  imports = [
    ./android.nix
    ./bash.nix
    ./cargo.nix
    ./delta.nix
    ./devenv.nix
    ./direnv.nix
    ./eza.nix
    ./fish.nix
    ./git.nix
    ./mullvad-vpn.nix
    ./neovim.nix
    ./nh.nix
    ./nix-your-shell.nix
    ./python.nix
    ./rebuild.nix
    ./ripgrep.nix
    ./spotify.nix
    ./starship.nix
    ./yazi
    ./wget.nix
    ./zed-editor.nix
    ./zoxide.nix
  ];

  # Enable home-manager and git
  # programs.home-manager.enable = true;
}

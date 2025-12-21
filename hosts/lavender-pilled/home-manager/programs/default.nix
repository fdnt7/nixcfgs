{
  imports = [
    ./android.nix
    ./bash.nix
    ./cargo.nix
    ./codex.nix
    ./delta.nix
    ./devenv.nix
    ./direnv.nix
    ./discord
    ./eza.nix
    ./fish.nix
    ./git.nix
    ./man.nix
    ./mullvad-vpn.nix
    ./neovim.nix
    ./nh.nix
    ./nix-index.nix
    ./nix-index-database.nix
    ./nix-your-shell.nix
    ./python.nix
    ./rebuild.nix
    ./ripgrep.nix
    ./spotify.nix
    ./starship.nix
    ./wakatime.nix
    ./wget.nix
    ./yazi
    ./zed-editor.nix
    ./zoxide.nix
  ];

  # Enable home-manager and git
  # programs.home-manager.enable = true;
}

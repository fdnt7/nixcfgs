{
  nix.settings = {
    # Enable flakes and new 'nix' command
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  # Disable if you don't want unfree packages
  nixpkgs.config.allowUnfree = true;
}

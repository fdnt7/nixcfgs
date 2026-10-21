{
  nix.settings = {
    # Enable flakes and new 'nix' command
    experimental-features = [
      "nix-command"
      "flakes"
    ];

    # Profiles and channels under ~/.local/state/nix, not ~/.nix-profile
    # and ~/.nix-defexpr.
    use-xdg-base-directories = true;
  };

  # Disable if you don't want unfree packages
  nixpkgs.config.allowUnfree = true;
}

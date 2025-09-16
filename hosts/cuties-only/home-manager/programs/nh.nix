{nixcfgs, ...}: {
  programs.nh = {
    enable = true;
    clean.enable = true;

    # requires `programs.fish.enable = true` in home-manager
    flake = nixcfgs.flake;
  };
}

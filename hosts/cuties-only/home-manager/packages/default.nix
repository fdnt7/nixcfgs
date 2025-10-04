{pkgs, ...}: {
  imports = [
    ./brave.nix
    ./brightnessctl.nix
    ./devenv.nix
    ./grimblast.nix
    ./nix-your-shell.nix
  ];

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];
  home.packages = with pkgs; [
    kdePackages.okular
    muse-sounds-manager
    musescore
    tenacity
  ];
}

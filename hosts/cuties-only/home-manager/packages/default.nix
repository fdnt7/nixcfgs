{
  lib,
  nixcfgs,
  pkgs,
  ...
}: {
  imports =
    [
      ./brave.nix
      ./brightnessctl.nix
      ./devenv.nix
      ./grimblast.nix
      ./nix-your-shell.nix
    ]
    ++ lib.optional nixcfgs.enableWinBoat ./winboat.nix;

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];
  home.packages = with pkgs; [
    kdePackages.okular
    muse-sounds-manager
    musescore
    osu-lazer-bin
    tenacity
    prismlauncher
  ];
}

{pkgs, ...}: {
  imports = [
    ./brave.nix
    ./nix-your-shell.nix
  ];

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];
  home.packages = with pkgs; [brightnessctl];
}

{
  inputs,
  pkgs,
  ...
}: {
  nixpkgs.overlays = [inputs.nix-your-shell.overlays.default];

  home.packages = [pkgs.nix-your-shell];

  programs.fish.interactiveShellInit = "nix-your-shell fish | source";
}

# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  config,
  inputs,
  lib,
  nixcfgs,
  outputs,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
    ./appearance
    ./fonts
    ./nix-community.nix
    ./nixpkgs.nix
    ./packages
    ./programs
    ./services
    ./sops.nix
    ./systemd.nix
    ./wakatime.nix
    ./xdg.nix
  ];

  home = with nixcfgs; {
    username = uname;
    homeDirectory = "/home/${uname}";

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "25.11";
  };
}

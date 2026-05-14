{ pkgs, nixcfgs, ... }:
{
  programs.gamemode.enable = true;
  # workaround for https://github.com/NixOS/nixpkgs/issues/433514
  environment.etc."polkit-1/rules.d/gamemode.rules".source =
    "${pkgs.gamemode}/share/polkit-1/rules.d/gamemode.rules";
  users.users.${nixcfgs.uname}.extraGroups = [ "gamemode" ];
}

{ pkgs, ... }:
{
  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];
  home.packages =
    let
      inherit (pkgs)
        brave
        xournalpp
        ;
    in
    [
      brave
      xournalpp
    ];
}

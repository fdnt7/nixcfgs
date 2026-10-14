{ inputs, ... }:
{
  # LINE has no Linux client; this runs the Windows one under Wine.
  imports = [ inputs.line-nix.homeManagerModules.default ];
  programs.line-messenger.enable = true;
}

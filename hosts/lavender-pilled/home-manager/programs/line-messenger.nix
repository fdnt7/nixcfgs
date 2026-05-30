{ inputs, ... }:
{
  imports = [ inputs.line-nix.homeManagerModules.default ];
  programs.line-messenger.enable = true;
}

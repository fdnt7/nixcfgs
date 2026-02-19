{ pkgs, ... }:
{
  environment.systemPackages =
    let
      inherit (pkgs.kdePackages) plasma-keyboard qtvirtualkeyboard;
    in
    [
      plasma-keyboard
      qtvirtualkeyboard # also needed as stated in https://github.com/NixOS/nixpkgs/issues/465720#issuecomment-3587186800
    ];
}

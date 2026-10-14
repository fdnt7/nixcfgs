{ pkgs, ... }:
{
  # On-screen keyboard for Plasma on a touchscreen. It needs Qt's virtual
  # keyboard module beside it:
  # https://github.com/NixOS/nixpkgs/issues/465720#issuecomment-3587186800
  environment.systemPackages = [
    pkgs.kdePackages.plasma-keyboard
    pkgs.kdePackages.qtvirtualkeyboard
  ];
}

{ pkgs, ... }:
let
  # DankMaterialShell's backdrop in its purple theme, redrawn: the theme's
  # background, two slanted bands in its primary and secondary colours and
  # the shell's logo in a corner. In the shell's own units, 2048 by 1280
  # for the panel at its scale of 1.25, and rendered at the panel's size.
  # spellchecker:off
  svg = pkgs.writeText "wallpaper.svg" ''
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 2048 1280">
      <defs>
        <filter id="tint">
          <feFlood flood-color="#d0bcff" />
          <feComposite in2="SourceAlpha" operator="in" />
        </filter>
      </defs>
      <rect width="2048" height="1280" fill="#141218" />
      <rect x="1433.6" y="-384" width="1638.4" height="1920"
        fill="#d0bcff" fill-opacity="0.16"
        transform="rotate(35 2252.8 576)" />
      <rect x="1740.8" y="-256" width="819.2" height="1536"
        fill="#ccc2dc" fill-opacity="0.08"
        transform="rotate(35 2150.4 512)" />
      <image x="48" y="1006.95" width="200" height="225.05" opacity="0.25"
        filter="url(#tint)"
        href="${pkgs.dms-shell.src}/quickshell/assets/danklogonormal.svg" />
    </svg>
  '';
  # spellchecker:on

  wallpaper = pkgs.runCommand "wallpaper.png" { nativeBuildInputs = [ pkgs.resvg ]; } ''
    resvg --width 2560 ${svg} $out
  '';
in
{
  # The wallpaper is drawn by wpaperd rather than the shell, for two
  # reasons: it is up well before the shell is, and it fades the picture
  # in from black, as niri's background is, which the shell cannot. The
  # shell's own wallpaper is turned off in ./dms.nix.
  services.wpaperd = {
    enable = true;
    settings.default = {
      path = "${wallpaper}";
      # The fade at startup. Off unless asked for, whatever the manual
      # says of its default; the time is in milliseconds.
      initial-transition = true;
      transition-time = 500;
    };
  };
}

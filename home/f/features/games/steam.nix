{ config, ... }:
{
  # Steam itself is system-wide: ../../../../hosts/common/optional/gaming.nix.
  # Its runtime bundles PulseAudio 1.1, which keeps its cookie in
  # ~/.pulse-cookie. Point it at the one current clients already use. It
  # has to be this file: that version creates the default cookie before it
  # reads PULSE_COOKIE.
  xdg.configFile."pulse/client.conf".text = ''
    cookie-file = ${config.xdg.configHome}/pulse/cookie
  '';
}

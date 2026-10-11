{ pkgs, ... }:
{
  # Starts from niri's own default config and changes only what differs:
  # later definitions override the included ones, key by key for binds.
  wayland.windowManager.niri = {
    enable = true;
    enableDefaultConfig = true;
    extraConfig = ''
      input {
          keyboard {
              xkb {
                  layout "us,th"
                  // Caps Lock is Escape; Super+Space switches layout.
                  options "caps:escape,grp:win_space_toggle"
              }

              repeat-delay 200
              repeat-rate 40
          }

          mouse {
              accel-profile "flat"
          }
      }

      // No title bars: ask clients to leave decorations to the compositor.
      prefer-no-csd

      layout {
          gaps 8

          focus-ring {
              width 2
          }
      }

      binds {
          Mod+Return hotkey-overlay-title="Open a Terminal: foot" { spawn "footclient"; }
          Mod+W repeat=false { close-window; }
          // G for group, as in Hyprland.
          Mod+G { toggle-column-tabbed-display; }
          Mod+T hotkey-overlay-title=null { spawn "footclient"; }
          Mod+D hotkey-overlay-title="Run an Application: rofi" { spawn "rofi" "-show" "drun"; }
          Super+Alt+L hotkey-overlay-title="Lock the Screen: hyprlock" { spawn "loginctl" "lock-session"; }
      }
    '';
  };

  # What the default binds call for the media and brightness keys.
  home.packages = [
    pkgs.brightnessctl
    pkgs.playerctl
  ];

  # Password prompts for privileged actions requested by graphical programs.
  services.polkit-gnome.enable = true;
}

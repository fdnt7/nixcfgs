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

          // Hover focuses a window only if that will not scroll the view.
          focus-follows-mouse max-scroll-amount="0%"
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
          // The launcher, clipboard history and lock screen are the shell's:
          // ../../../../hosts/common/optional/dms.nix.
          Mod+Return hotkey-overlay-title="Open a Terminal: foot" { spawn "footclient"; }
          Mod+W repeat=false { close-window; }
          // G for group, as in Hyprland.
          Mod+G { toggle-column-tabbed-display; }
          // Unbound: the included defaults cannot be removed, only overridden,
          // and niri has no do-nothing action.
          Mod+T hotkey-overlay-title=null { spawn "true"; }
          Mod+D hotkey-overlay-title="Run an Application" { spawn "dms" "ipc" "call" "spotlight" "toggle"; }
          Super+Alt+L hotkey-overlay-title="Lock the Screen" { spawn "dms" "ipc" "call" "lock" "lock"; }
          Mod+Alt+V hotkey-overlay-title="Clipboard History" { spawn "dms" "ipc" "call" "clipboard" "toggle"; }
      }
    '';
  };

  # What the default binds call for the media and brightness keys.
  home.packages = [
    pkgs.brightnessctl
    pkgs.playerctl
  ];
}

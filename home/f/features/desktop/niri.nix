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
          // The launcher on its power actions: Q, then type to pick one.
          Mod+Q hotkey-overlay-title="Power Menu" { spawn "dms" "ipc" "call" "spotlight" "toggleQuery" "pw "; }

          // Send the column to a workspace and stay here; Mod+Ctrl follows it.
          Mod+Shift+1 { move-column-to-workspace 1 focus=false; }
          Mod+Shift+2 { move-column-to-workspace 2 focus=false; }
          Mod+Shift+3 { move-column-to-workspace 3 focus=false; }
          Mod+Shift+4 { move-column-to-workspace 4 focus=false; }
          Mod+Shift+5 { move-column-to-workspace 5 focus=false; }
          Mod+Shift+6 { move-column-to-workspace 6 focus=false; }
          Mod+Shift+7 { move-column-to-workspace 7 focus=false; }
          Mod+Shift+8 { move-column-to-workspace 8 focus=false; }
          Mod+Shift+9 { move-column-to-workspace 9 focus=false; }
      }
    '';
  };

  # What the default binds call for the media and brightness keys.
  home.packages = [
    pkgs.brightnessctl
    pkgs.playerctl
  ];
}

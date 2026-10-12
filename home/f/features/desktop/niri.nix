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

      // Fixed workspaces, always present and first in this order, so that
      // Mod+1 to Mod+3 reach them. Everything after them comes and goes.
      workspace "web"
      workspace "code"
      workspace "games"

      window-rule {
          match app-id="^zen"
          open-on-workspace "web"
      }

      window-rule {
          match app-id=r#"^dev\.zed\.Zed$"#
          open-on-workspace "code"
      }

      // Launchers and what they start. Steam games are "steam_app_<id>".
      window-rule {
          match app-id="^steam$"
          match app-id=r#"^steam_app_\d+$"#
          match app-id=r#"^org\.prismlauncher\.PrismLauncher$"#
          match app-id="(?i)minecraft"
          match app-id="^osu!"
          open-on-workspace "games"
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

          // Back to the workspace last shown.
          Mod+BackSpace { focus-workspace-previous; }

          // Fullscreen for the application only: it fills its own tile.
          Mod+Ctrl+Shift+F { toggle-windowed-fullscreen; }

          // Swap with the window in the next column; the plain brackets move
          // the window into or out of that column.
          Mod+Ctrl+BracketLeft { swap-window-left; }
          Mod+Ctrl+BracketRight { swap-window-right; }

          // Retarget a running screen share. The display key (F9) on the
          // Framework keyboard sends Super+P.
          Mod+P { set-dynamic-cast-window; }
          Mod+Ctrl+P { set-dynamic-cast-monitor; }
      }
    '';
  };

  # What the default binds call for the media and brightness keys.
  home.packages = [
    pkgs.brightnessctl
    pkgs.playerctl
  ];
}

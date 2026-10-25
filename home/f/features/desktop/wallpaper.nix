{ pkgs, ... }:
let
  # Bloom, the second of Dux Shell's material wallpapers, drawn by the shell's
  # own code from the package's source, so it follows the shell as it
  # changes: its canvas, coloured by its theme as it starts with no settings
  # of its own, purple and dark, which is the theme in use here. It is drawn
  # at the panel's size, 2048 by 1280 at its scale of 1.25, where the
  # pattern's tiles come out the size the shell would draw them.
  render = pkgs.writeText "shell.qml" ''
    import QtQuick
    import Quickshell
    import qs.Widgets
    import "DCommon/Common/MaterialWallpaper.js" as MaterialWallpaper

    ShellRoot {
        FloatingWindow {
            implicitWidth: 2048
            implicitHeight: 1280
            visible: true

            MaterialWallpaper {
                id: wallpaper
                anchors.fill: parent
                composition: MaterialWallpaper.preset("bloom")
                // ready once the pattern has loaded and the canvas is painted
                onReadyChanged: if (ready) Qt.callLater(save)

                function save() {
                    wallpaper.grabToImage(result => {
                        result.saveToFile(Quickshell.env("out"));
                        Qt.quit();
                    });
                }
            }
        }
    }
  '';

  # The theme takes in most of the shell, which wants a Wayland compositor
  # with layer shell to load: sway, headless and drawing in software, is
  # one that runs in the build. Unwrapped, as the wrapper starts a D-Bus
  # session, which there is no bus daemon in the build for.
  wallpaper =
    pkgs.runCommand "wallpaper.png"
      {
        nativeBuildInputs = [
          pkgs.quickshell
          pkgs.sway-unwrapped
        ];
      }
      ''
        # The shell's QML as it unpacks it at run time: its own tree, whose
        # link to the shared widgets beside it holds in a copy of the whole
        # source; the shell's entry point is swapped for the one above.
        cp -r ${pkgs.dux-shell.src} source
        chmod -R u+w source
        cp ${render} source/quickshell/shell.qml

        mkdir -m 700 run
        export HOME=$PWD XDG_RUNTIME_DIR=$PWD/run
        export WLR_BACKENDS=headless WLR_RENDERER=pixman WLR_LIBINPUT_NO_DEVICES=1
        # an output the panel's size, which the window fills at its scale,
        # tiled and bare
        cat > sway.conf <<'EOF'
        output * resolution 2560x1600
        default_border none
        for_window [title=".*"] floating disable
        EOF
        sway --config sway.conf &
        for _ in $(seq 100); do
          [ -S run/wayland-1 ] && break
          sleep 0.1
        done

        WAYLAND_DISPLAY=wayland-1 QT_QPA_PLATFORM=wayland QT_QUICK_BACKEND=software \
          QT_SCALE_FACTOR=1.25 \
          timeout 60 quickshell --path source/quickshell
        kill %1
        test -s $out
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

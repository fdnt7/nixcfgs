{ inputs, ... }:
{
  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      inputs.self.overlays.additions
      inputs.self.overlays.modifications
      inputs.self.overlays.unstable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
      #

      # temp fix for vesktop build failure
      # ref: https://github.com/NixOS/nixpkgs/issues/476669#issuecomment-3707850520
      (final: prev: {
        vesktop = prev.vesktop.overrideAttrs (old: {
          preBuild = ''
            cp -r ${prev.electron.dist} electron-dist
            chmod -R u+w electron-dist
          '';
          buildPhase = ''
            runHook preBuild

            pnpm build
            pnpm exec electron-builder \
              --dir \
              -c.asarUnpack="**/*.node" \
              -c.electronDist="electron-dist" \
              -c.electronVersion=${prev.electron.version}

            runHook postBuild
          '';
        });
      })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };
}

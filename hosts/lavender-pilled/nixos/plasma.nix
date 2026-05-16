{
  services.displayManager.plasma-login-manager.enable = true;
  services.desktopManager.plasma6.enable = true;

  # PLM greeter reads PreselectedSession from /etc/plasmalogin.conf via KConfig,
  # not from /etc/plasmalogin.conf.d/ (which only the daemon's ConfigReader parses).
  environment.etc."plasmalogin.conf".text = ''
    [Greeter]
    PreselectedSession=plasma.desktop
  '';

  # Drop the kded plugin that pre-creates ~/.var/app/<browser>/ stubs for
  # Flatpak browsers we don't use. The rest of plasma-browser-integration
  # (host binary, krunner plugins, reminder module) is untouched.
  nixpkgs.overlays = [
    (_final: prev: {
      kdePackages = prev.kdePackages.overrideScope (
        _kfinal: kprev: {
          plasma-browser-integration = kprev.plasma-browser-integration.overrideAttrs (old: {
            postInstall = (old.postInstall or "") + ''
              rm -f $out/lib/qt-6/plugins/kf6/kded/browserintegrationflatpakintegrator.so
            '';
          });
        }
      );
    })
  ];

  persist.power-profiles-daemon = true;
}

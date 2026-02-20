{
  services.displayManager.plasma-login-manager.enable = true;
  services.desktopManager.plasma6.enable = true;

  # PLM greeter reads PreselectedSession from /etc/plasmalogin.conf via KConfig,
  # not from /etc/plasmalogin.conf.d/ (which only the daemon's ConfigReader parses).
  environment.etc."plasmalogin.conf".text = ''
    [Greeter]
    PreselectedSession=plasma.desktop
  '';

  persist.power-profiles-daemon = true;
}

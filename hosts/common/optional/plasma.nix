{
  # KDE Plasma with its own login manager.
  services.desktopManager.plasma6.enable = true;
  services.displayManager.plasma-login-manager.enable = true;

  # The greeter reads its preselected session from this file through
  # KConfig; only the daemon parses /etc/plasmalogin.conf.d.
  environment.etc."plasmalogin.conf".text = ''
    [Greeter]
    PreselectedSession=plasma.desktop
  '';
}

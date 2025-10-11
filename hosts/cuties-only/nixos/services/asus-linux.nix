{
  services = {
    power-profiles-daemon.enable = true;
    supergfxd = {
      enable = true;
    };
    asusd = {
      enable = true;
      enableUserService = true;
    };
  };
}

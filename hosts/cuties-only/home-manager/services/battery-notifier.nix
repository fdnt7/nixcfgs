{ outputs, ... }:
{
  imports = [ outputs.homeManagerModules.battery-notifier ];

  services.battery-notifier.enable = true;
}

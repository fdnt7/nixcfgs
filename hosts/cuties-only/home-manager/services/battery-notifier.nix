{ inputs, ... }:
{
  imports = [ inputs.self.homeManagerModules.battery-notifier ];

  services.battery-notifier.enable = true;
}

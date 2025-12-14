{
  inputs,
  nixcfgs,
  ...
}:
{
  imports = [ inputs.self.homeManagerModules.rebuild ];

  programs.rebuild = {
    enable = true;
    hostName = nixcfgs.hostName;
  };
}

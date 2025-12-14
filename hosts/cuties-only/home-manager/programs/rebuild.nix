{
  inputs,
  nixcfgs,
  ...
}:
{
  imports = [ inputs.self.homeManagerModules.rebuild ];

  programs.rebuild = with nixcfgs; {
    enable = true;
    hostName = hostName;
  };
}

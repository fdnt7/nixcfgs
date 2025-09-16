{
  nixcfgs,
  outputs,
  ...
}: {
  imports = [outputs.homeManagerModules.rebuild];

  programs.rebuild = with nixcfgs; {
    enable = true;
    hostName = hostName;
  };
}

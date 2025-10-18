{
  nixcfgs,
  outputs,
  ...
}: {
  imports = [outputs.homeManagerModules.rebuild];

  programs.rebuild = {
    enable = true;
    hostName = nixcfgs.hostName;
  };
}

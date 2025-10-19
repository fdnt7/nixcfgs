{
  config,
  nixcfgs,
  ...
}:
{
  programs.fish.enable = true;
  users.users.${nixcfgs.uname}.shell = config.programs.fish.package;
}

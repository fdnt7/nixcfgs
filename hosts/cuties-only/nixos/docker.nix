{ nixcfgs, ... }:
{
  virtualisation.docker = {
    enable = true;
  };

  users.users.${nixcfgs.uname}.extraGroups = [ "docker" ];
}

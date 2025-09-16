{
  config,
  nixcfgs,
  pkgs,
  ...
}: let
  uname = nixcfgs.uname;
in {
  users = {
    users = {
      ${uname} = {
        isNormalUser = true;
        # openssh.authorizedKeys.keys = [
        # ];
        extraGroups = ["wheel" "networkmanager"];
      };
    };
    groups.nixcfgs.members = [uname];
  };
}

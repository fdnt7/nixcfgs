{
  config,
  nixcfgs,
  pkgs,
  ...
}:
let
  uname = nixcfgs.uname;
  hashedPassword = "nixos/users/users/0/hashedPassword";
in
{
  users = {
    users = {
      ${uname} = {
        isNormalUser = true;
        # openssh.authorizedKeys.keys = [
        # ];
        hashedPasswordFile = config.sops.secrets.${hashedPassword}.path;
        extraGroups = [
          "wheel"
          "networkmanager"
        ];
      };
    };
    groups.nixcfgs.members = [ uname ];
  };

  sops.secrets.${hashedPassword}.neededForUsers = true;
}

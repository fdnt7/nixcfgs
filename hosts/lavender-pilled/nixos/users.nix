{
  nixcfgs,
  pkgs,
  ...
}:
let
  inherit (nixcfgs) uname gname;
in
{
  users.users.${uname} = {
    openssh.authorizedKeys.keys = [ ];
    isNormalUser = true;
    extraGroups = [ "wheel" ];

    shell = pkgs.fish;
  };
  users.groups.${gname}.members = [ uname ];

  secrets.userPassword = {
    enable = true;
    name = uname;
  };
}

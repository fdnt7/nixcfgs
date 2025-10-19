{
  nixcfgs,
  pkgs,
  ...
}:
let
  inherit (nixcfgs) uname gname;
in
{
  users = {
    users = {
      ${uname} = {
        isNormalUser = true;
        openssh.authorizedKeys.keys = [
        ];
        extraGroups = [ "wheel" ];

        shell = pkgs.fish;
      };
    };
    groups.${gname}.members = [ uname ];
  };

  secrets.userPassword = {
    enable = true;
    name = uname;
  };
}

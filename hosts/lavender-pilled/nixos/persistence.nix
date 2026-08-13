{
  inputs,
  nixcfgs,
  ...
}:
{
  imports = [ inputs.self.nixosModules.persistence ];

  persist =
    let
      inherit (nixcfgs) flake gname persist;
    in
    {
      root = persist;
      machineId = true;
      flake = {
        enable = true;
        root = flake;
        group = gname;
      };
    };
}

{
  nixcfgs,
  outputs,
  ...
}: {
  imports = [outputs.nixosModules.persistence];

  persist = let
    inherit (nixcfgs) flake gname persist;
  in {
    root = persist;
    flake = {
      enable = true;
      root = flake;
      group = gname;
    };
  };
}

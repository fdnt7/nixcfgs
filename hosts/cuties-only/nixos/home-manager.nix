{
  inputs,
  nixcfgs,
  outputs,
  ...
}:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs nixcfgs; };
    users = {
      # Import your home-manager configuration
      ${nixcfgs.uname} = import ../home-manager/home.nix;
    };
  };
}

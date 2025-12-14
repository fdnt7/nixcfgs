{ inputs, ... }:
{
  imports = [ inputs.self.nixosModules.impermanence ];

  impermanence.enable = true;
}

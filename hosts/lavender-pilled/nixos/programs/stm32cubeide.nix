{ inputs, ... }:
{
  imports = [ inputs.stm32cubeide.nixosModules.default ];

  programs.stm32cubeide.enable = true;
}

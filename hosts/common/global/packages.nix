{ pkgs, ... }:
{
  # Tools every host wants for root as well as for users. Anything personal
  # belongs in Home Manager, under ../../../home.
  programs.git.enable = true;
  programs.vim.enable = true;

  # Packages without a module of their own.
  environment.systemPackages = [ pkgs.zstd ];
}

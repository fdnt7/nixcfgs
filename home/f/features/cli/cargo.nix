{ config, ... }:
{
  # No Rust toolchain is installed for its own sake: each project's dev shell
  # brings its own, and its cargo keeps the registry and caches in ~/.cargo
  # unless told where they belong.
  programs.cargo = {
    enable = true;
    package = null;
    cargoHome = "${config.xdg.dataHome}/cargo";
  };
}

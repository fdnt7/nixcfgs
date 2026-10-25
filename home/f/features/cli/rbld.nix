{ inputs, ... }:
{
  # On the path everywhere, not only in this flake's dev shell: rbld runs from
  # any directory, on the flake nh names, and the scope hook here calls it too.
  imports = [ inputs.rbld.homeModules.default ];

  programs.rbld.enable = true;
}

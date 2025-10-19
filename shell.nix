{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  packages =
    let
      inherit (pkgs) nixd nixfmt nixfmt-tree;
    in
    [
      nixd
      nixfmt
      nixfmt-tree
    ];
}

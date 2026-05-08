{
  programs = {
    man = {
      man-db.enable = false;
      mandoc.enable = true;
    };
    fish.shellAbbrs = {
      mc = "man configuration.nix";
      mh = "man home-configuration.nix";
      mn = "man nixvim";
    };
  };
}

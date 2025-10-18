{
  programs.git = {
    enable = true;
    config = {
      init.defaultBranch = "main";
      safe.directory = "/etc/nixcfgs";
    };
  };
}

{ config, inputs, ... }:
{
  imports = [ inputs.zen-browser.homeModules.beta ];
  programs.zen-browser.enable = true;

  # The default browser: web links and HTML files.
  xdg.mimeApps.defaultApplicationPackages = [ config.programs.zen-browser.finalPackage ];
}

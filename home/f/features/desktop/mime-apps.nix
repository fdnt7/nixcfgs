{
  # Which program opens which kind of file or link. Each feature adds its
  # own: by package, taking every type the program's desktop entry claims,
  # or by name where the entry is not a package's.
  xdg.mimeApps.enable = true;

  # Programs register themselves by rewriting this file, which replaces
  # the link to the declared one. Put it back rather than stop on it.
  xdg.configFile."mimeapps.list".force = true;
  xdg.dataFile."applications/mimeapps.list".force = true;
}

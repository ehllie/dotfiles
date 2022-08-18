{
  opts = {
    user = "{{user}}";
    host = "{{host}}";
  };
  preset = "{{preset}}";
  # Machine specific nix modules
  localModules = [
    # ./hardware.nix
  ];
}

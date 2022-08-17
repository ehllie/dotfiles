{
  description = "Depends on the dotfile flake as an input";

  inputs = { };

  outputs = { ... }: {
    config = {
      opts = {
        user = "{{user}}";
        host = "{{host}}";
      };
      preset = "{{preset}}";
      localModules = [ ./hardware ];
    };
  };

}

{
  config = {
    opts = {
      user = "{{user}}";
      host = "{{host}}";
    };
    preset = "{{preset}}";
    localModules = [ ./hardware ];
  };
}

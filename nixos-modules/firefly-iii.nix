{ config, ... }:
let
  secrets = config.sops.secrets;
in
{
  sops.secrets = {
    firefly-app-secret = {
      owner = config.services.firefly-iii.user;
      group = config.services.firefly-iii.group;
      name = "firefly-app-secret";
      sopsFile = ../sops/firefly.json;
      format = "json";
      key = "app_secret";
    };

    nordigen_id = {
      owner = config.services.firefly-iii-data-importer.user;
      group = config.services.firefly-iii-data-importer.group;
      name = "gocardless_id";
      sopsFile = ../sops/firefly.json;
      format = "json";
      key = "nordigen_id";
    };

    nordigen_key = {
      owner = config.services.firefly-iii-data-importer.user;
      group = config.services.firefly-iii-data-importer.group;
      name = "gocardless_key";
      sopsFile = ../sops/firefly.json;
      format = "json";
      key = "nordigen_key";
    };
  };

  services = {
    firefly-iii = {
      enable = true;
      enableNginx = true;
      virtualHost = "budget.ehllie.xyz";
      settings = {
        SITE_OWNER = "ffadmin@ehllie.xyz";
        MAIL_FROM = "ffadmin@ehllie.xyz";
        MAIL_MAILER = "log";
        APP_DEBUG = "true";
        APP_LOG_LEVEL = "debug";
        LOG_CHANNEL = "stack";
        APP_KEY_FILE = secrets.firefly-app-secret.path;
      };
    };

    firefly-iii-data-importer = rec {
      enable = true;
      virtualHost = "import.ehllie.xyz";
      enableNginx = true;
      settings = rec {
        TRUSTED_PROXIES = "*";
        FIREFLY_III_URL = "https://${config.services.firefly-iii.virtualHost}";
        FIREFLY_III_CLIENT_ID = "3";
        VANITY_URL = FIREFLY_III_URL;
        SIMPLEFIN_CORS_ORIGIN_URL = "https://${virtualHost}";
        NORDIGEN_ID_FILE = secrets.nordigen_id.path;
        NORDIGEN_KEY_FILE = secrets.nordigen_key.path;
      };
    };
  };
}

{ pkgs, settings, ... }: rec {
  services.grafana = {
    enable = true;
    settings.server = {
      domain = "grafana.eskaan.de";
      http_port = 4001;
      http_addr = "127.0.0.1";
    };
  };

  services.nginx.virtualHosts.${services.grafana.settings.server.domain} = {
    locations."/" = {
        proxyPass = "http://127.0.0.1:${toString services.grafana.settings.server.http_port}";
	extraConfig = ''
	  proxy_set_header Host $host;
	'';
        proxyWebsockets = true;
    };
  };

  services.prometheus = {
    enable = true;
    port = 4030;
    #extraFlags = [ "--web.enable-admin-api" ];

    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 4031;
      };
      zfs = {
        enable = true;
	port = 4032;
      };
      nginx = {
        enable = true;
	port = 4033;
      };
    };
    scrapeConfigs = [
      {
        job_name = "local";
        static_configs = [{
          targets = [ 
	    "127.0.0.1:${toString services.prometheus.exporters.node.port}"
	    "127.0.0.1:${toString services.prometheus.exporters.zfs.port}"
	    "127.0.0.1:${toString services.prometheus.exporters.nginx.port}"
	  ];
        }];
      }
    ];
  };
  services.nginx.statusPage = true;
}

{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./modules/bundle.nix
    ];

  # Use the systemd-boot loader.
  boot.loader.systemd-boot.enable = true;
  
  networking.hostName = "mainsrv";
  networking.interfaces."enp3s0".wakeOnLan.enable = true;

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "de-latin1";
  };

  users.mutableUsers = false;

  environment.systemPackages = with pkgs; [
    neovim
    wget
    curl
    git
    htop
    lm_sensors
    amdctl
    linuxPackages.cpupower
    ethtool
  ];

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };

  programs = {
    bash = {
      shellAliases = {
        vim = "nvim";
        e = "exit";
        c = "clear";
	rb = "nixos-rebuild switch";
	update = "nix-channel --update && nixos-rebuild switch --upgrade-all";
      };
    };
    git = {
      enable = true;
      config = {
        user = {
	  name = "Eskaan";
	  email = "github@eskaan.de";
	};
        init = {
         defaultBranch = "main";
        };
      };
    };
    neovim = {
      configure = ''
        set tabstop=2
        set expandtab
      '';
      defaultEditor = true;
    };
  };

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 25565 ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # First installed version for legacy reasons (do not change).
  system.stateVersion = "23.11";
}


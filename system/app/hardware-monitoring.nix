{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
      # Sensors and monitors
    htop
    lm_sensors
    i2c-tools
    hdparm
    smartmontools
    amdctl
    linuxPackages.cpupower
    ethtool

    stress
  ];
}

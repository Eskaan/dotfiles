{ lib, pkgs, settings, ... }:

{
    # Use the systemd-boot loader.
  boot.loader.systemd-boot.enable = (settings.system.bootMode == "uefi");
  boot.loader.grub.enable = (settings.system.bootMode == "bios");
  networking.hostName = settings.system.hostname;
  time.timeZone = settings.system.timezone;
  i18n.defaultLocale = settings.system.locale;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  console = {
    font = "Lat2-Terminus16";
    keyMap = "de-latin1";
  };
}
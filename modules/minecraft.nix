{ config, lib, pkgs, ... }:

{
  users.groups.minecraft = {};
  users.users.minecraft = {
    isSystemUser = true;
    group = "minecraft";
    home = "/home/minecraft";
    homeMode = "770";
    packages = with pkgs; [
      temurin-jre-bin
      tmux
    ];
  };
}

{ pkgs, settings, ... }: rec {
  # Format and install from nothing
  installer = import ./installer.nix { inherit pkgs; };

  # Niot (nixos-tools): Scripts for system maintenance
  installer = import ./niot.nix { inherit pkgs settings; };
}
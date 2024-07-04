{ pkgs, settings, ... }: {
  type = "app";

  program = builtins.toString (
    pkgs.writeShellScript "niot" ''
      #!/bin/sh
      set -e

      if [ $# == 0 ]; then
        $0 sync
        exit 0
      fi
      case $1 in:
        "sync")
          if [ $# == 1 ]]; then
            $0 sync system
            $0 sync user
          fi
          case $2 in:
            "user")
              home-manager switch --flake "${settings.user.dotfilesDir}#user"
              ;;
            "system")
              sudo nixos-rebuild switch --flake "${settings.user.dotfilesDir}#system"
              ;;
            *)
              echo "Usage: $0 sync [system|user]"
              echo "Sync system or user configuration to config directory."
              echo "If nothing is specified, both will be synced."
              ;;
          esac
          ;;
        "update")
          sudo nix flake update "${settings.user.dotfilesDir}"
          ;;
        "upgrade")
          $0 update
          $0 sync
          ;;
        *)
          echo "niot: NixOS tools (shortcut scripts for NixOS management)"
          echo "Usage: $0 [CMD]"
          echo "CMD:"
          echo "  sync [user|system]:"
          echo "    Sync system and/or user configuration to config directory"
          echo "  update: update flake inputs"
          echo "  upgrade: update flake and sync"
          ;;
      esac
    ''
  );
}
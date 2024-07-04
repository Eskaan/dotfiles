#!/bin/sh
set -e

# Install my nixos dotfiles

# Clone dotfiles
if [ $# -gt 0 ]
  then
    echo "Using given location: $1"
    SCRIPT_DIR=$1
  else
    echo "Using default location: ~/dotfiles"
    SCRIPT_DIR=~/dotfiles
fi

if [ ! -d "$SCRIPT_DIR" ]; then
  echo "Cloning repository to $SCRIPT_DIR"
  nix-shell -p git --command \
    "git clone https://github.com/eskaan/dotfiles.git $SCRIPT_DIR"

  echo "Generate hardware config for new system"
  nixos-generate-config --no-filesystems --show-hardware-config > $SCRIPT_DIR/system/hardware-configuration.nix

  # Check if uefi or bios
  if [ -d /sys/firmware/efi/efivars ]; then
      echo "Installing in UEFI mode"
      sed -i "0,/bootMode.*=.*\".*\";/s//bootMode = \"uefi\";/" $SCRIPT_DIR/settings.nix
  else
      echo "Installing in BIOS mode"
      sed -i "0,/bootMode.*=.*\".*\";/s//bootMode = \"bios\";/" $SCRIPT_DIR/settings.nix
      grubDevice=$(findmnt / | awk -F' ' '{ print $2 }' | sed 's/\[.*\]//g' | tail -n 1 | lsblk -no pkname | tail -n 1 )
      sed -i "0,/grubDevice.*=.*\".*\";/s//grubDevice = \"\/dev\/$grubDevice\";/" $SCRIPT_DIR/settings.nix
  fi

  echo "Patching settings.nix with different username/name and removing email by default"
  #sed -i "0,/eskaan/s//$(whoami)/" $SCRIPT_DIR/settings.nix
  #sed -i "0,/Eskaan/s//$(getent passwd $(whoami) | cut -d ':' -f 5 | cut -d ',' -f 1)/" $SCRIPT_DIR/settings.nix
  #sed -i "s/eskaaan@eskaan.de//" $SCRIPT_DIR/settings.nix
  sed -i "s+~/dotfiles+$SCRIPT_DIR+g" $SCRIPT_DIR/settings.nix

  echo "Opening editor to manually edit settings before install"
  if [ -z "$EDITOR" ]; then
      EDITOR=nano;
  fi
  $EDITOR "$SCRIPT_DIR/settings.nix"
else
  echo "$SCRIPT_DIR already exists, skipping clone & patching"
fi

echo "Warning: This script will completely overwrite the following disks!"
nix --experimental-features "nix-command flakes" eval --impure --expr "let settings = import \"$SCRIPT_DIR/settings.nix\"; in settings.system.disks"
echo -n "Install now? [y/N]"
read -n 1 RET
echo
if [[ "$RET" == "y" ]]; then
  echo "Continuing with installation"
else
  echo "Aborting..."
  exit 0
fi

echo "Running disko"
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko --flake "path:$SCRIPT_DIR#disko"

echo "Installing system"
sudo nixos-install --flake "path:$SCRIPT_DIR#system"

USERNAME=$(
  nix --experimental-features "nix-command flakes" eval --impure --raw --expr \
    "let settings = import \"$SCRIPT_DIR/settings.nix\"; in settings.user.username"
)
echo "Moving dotfiles to new home: /home/$USERNAME/dotfiles"
sudo mkdir --parents "/mnt/home/$USERNAME/"
sudo mv $SCRIPT_DIR "/mnt/home/$USERNAME/dotfiles"


# TODO after reboot: 
# Install and build home-manager configuration
#nix run home-manager/master -- switch --flake ~/dotfiles#user

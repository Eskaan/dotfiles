{ pkgs, settings, ... }: rec {
  # Format and install from nothing
  installer = {
    type = "app";
    program = builtins.toString (
      pkgs.writeShellScript "installer" (builtins.readFile ../installer.sh)
    );
  };
}
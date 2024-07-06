{ pkgs, ... }: {
  home.packages = with pkgs; [
    bat
    fd
    bottom
    
    rsync
  ];
}
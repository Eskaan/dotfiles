{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    bat
    fd
    bottom
    
    rsync
  ];
}

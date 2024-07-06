let
  aliases = {
        vim = "nvim";
        e = "exit";
        c = "clear";
	      rb = "nixos-rebuild switch --flake ./#mainsrv";
      };
in {
  programs = {
    bash = {
      shellAliases = aliases;
    };
    git = {
      enable = true;
      userName = "Eskaan";
	    userEmail = "github@eskaan.de";
#        init = {
#          defaultBranch = "main";
#        };
      };
    #neovim = {
    #  configure = ''
    #    set tabstop=2
    #    set expandtab
    #  '';
    #  defaultEditor = true;
    #};
  };
}
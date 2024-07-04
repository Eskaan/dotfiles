{
  programs = {
    bash = {
      shellAliases = {
        vim = "nvim";
        e = "exit";
        c = "clear";
	      rb = "nixos-rebuild switch --flake ./#mainsrv";
      };
    };
    git = {
      enable = true;
      config = {
        user = {
	        name = "Eskaan";
	        email = "github@eskaan.de";
	      };
        init = {
          defaultBranch = "main";
        };
      };
    };
    neovim = {
      configure = ''
        set tabstop=2
        set expandtab
      '';
      defaultEditor = true;
    };
  };
}
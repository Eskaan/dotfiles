let
  aliases = {
        vim = "nvim";
        e = "exit";
        c = "clear";
      };
in {
  programs = {
    bash = {
      shellAliases = aliases;
    };
    git = {
      enable = true;
      config = {
        user.name = "Eskaan";
	user.email = "github@eskaan.de";
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

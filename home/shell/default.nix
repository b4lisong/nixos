{ 
    config,
    ...
}: let
    d = config.xdg.dataHome;
    c = config.xdg.configHome;
    cache = config.xdg.cacheHome;
in {
    imports = [
        ./common.nix
        ./starship.nix
        ./terminals.nix
	./zsh.nix
    ];

    # add environment variables
    home.sessionVariables = {
        # clean up ~
        LESSHISTFILE = cache + "/less/history";
        LESSKEY = c + "/less/lesskey";
        WINEPREFIX = d + "/wine";

        # set default applications
        EDITOR = "vim";
        BROWSER = "firefox";
        TERMINAL = "alacritty";

        # enable scrolling in git diff
        DELTA_PAGER = "less -R";

        MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    };

    # shell aliases
    home.shellAliases = {
        ls = "ls --color=auto";
        ll = "ls -lh";
        la = "ls -alh";
        vim = "nvim";
        v = "nvim";
        g = "git";
        gs = "git status";
        gc = "git commit";
        gp = "git push";
        lg = "lazygit";
        uc = "sudo nixos-rebuild switch --flake " + c + "/nixos/#utm-aarch64";
    };
}

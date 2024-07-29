# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      # Home Manager
      <home-manager/nixos>
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

    # Enable X11 and i3
    services.xserver = {
        enable = true;
        windowManager.i3.enable = true;
    };
    services.displayManager = {
        defaultSession = "none+i3";
    };

    # VM Guest Agent
    services.spice-vdagentd.enable = true;
    services.qemuGuest.enable = true;

    # Font configuration
    fonts.packages = with pkgs; [
        noto-fonts
        liberation_ttf
        nerdfonts
    ];

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
users.users.balisong = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
};

    # Home Manager Config + Enable
    home-manager.useUserPackages = true;
    home-manager.useGlobalPkgs = true;
    home-manager.backupFileExtension = "backup";

    # Home Manager User Config
    home-manager.users.balisong = { pkgs, ... }: {
        home.packages = [ ];
        home.stateVersion = "24.05";


        programs.zsh = {
            enable = true;
            enableCompletion = true;
            autosuggestion.enable = true;
            syntaxHighlighting.enable = true;

            shellAliases = {
	            ls = "ls --color=auto";
                ll = "ls -lh";
                la = "ls -alh";
                v = "nvim";
                g = "git";
                gs = "git status";
                gc = "git commit";
                gp = "git push";
                update = "sudo nixos-rebuild switch";
	            nixconfig = "sudo nvim /etc/nixos/configuration.nix";
            };
            history = {
              size = 10000;
              # path = "${config.xdg.dataHome}/zsh/history";
            };

        };

        programs.git = {
            enable = true;
            userName = "b4lisong";
            userEmail = "b4lisong@pm.me";
            aliases = {
                ci = "commit";
	        co = "checkout";
	        s = "status";
            };
            extraConfig = {
                # credential.helper = "${
                #     pkgs.git.override { withLibsecret = true; }
                # }/bin/git-credential-libsecret";
	        push = { autoSetupRemote = true; }; 
            };
        };

        xsession.windowManager.i3 = {
            enable = true;
            package = pkgs.i3-gaps;
            config = {
                modifier = "Mod1";
                gaps = {
                  inner = 10;
                  outer = 5;
                };
            };
        };

        programs.wezterm = {
            enable = true;
            enableZshIntegration = true;
            enableBashIntegration = true;
        };
    };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
      wget
      zsh
      starship
      git
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # tmux
  programs.tmux = {
      enable = true;
      terminal = "xterm-256color";
      clock24 = true;
      newSession = true;
      historyLimit = 100000;
  };

  # Zsh
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # neovim
  programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      configure = {
          customRC = ''
          """ Vim/Neovim config | ref: https://github.com/amix/vimrc/blob/master/vimrcs/basic.vim """
          """ => General """
          " Sets how many lines of history VIM has to remember
          set history=500
          
          " Enable filetype plugins
          filetype plugin on
          filetype indent on
          
          " Set to auto read when a file is changed from the outside
          set autoread
          au FocusGained,BufEnter * silent! checktime
          
          " With a map leader it's possible to do extra key combinations
          " like <leader>w saves the current file
          let mapleader = ","
          
          " Fast saving
          nmap <leader>w :w!<cr>
          
          " :W sudo saves the file
          " (useful for handling the permission-denied error)
          command! W execute 'w !sudo tee % > /dev/null' <bar> edit!
          
          """ => UI """
		  " Set 7 lines to the cursor - when moving vertically using j/k
          set so=7
          
          " Turn on the Wild menu
          set wildmenu
          
          " Ignore compiled files
          set wildignore=*.o,*~,*.pyc
          if has("win16") || has("win32")
              set wildignore+=.git\*,.hg\*,.svn\*
          else
              set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
          endif
          
          " Always show current position
          set ruler
          
          " Height of the command bar
          set cmdheight=1
          
          " A buffer becomes hidden when it is abandoned
          set hid
          
          " Configure backspace so it acts as it should act
          set backspace=eol,start,indent
          set whichwrap+=<,>,h,l
          
          " Ignore case when searching
          set ignorecase
          
          " When searching try to be smart about cases
          set smartcase
          
          " Highlight search results
          " set hlsearch
          
          " Makes search act like search in modern browsers
          set incsearch
          
          " Don't redraw while executing macros (good performance config)
          set lazyredraw
          
          " For regular expressions turn magic on
          set magic
          
          " Show matching brackets when text indicator is over them
          set showmatch
          
          " How many tenths of a second to blink when matching brackets
          set mat=2
          
          " No annoying sound on errors
          set noerrorbells
          set novisualbell
          set t_vb=
          set tm=500
          
          " Add a bit extra margin to the left
          set foldcolumn=1
          
          " show absolute number (current line)
          set number
          " show relative number (surrounding lines)
          set relativenumber

	      """ => Text, tab, and indent related """
          " Use spaces instead of tabs
          set expandtab
          
          " Be smart when using tabs ;)
          set smarttab
          
          " 1 tab == 4 spaces
          set shiftwidth=4
          set tabstop=4
          
          " Linebreak on 500 characters
          set lbr
          set tw=500
          
          set ai "Auto indent
          set si "Smart indent
          set wrap "Wrap lines
          
          """ => Keybinds """
          " esc in insert & visual mode
          inoremap jk <esc>
          vnoremap jk <esc>
          
          " esc in command mode
          cnoremap jk <C-C>
          " Note: In command mode mappings to esc run the command for some odd
          " historical vi compatibility reason. We use the alternate method of
          " existing which is Ctrl-C
          
          """ => Colors and Fonts """
          " Enable syntax highlighting
          syntax enable
          
          " Set regular expression engine automatically
          set regexpengine=0
          
          set background=dark
          
          " Set utf8 as standard encoding and en_US as the standard language
          set encoding=utf8
          
          " Use Unix as the standard file type
          set ffs=unix,dos,mac

          """ => Files, backups, and undo """
          " Turn backup off, since most stuff is in SVN, git etc. anyway...
          set nobackup
          set nowb
          set noswapfile

	  '';
      };
  };

  # Starship prompt
  programs.starship = {
      enable = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

# Automatic Garbage Collection
nix.gc = {
                automatic = true;
                dates = "weekly";
                options = "--delete-older-than 7d";
         };
}


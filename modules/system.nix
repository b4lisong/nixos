{
  pkgs,
  lib,
  inputs,
  ...
}: let
  username = "balisong";
in {
  imports = [
    # <nixvim>.nixosModules.nixvim
    inputs.nixvim.nixosModules.nixvim
  ];
  # User related config

  # Define a user account (don't forget to set a password with `passwd`!)
  users.users.balisong = {
    isNormalUser = true;
    description = "balisong";
    extraGroups = [ "networkmanager" "wheel" ];
    # TODO: add pubkeys with
    # openssh.authorizedKeys.keys = [ "" ];
  };
  
  # Use zsh as default shell
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Customize /etc/nix/nix.conf declaratively via `nix.settings`
  nix.settings = {
    # enable flakes globally
    experimental-features = [ "nix-command" "flakes" ];
  };

  # Weekly garbage collection to keep disk usage low
  nix.gc = {
    automatic = lib.mkDefault true;
    dates = lib.mkDefault "weekly";
    options = lib.mkDefault "--delete-older-than 7d";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Time zone
  time.timeZone = "America/Los_Angeles";

  # Set locale
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable CUPS for printing
  services.printing.enable = true;

  # Fonts
  fonts = {
    packages = with pkgs; [
      # icon fonts
      material-design-icons
      
      # normal fonts
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji

      # nerdfonts
      (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
    ];

    # use user-specified fonts rather than default ones
    enableDefaultPackages = false;

    # user defined fonts
    # the reason there's Noto Color Emoji everywhere is to override DejaVu's
    # B&W emojis that would sometimes show instead of some Color emojis
    fontconfig.defaultFonts = {
      serif = ["Noto Serif" "Noto Color Emoji"];
      sansSerif = ["Noto Sans" "Noto Color Emoji"];
      monospace = ["JetBrainsMono Nerd Font" "Noto Color Emoji"];
      emoji = ["Noto Color Emoji"];
    };
  };

  # Enable dconf
  programs.dconf.enable = true;

  # Firewall settings
  networking.firewall.enable = false;

  # OpenSSH daemon
  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
      PermitRootLogin = "no";
      PasswordAuthentication = true; # TODO: disable
    };
    openFirewall = true;
  };

  # System (accessible as root) packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    git
    sysstat
    lm_sensors # for `sensors` command
    neofetch
    scrot
    xfce.thunar
    ranger
    lazygit
    ripgrep
  ];

  # nixvim
  programs.nixvim = {
    enable = true;
    # the best color scheme
    colorschemes.catppuccin.enable = true;
    # Options inspired by https://github.com/amix/vimrc/blob/master/vimrcs/basic.vim
    # Set leader key
    globals.mapleader = ",";
    # Keymaps
    keymaps = [
      # noremap ; :
      {
        key = ";";
        action = ":";
      }
      # map `jk` to esc in insert & visual modes
      {
        mode = [ "i" "v" ];
        key = "jk";
        action = "<esc>";
      }
    ];
    opts = {
      ### General ###
      # Lines of history to remember
      history = 500;
      # Auto-read when file changed from outside
      autoread = true;

      ### UI ###
      # Set 7 lines to the cursor when moving vertically using j/k
      so = 7;
      # Turn on Wild menu
      wildmenu = true;
      # Always show current position
      ruler = true;
      # Height of command bar
      cmdheight = 1;
      # Hide buffer when abandoned
      hid = true;
      # Ignore case when searching
      ignorecase = true;
      # Try to be smart about cases when searching
      smartcase = true;
      # Highlight search results
      hlsearch = true;
      # Make search act like search in modern browsers
      incsearch = true;
      # Don't redraw while executing macros (good performance config)
      lazyredraw = true;
      # Turn on magic for regular expressions
      magic = true;
      # Show matching brackets when text indicator is over them
      showmatch = true;
      # How many tenths of a second to blink when matching brackets
      mat = 2;
      # Add small extra margin to the left
      foldcolumn = "1";
      # Show absolute number (current line)
      number = true;
      # Show relative number (surrounding lines)
      relativenumber = true;

      ### Text, tab, and indent related ###
      # Spaces instead of tabs
      expandtab = true;
      # Smart tabs
      smarttab = true;
      # 1 tab == 2 spaces
      shiftwidth = 2;
      tabstop = 2;
      # Line break on 500 characters
      lbr = true;
      tw = 500;

      ### Colors and fonts ###
      # Set regex engine automatically
      regexpengine = 0;
      # utf8 and en_US standard
      encoding = "utf8";
      # Unix as standard file type
      ffs = "unix,dos,mac";
    };
  };

  # Enable polkit
  security.polkit.enable = true;

  # Enable power-profiles-daemon service
  services.power-profiles-daemon.enable = true;

  # Enable sound with pipewire - disable pulseaudio default
  hardware.pulseaudio.enable = false;
  
  # Enable additional services
  services = {
    dbus.packages = [pkgs.gcr];

    geoclue2.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    udev.packages = with pkgs; [gnome.gnome-settings-daemon];
  };
}

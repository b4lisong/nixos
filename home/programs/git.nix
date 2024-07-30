{
  pkgs,
  ...
}: {
  home.packages = [pkgs.gh];

  programs.git = {
    enable = true;

    userName = "b4lisong";
    userEmail = "b4lisong@pm.me";
  };
}

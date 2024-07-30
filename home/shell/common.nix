{
    pkgs,
    ...
}:
# nix tooling
{
    programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
        enableZshIntegration = true;
    };
}

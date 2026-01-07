{
  flake',
  config,
  pkgs,
  ...
}:
{
  programs.git = {
    enable = true;
    userName = config.home.fullName;
    userEmail = config.home.mainEmail;
    extraConfig = {
      init.defaultBranch = "main";
      pull.ff = true;
      pull.rebase = "true";
      push.autoSetupRemote = true;
      credential.helper = "store"; # Read from .git-credentials
      diff.tool = "nvimdiff";
      difftool.nvimdiff.cmd = "${pkgs.neovim}/bin/nvim -d \"$LOCAL\" \"$REMOTE\"";
      merge.tool = "nvimdiff";
      mergetool.nvimdiff.cmd = "${pkgs.neovim}/bin/nvim -d \"$LOCAL\" \"$REMOTE\" \"$MERGED\" -c 'wincmd w' -c 'wincmd J'";
      core.askPass = "";
    };
  };
}

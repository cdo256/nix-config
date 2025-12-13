{
  programs.rclone = {
    enable = true;
    remotes = {
      "test-drive" = {
        config = {
          type = "drive";
          scope = "drive";
        };
      };
    };
  };
}

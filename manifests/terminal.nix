{ pkgs, ... }:
[
  pkgs.trash-cli
  pkgs.moreutils
  pkgs.just
  pkgs.direnv
  pkgs.fd
  pkgs.zip
  pkgs.file
  pkgs.llm

  # Trying
  pkgs.bat # better cat
  pkgs.chafa # terminal graphics viewer
  pkgs.ctpv # terminal file previewer
  pkgs.eza # improved `ls`
  pkgs.fend # better CLI calculator
  pkgs.hexyl # hex pretty printer
  pkgs.ripgrep # rg ~ `grep` replacement
  pkgs.viddy # better watch
  pkgs.strip-ansi # Util to remove escape sequences
]

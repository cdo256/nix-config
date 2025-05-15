{ pkgs, ... }:
let
  # Reference the installed wordcount.lua filter
  filter = "${pkgs.pandoc-lua-filters}/share/pandoc/filters/wordcount.lua";
in
pkgs.writeShellScriptBin "wc-md" ''
  if [ $# -ne 1 ]; then
    echo "Usage: wc-md <file.md>"
    exit 1
  fi
  input="$1"
  file_output="$(${pkgs.file}/bin/file --mime-type --brief "$input")"
  if [[ $? -ne 0 ]] || file_output
  exec ${pkgs.pandoc}/bin/pandoc --lua-filter=${wordcountFilter} -f markdown "$@"
''

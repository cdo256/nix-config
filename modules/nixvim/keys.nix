{ config, lib, ... }:

let
  mkKeymaps =
    (keymaps:
      lib.flatten
        (lib.mapAttrsToList
          (mode: keymap:
            lib.mapAttrsToList
              (key: action: {
                inherit mode action key;
              }) keymap) keymaps));
in
{
  programs.nixvim = {
    enable = true;
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };
    keymaps = mkKeymaps {
      "n" = {
        # Better window movement
        "<C-h>" = "<C-w>h";
        "<C-j>" = "<C-w>j";
        "<C-k>" = "<C-w>k";
        "<C-l>" = "<C-w>l";

        # Resize with arrows
        "<C-Up>" = ":resize -2<CR>";
        "<C-Down>" = ":resize +2<CR>";
        "<C-Left>" = ":vertical resize -2<CR>";
        "<C-Right>" = ":vertical resize +2<CR>";

        # Move current line / block with Alt-j/k a la vscode.
        "<A-j>" = ":m .+1<CR>==";
        "<A-k>" = ":m .-2<CR>==";

        # QuickFix
        #"q" = ":cnext<CR>";
        #"q" = ":cprev<CR>";
        #"<C-q>" = ":call QuickFixToggle()<CR>";

        "$" = "$l";
        "zz" = "zR"; 

        # quick-save
        "<C-s>" = "<Cmd>w<CR>";

        "<M-x>" = ":";
      };
      "i" = {
        # Move current line / block with Alt-j/k ala vscode.
        "<A-j>" = "<Esc>:m .+1<CR>==gi";
        # Move current line / block with Alt-j/k ala vscode.
        "<A-k>" = "<Esc>:m .-2<CR>==gi";
        # navigation
        "<A-Up>" = "<C-\\><C-N><C-w>k";
        "<A-Down>" = "<C-\\><C-N><C-w>j";
        "<A-Left>" = "<C-\\><C-N><C-w>h";
        "<A-Right>" = "<C-\\><C-N><C-w>l";
        # quick-save
        "<C-s>" = "<Cmd>w<CR>";

        "<M-x>" = "<Esc>:";
      };
      "t" = {
        # Terminal window navigation
        "<C-h>" = "<C-\\><C-N><C-w>h";
        "<C-j>" = "<C-\\><C-N><C-w>j";
        "<C-k>" = "<C-\\><C-N><C-w>k";
        "<C-l>" = "<C-\\><C-N><C-w>l";
        "<Esc>" = "<C-\\><C-n>";
        "<M-x>" = "<C-\\><C-n>:";
      };
      "v" = {
        "<" = "<gv";
        ">" = ">gv";

        "$" = "$l";
        "<M-x>" = "<Esc>:";
      };
      "c" = {
        # navigate tab completion with <c-j> and <c-k>
        # runs conditionally
        #TODO: Port these from lua to nix.
        #"<C-j>" = { 'pumvisible() ? "\\<C-n>" : "\\<C-j>"', { expr = true, noremap = true } };
        #"<C-k>" = { 'pumvisible() ? "\\<C-p>" : "\\<C-k>"', { expr = true, noremap = true } };
      };
    };
  };
}
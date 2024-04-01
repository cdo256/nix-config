lvim.log.level = 'trace'
table.insert(lvim.reload_list, 'lvim.plugins')

-- So we can move past the end of the line
vim.opt.virtualedit = {"onemore", "block",}
vim.opt.timeoutlen = 100 -- ms

-- Allow folding, but only on request
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false

--lvim.colorscheme = 'aura-dark'
vim.cmd [[
  hi DiffAdd guifg=#000000 guibg=#44ff11
  hi DiffDelete guifg=#000000 guibg=#ff4411
]]

vim.cmd [[
  hi GitSignsAdd guifg=#00ff00 guibg=NONE
  hi GitSignsChange guifg=#ffff00 guibg=NONE
  hi GitSignsDelete guifg=#ff0000 guibg=NONE
]]

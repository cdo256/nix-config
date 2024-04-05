local base_dir = vim.env.LUNARVIM_BASE_DIR
  -- or "/home/cdo/src/nvim-lunar"
  or "/home/cdo/.guix-home/profile/share/nvim";

vim.opt.rtp:prepend("/home/cdo/.guix-home/profile/share/nvim/")
vim.opt.rtp:prepend("/home/cdo/.guix-home/profile/share/nvim/site")
vim.opt.rtp:prepend("/home/cdo/.guix-home/profile/share/nvim/site/pack")
vim.opt.rtp:prepend("/home/cdo/.guix-home/profile/share/nvim/site/pack/guix")
vim.opt.rtp:prepend("/home/cdo/.guix-home/profile/share/nvim/site/pack/guix/start")
vim.opt.rtp:prepend(base_dir)
if not vim.tbl_contains(vim.opt.rtp:get(), base_dir) then
end

require("lvim.bootstrap"):init(base_dir)

local Log = require "lvim.core.log"
Log:debug('Search path:')
Log:debug(package.path)
package.path

require("lvim.config"):load()
 
local plugins = require "lvim.plugins"
 
require("lvim.plugin-loader").load { plugins, lvim.plugins }

require("lvim.core.commands")
 
require("lvim.core.theme").setup()

Log:debug "Starting LunarVim"

local commands = require "lvim.core.commands"
commands.load(commands.defaults)

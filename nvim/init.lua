local base_dir = vim.env.LUNARVIM_BASE_DIR
  -- or "/home/cdo/src/nvim-lunar"
  or "/home/cdo/.guix-home/profile/share/nvim";

package.path = table.concat({
	package.path,
	'/home/cdo/.guix-home/profile/share/nvim/?.lua',
	'/home/cdo/.guix-home/profile/share/nvim/?/init.lua',
	'/home/cdo/.guix-home/profile/share/nvim/site/pack/guix/start/lvim/lua/?.lua',
	'/home/cdo/.guix-home/profile/share/nvim/site/pack/guix/start/lvim/lua/?/init.lua',
}, ';')

require("lvim.bootstrap"):init(base_dir)

local Log = require "lvim.core.log"
Log:debug('Search path:')
Log:debug(package.path)

require("lvim.config"):load()
 
local plugins = require "lvim.plugins"
 
require("lvim.plugin-loader").load { plugins, lvim.plugins }

require("lvim.core.commands")
 
require("lvim.core.theme").setup()

Log:debug "Starting LunarVim"

local commands = require "lvim.core.commands"
commands.load(commands.defaults)

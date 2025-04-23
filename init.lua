-- init.lua：完整啟動模組化設定
local is_vscode = vim.g.vscode == 1

-- 通用設定
require("core.options")
require("keymap").setup()
require("keymap.hotKeyMaps").setup()
if is_vscode then
	require("keymap.vscode").setup()
end

-- 插件列表載入
require("PluginsList")

-- 通用插件（VSCode + Neovim 都載入）
require("plugin.config.flash").setup()
require("plugin.config.imselect").setup()
require("plugin.config.surround").setup()

-- LSP 與開發工具模組（條件載入）
local mason = require("plugin.config.mason")
local treesitter = require("plugin.config.treesitter")
local ufo = require("plugin.config.ufo")
local lsp = require("plugin.config.lsp")
local null_ls = require("plugin.config.null-ls")
local bufferline = require("plugin.config.bufferline")
local lualine = require("plugin.config.lualine")
local telescope = require("plugin.config.telescope")
local nvimtree = require("plugin.config.nvimtree")
local peek = require("plugin.config.peek")
local obsidian = require("plugin.config.obsidian")
local lazygit = require("plugin.config.lazygit")

if not is_vscode then
	mason.enable()
	treesitter.setup()
	ufo.setup()
	lsp.setup()
	null_ls.setup()
	bufferline.setup()
	lualine.setup()
	telescope.setup()
	nvimtree.setup()
	peek.setup()
	obsidian.setup()
	lazygit.setup()
end

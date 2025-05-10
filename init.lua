---@diagnostic disable-next-line: undefined-global
vim = vim
-- init.lua：完整啟動模組化設定
vim.o.cmdheight = 0    -- ✅ 啟用 Noice 浮動命令列
vim.opt.laststatus = 3 -- 可選，讓 statusline 視窗共享（整體視覺更現代）
local is_vscode = vim.g.vscode == 1
vim.keymap.set("n", "<Esc>", "<Esc>:nohlsearch<CR>", { silent = true })
vim.opt_local.formatoptions:append({ "n" })

-- 插件列表載入
require("PluginsList")

-- 通用設定
require("core.options")
require("keymap").setup()
require("keymap.hotKeyMaps").setup()
if is_vscode then
    require("keymap.vscode").setup()
end

-- 通用插件（VSCode + Neovim 都載入）
require("plugin.config.flash").setup()
-- require("plugin.config.imselect").setup()
require("plugin.config.surround").setup()

-- LSP 與開發工具模組（條件載入）

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
local markdown = require("plugin.config.markdown")
local customCall = require("plugin.config.customCall")
-- local comment = require("plugin.config.comment")

if not is_vscode then
    lsp.setup()
    ufo.setup()
    null_ls.setup()
    bufferline.setup()
    lualine.setup()
    telescope.setup()
    nvimtree.setup()
    peek.setup()
    obsidian.setup()
    lazygit.setup()
    markdown.setup()
    -- comment.setup()
    vim.opt.conceallevel = 2
end

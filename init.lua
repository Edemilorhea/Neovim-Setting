-- HELPERS ----------------------------------------------------
local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local scopes = {o = vim.o, b = vim.bo, w = vim.wo}
-- Set CMD ----------------------------------------------------
cmd "syntax enable"
cmd "syntax on"
cmd "set number"
vim.opt.fileencodings = "utf-8,big5,gbk,gb18030,gb2312,ucs-bom,cp936,euc-jp,euc-kr,shift-jis,latin1"
vim.opt.encoding = "utf-8"
vim.opt.langmenu = "zh_TW.UTF-8"
vim.o.mapleader = "\\"
vim.opt.ignorecase = true -- Do case insensitive matching
vim.opt.smartcase = true --- Do smart case matching
vim.opt.clipboard = "unnamedplus"
vim.opt.backup = false --不備分文件
vim.opt.relativenumber = true
package.path = package.path .. ";C:\\tools\\nvim\\lua\\?.lua"
-- keybinds for vsc---------------------------------------------
-- Load Plugins ------------------------------------------------

 if pcall(require, 'nvim-treesitter') then
   print('treesitter 模組已安裝')
 else
   print('treesitter 模組未安裝')
 end

if vim.g.vscode then
    -- VSCode extension
	print('Vscode-nvim-init.lua 已成功配對')
	require("pluginsList.lua")
	require("Keymap.lua")
	require("nvim-surround.lua")
	vim.api.nvim_set_keymap('i', '<C-[>', '<Esc>', { noremap = true })
	vim.api.nvim_set_keymap('n', 'za', "<Cmd>lua vim.fn.VSCodeNotify('editor.toggleFold')<CR>", {silent = true})
	vim.api.nvim_set_keymap('n', 'zR', "<Cmd>lua vim.fn.VSCodeNotify('editor.unfoldAll')<CR>", {silent = true})
	vim.api.nvim_set_keymap('n', 'zM', "<Cmd>lua vim.fn.VSCodeNotify('editor.foldAll')<CR>", {silent = true})
	vim.api.nvim_set_keymap('n', 'zo', "<Cmd>lua vim.fn.VSCodeNotify('editor.unfold')<CR>", {silent = true})
	vim.api.nvim_set_keymap('n', 'zO', "<Cmd>lua vim.fn.VSCodeNotify('editor.unfoldRecursively')<CR>", {silent = true})
	vim.api.nvim_set_keymap('n', 'zc', "<Cmd>lua vim.fn.VSCodeNotify('editor.fold')<CR>", {silent = true})
	vim.api.nvim_set_keymap('n', 'zC', "<Cmd>lua vim.fn.VSCodeNotify('editor.foldRecursively')<CR>", {silent = true})
	vim.api.nvim_set_keymap('n', 'z1', "<Cmd>lua vim.fn.VSCodeNotify('editor.foldLevel1')<CR>", {silent = true})
	vim.api.nvim_set_keymap('n', 'z2', "<Cmd>lua vim.fn.VSCodeNotify('editor.foldLevel2')<CR>", {silent = true})
	vim.api.nvim_set_keymap('n', 'z3', "<Cmd>lua vim.fn.VSCodeNotify('editor.foldLevel3')<CR>", {silent = true})
	vim.api.nvim_set_keymap('n', 'z4', "<Cmd>lua vim.fn.VSCodeNotify('editor.foldLevel4')<CR>", {silent = true})
	vim.api.nvim_set_keymap('n', 'z5', "<Cmd>lua vim.fn.VSCodeNotify('editor.foldLevel5')<CR>", {silent = true})
	vim.api.nvim_set_keymap('n', 'z6', "<Cmd>lua vim.fn.VSCodeNotify('editor.foldLevel6')<CR>", {silent = true})
	vim.api.nvim_set_keymap('n', 'z7', "<Cmd>lua vim.fn.VSCodeNotify('editor.foldLevel7')<CR>", {silent = true})
	vim.api.nvim_set_keymap('x', 'zV', "<Cmd>lua vim.fn.VSCodeNotify('editor.foldAllExcept')<CR>", {silent = true})
	vim.api.nvim_set_keymap('n', 'zj', "<Cmd>lua vim.fn.VSCodeNotify('editor.gotoNextFold')<CR>", {silent = true})
	vim.api.nvim_set_keymap('n', 'zk', "<Cmd>lua vim.fn.VSCodeNotify('editor.gotoPreviousFold')<CR>", {silent = true})	

	-- Normal mode mappings
	vim.api.nvim_set_keymap('n', 'j', 'gj', { silent = true })
	vim.api.nvim_set_keymap('n', 'k', 'gk', { silent = true })

	-- Visual mode mappings
	vim.api.nvim_set_keymap('v', 'j', 'gj', { silent = true })
	vim.api.nvim_set_keymap('v', 'k', 'gk', { silent = true })

	-- Normal mode mappings for <Down> and <Up>
	vim.api.nvim_set_keymap('n', '<Down>', 'gj', { silent = true })
	vim.api.nvim_set_keymap('n', '<Up>', 'gk', { silent = true })

	-- Visual mode mappings for <Down> and <Up>
	vim.api.nvim_set_keymap('v', '<Down>', 'gj', { silent = true })
	vim.api.nvim_set_keymap('v', '<Up>', 'gk', { silent = true })

else
	require("PluginsList.lua")
	require("Keymap.lua")
	--require("nvim-treesitter.lua")
	--require 'nvim-treesitter.install'.compilers = { "clang", "gcc" }
    -- ordinary Neovim
end

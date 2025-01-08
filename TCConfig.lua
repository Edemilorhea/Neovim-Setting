-- 設定基本變數
local cmd = vim.cmd
local fn = vim.fn
local g = vim.g

-- 設置 Lua 模組路徑
package.path = package.path
    .. ";C:/tools/Neovim-Setting/lua/?.lua"
    .. ";C:/tools/Neovim-Setting/lua/?/?.lua"
    .. ";C:/tools/nvim/lua/?.lua"

-- 設置折疊層級
vim.o.foldlevelstart = 99          -- 初始折疊層級為 99
vim.o.foldcolumn = '1' -- '0' is not bad
-- 使用表達式摺疊
vim.o.foldmethod = 'expr'
-- Treesitter 提供的摺疊表達式
vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
-- 啟用摺疊功能
vim.o.foldenable = true
-- 預設展開所有摺疊
vim.o.foldlevel = 99
--
-- 執行 Vim 命令
cmd("syntax on")
cmd("set number")

-- 設定全域變數
g.mapleader = "\\"                 -- 設置領導鍵
g.maplocalleader = "\\"            -- 設置本地領導鍵

-- 設定選項
vim.opt.clipboard = "unnamedplus"  -- 使用系統剪貼簿
vim.o.fileencodings = "utf-8,big5,gbk,gb18030,gb2312,ucs-bom,cp936,euc-jp,euc-kr,shift-jis,latin1"
vim.o.encoding = "utf-8"           -- 設置編碼為 UTF-8
vim.o.langmenu = "zh_TW.UTF-8"     -- 設置語言菜單為繁體中文
vim.o.ignorecase = true            -- 搜索時忽略大小寫
vim.o.smartcase = true             -- 大小寫敏感搜索
vim.o.backup = false               -- 禁用備份文件
vim.wo.relativenumber = true       -- 顯示相對行號
vim.o.tabstop = 4                  -- 設置 Tab 寬度為 4 個空格
vim.bo.expandtab = true            -- 使用空格代替 Tab
vim.o.shiftwidth = 4               -- 設置縮排寬度為 4 個空格
vim.wo.number = true               -- 顯示行號

-- Load Plugins ------------------------------------------------
 
 if vim.g.vscode then
     -- VSCode extension
 	print('Vscode-nvim-init.lua 已成功配對')
 	require("PluginsList")
 	require("Keymap")
 	require('ufo').setup({
 	    provider_selector = function(bufnr, filetype, buftype)
 		return {'treesitter', 'indent'}
 	    end
 	})
     require("Keymap.VSCKeymap")
 else
 	require("PluginsList")
    require("Keymap")
 	require("nvim-tree")
	require("PluginsList.neovimorg")
 	require('ufo').setup({
 	    provider_selector = function(bufnr, filetype, buftype)
 		return {'treesitter', 'indent'}
 	    end
 })
 end

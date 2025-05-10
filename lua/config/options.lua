-- core/options.lua
local opt = vim.opt
local g = vim.g
local bo = vim.bo
local wo = vim.wo

g.mapleader = "\\"
g.maplocalleader = "\\"

opt.number = true
wo.relativenumber = true
opt.syntax = "on"
opt.clipboard = "unnamedplus"
opt.ignorecase = true
opt.smartcase = true
opt.backup = false
opt.tabstop = 4
bo.expandtab = true
opt.shiftwidth = 4
opt.encoding = "utf-8"
opt.fileencodings = "utf-8,big5,gbk,gb18030,gb2312,ucs-bom,cp936,euc-jp,euc-kr,shift-jis,latin1"
opt.langmenu = "zh_TW.UTF-8"
opt.termguicolors = true

if not g.vscode then
  opt.foldmethod = "expr"
  opt.foldexpr = "nvim_treesitter#foldexpr()"
  opt.foldenable = true
  opt.foldlevel = 99
  opt.foldlevelstart = 99
  opt.foldcolumn = "1"
end

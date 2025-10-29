-- core/options.lua
local opt = vim.opt
local g = vim.g
local bo = vim.bo
local wo = vim.wo

vim.g.mapleader = "\\"
vim.g.maplocalleader = "\\"

vim.g.markdown_fenced_languages = {
  "csharp=cs",
  "cs",
  "python",
  "javascript",
  "bash=sh",
}

opt.number = true
wo.relativenumber = true
opt.syntax = "on"
opt.clipboard = "unnamedplus"
opt.ignorecase = true
opt.smartcase = true
opt.backup = false

-- 縮排設定（4 格空白）
opt.tabstop = 4 -- Tab 字元顯示寬度
opt.shiftwidth = 4 -- 自動縮排寬度
opt.softtabstop = 4 -- 編輯時 Tab 的行為寬度（新增）
opt.expandtab = true -- 將 Tab 轉換為空格

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

-- 延遲載入縮排設定以加速啟動
vim.defer_fn(function()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
      vim.bo.tabstop = 4
      vim.bo.shiftwidth = 4
      vim.bo.softtabstop = 4
      vim.bo.expandtab = true
    end,
  })
end, 50)

-- Windows 輸入法自動切換
-- 使用更可靠的 OS 檢測方式
local is_windows = vim.uv.os_uname().sysname:find("Windows") ~= nil

if is_windows then
  -- 使用相對於配置目錄的絕對路徑
  local config_path = vim.fn.stdpath("config")
  local im_select = config_path .. "\\im-select-imm.exe"

  -- 檢查工具是否存在
  if vim.fn.filereadable(im_select) == 0 then
    vim.cmd('echohl ErrorMsg | echo "找不到 ' .. im_select .. '" | echohl None')
    return
  end

  vim.api.nvim_create_autocmd("InsertLeave", {
    group = vim.api.nvim_create_augroup("IMSelect", { clear = true }),
    callback = function()
      vim.fn.jobstart({ im_select, "1033" }, { detach = true })
    end,
  })

  -- 載入確認
  vim.cmd('echo "✓ 輸入法自動切換已載入"')
end

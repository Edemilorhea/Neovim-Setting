-- config/lazy-fast.lua
-- 快速載入版本的 lazy 配置

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- 最小化的插件配置，只載入核心必需品
require("lazy").setup({
  spec = {
    -- LazyVim 核心
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- 只載入共享插件 (啟動時需要的)
    { import = "plugins.shared" },
  },
  defaults = {
    lazy = true, -- 預設 lazy loading
    version = false,
  },
  install = { 
    colorscheme = { "tokyonight", "habamax" },
    missing = false, -- 啟動時不自動安裝缺失插件
  },
  checker = {
    enabled = false, -- 啟動時不檢查更新
    notify = false,
  },
  performance = {
    cache = { enabled = true },
    reset_packpath = true,
    rtp = {
      reset = true,
      disabled_plugins = {
        "gzip", "matchit", "matchparen", "netrwPlugin", "tarPlugin", 
        "tohtml", "tutor", "zipPlugin", "rplugin", "syntax", 
        "synmenu", "optwin", "compiler", "bugreport", "ftplugin",
      },
    },
  },
})

-- 延遲載入其他插件配置
vim.defer_fn(function()
  require("lazy").setup({
    spec = {
      -- 開發工具 (延遲載入)
      { import = "plugins.development" },
      { import = "plugins.neovim-only", cond = not vim.g.vscode },
      { import = "plugins.ui-restructured", cond = not vim.g.vscode },
      { import = "plugins.markdown-enhanced", cond = not vim.g.vscode },
      { import = "plugins" }, -- 其他插件
    },
  }, { merge = true })
end, 100) -- 100ms 後載入其他插件
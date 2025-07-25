-- config/lazy-minimal.lua
-- 極簡版本的 lazy 配置 - 專注於最快啟動

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- 極簡配置 - 只載入絕對必要的插件
require("lazy").setup({
  spec = {
    -- LazyVim 核心 (必需)
    { "LazyVim/LazyVim", import = "lazyvim.plugins", priority = 10000 },
    -- 最基本的共享功能
    {
      "kylechui/nvim-surround",
      keys = { "ys", "ds", "cs" },
      config = function()
        require("nvim-surround").setup()
      end,
    },
    {
      "echasnovski/mini.comment",
      keys = { "gc", "gcc" },
      config = function()
        require("mini.comment").setup()
      end,
    },
  },
  defaults = {
    lazy = true,
    version = false,
  },
  install = { 
    colorscheme = { "tokyonight" },
    missing = false,
  },
  checker = { enabled = false },
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

-- 延遲 300ms 後載入完整配置
vim.defer_fn(function()
  -- 載入完整的插件配置
  pcall(function()
    require("lazy").setup({
      spec = {
        { import = "plugins.shared" },
        { import = "plugins.development" },
        { import = "plugins.neovim-only", cond = not vim.g.vscode },
        { import = "plugins.ui-restructured", cond = not vim.g.vscode },
        { import = "plugins.markdown-enhanced", cond = not vim.g.vscode },
        { import = "plugins" },
      },
    }, { merge = true })
  end)
end, 300)
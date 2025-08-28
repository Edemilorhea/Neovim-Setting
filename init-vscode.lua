-- VSCode 專用的最小化 Neovim 配置
-- 在 VSCode 的 vscode-neovim 插件設定中使用此檔案

-- 基礎設定
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- 通知系統優化
vim.notify = print

-- LSP 清理補丁
vim.lsp.buf.clear_references = function() end

-- 最小化插件管理
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- 僅載入 VSCode 必需插件
require("lazy").setup({
  spec = {
    -- nvim-surround
    {
      "kylechui/nvim-surround",
      version = "^3.0.0",
      event = "VeryLazy",
      config = function()
        require("nvim-surround").setup({})
      end,
    },
    
    -- flash.nvim - 快速移動
    {
      "folke/flash.nvim",
      event = "VeryLazy",
      opts = {
        modes = {
          search = {
            enabled = true,
            highlight = { backdrop = true, matches = true },
            jump = { history = true, register = true, nohlsearch = false },
            search = {
              multi_window = true,
              forward = true,
              wrap = true,
              incremental = false,
            },
          },
          char = {
            enabled = true,
            config = function(opts)
              -- autohide flash when in operator-pending mode
              opts.autohide = opts.autohide or (vim.fn.mode(true):find("no") and vim.v.operator == "y")
              
              -- disable jump labels when not enabled, when using a count,
              -- or when recording/executing registers
              opts.jump_labels = opts.jump_labels
                and vim.v.count == 0
                and vim.fn.reg_executing() == ""
                and vim.fn.reg_recording() == ""
              
              -- Show jump labels only in operator-pending mode
              -- opts.jump_labels = vim.v.count == 0 and vim.fn.mode(true):find("o")
            end,
            autohide = false,
            jump = { register = false },
            multi_line = true,
            label = { exclude = "hjkliardc" },
            keys = { "f", "F", "t", "T", ";", "," },
            char_actions = function(motion)
              return {
                [";"] = "next", -- set to `right` to always go right
                [","] = "prev", -- set to `left` to always go left
                -- clever-f style
                [motion:lower()] = "next",
                [motion:upper()] = "prev",
                -- jump2d style: same case goes next, opposite case goes prev
                -- [motion] = "next",
                -- [motion:match("%l") and motion:upper() or motion:lower()] = "prev",
              }
            end,
          },
        },
      },
      keys = {
        { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
        { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
        { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
        { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
        { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
      },
    },
    
    -- mini.comment
    {
      "echasnovski/mini.comment",
      event = "VeryLazy",
      opts = {},
      keys = {
        { "<C-/>", "gcc", mode = "n", remap = true },
        { "<C-_>", "gcc", mode = "n", remap = true },
        { "<C-/>", "gc", mode = "v", remap = true },
        { "<C-_>", "gc", mode = "v", remap = true },
      },
    },
  },
  defaults = {
    lazy = true,
  },
  install = { missing = false }, -- 不自動安裝缺失插件
  checker = { enabled = false }, -- 停用更新檢查
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

-- 載入基礎快捷鍵
require("keymap.general").setup()
require("keymap.vscode").setup()

vim.notify("🚀 VSCode Neovim 最小化環境已載入")
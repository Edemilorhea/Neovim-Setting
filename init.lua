-- VSCode 環境最小化載入
if vim.g.vscode then
    -- 基礎設定
    vim.g.mapleader = " "
    vim.g.maplocalleader = "\\"

    -- 通知系統優化
    vim.notify = print

    -- LSP 清理補丁
    vim.lsp.buf.clear_references = function() end

    -- 最小化插件載入
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not (vim.uv or vim.loop).fs_stat(lazypath) then
        local lazyrepo = "https://github.com/folke/lazy.nvim.git"
        vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    end
    vim.opt.rtp:prepend(lazypath)

    -- 僅載入 VSCode 必需插件
    require("lazy").setup({
        spec = {
            -- 從 plugins.shared 載入 VSCode 兼容插件
            { import = "plugins.shared" },
        },
        defaults = { lazy = true },
        install = { missing = false },
        checker = { enabled = false },
        performance = {
            cache = { enabled = true },
            reset_packpath = true,
            rtp = {
                reset = true,
                disabled_plugins = {
                    "gzip",
                    "matchit",
                    "matchparen",
                    "netrwPlugin",
                    "tarPlugin",
                    "tohtml",
                    "tutor",
                    "zipPlugin",
                    "rplugin",
                    "syntax",
                    "synmenu",
                    "optwin",
                    "compiler",
                    "bugreport",
                    "ftplugin",
                },
            },
        },
    })

    -- 載入 VSCode 快捷鍵
    require("config.options")
    require("keymap.general").setup()
    require("keymap.vscode").setup()

    vim.notify("🚀 VSCode Neovim 已載入")
    return -- 提前結束，不執行下面的完整載入
end

-- === 完整 Neovim 環境 ===
-- 初始化 LazyVim (優化版本)
require("config.lazy")

-- === 純 Neovim 環境繼續載入 ===
-- 載入 LSP 設定與快捷鍵
if pcall(require, "plugin.lsp") then
    local lsp = require("plugin.lsp")
    if lsp.auto_enable_lsp then
        lsp.auto_enable_lsp()
    end
end

-- 載入重構後的按鍵設定
require("config.keymaps-restructured")

vim.notify("🚀 Neovim 完整環境已啟動")

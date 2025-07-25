-- 初始化 LazyVim
require("config.lazy")

-- 環境分離設定
if vim.g.vscode then
    -- === VSCode 環境 ===
    -- 特定補丁與通知處理
    vim.notify = print
    
    -- 修補 LSP 清除引用以避免報錯
    vim.lsp.buf.clear_references = function() end
    
    -- 載入 VSCode 特定設定
    if pcall(require, "plugin.lsp") then
        print("🔌 VSCode Neovim 環境已初始化")
    end
    
    -- 載入重構後的按鍵設定
    require("config.keymaps-restructured")
else
    -- === 純 Neovim 環境 ===
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
end

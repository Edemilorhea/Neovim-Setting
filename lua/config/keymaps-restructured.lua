-- config/keymaps-restructured.lua
-- 重新整理的按鍵映射，支援 VSCode 和 Neovim 環境分離

-- 載入共用的按鍵映射
require("keymap.general").setup()

if vim.g.vscode then
    -- VSCode 環境
    require("keymap.vscode").setup()
else
    -- 純 Neovim 環境
    require("keymap.neovim").setup()
    
    -- 載入熱鍵映射（只在 Neovim 中使用）
    require("keymap.hotKeyMaps").setup()
end

-- 延遲載入後的按鍵設定覆寫
vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
        -- 移除 LazyVim 的 terminal 快捷鍵綁定，確保註解功能優先
        pcall(vim.keymap.del, "n", "<C-/>")
        pcall(vim.keymap.del, "t", "<C-/>")
        pcall(vim.keymap.del, "n", "<C-_>")
        pcall(vim.keymap.del, "t", "<C-_>")
        
        -- 重新設定註解快捷鍵（個人設定優先）
        vim.keymap.set("n", "<C-/>", "gcc", { remap = true, desc = "Comment line" })
        vim.keymap.set("n", "<C-_>", "gcc", { remap = true, desc = "Comment line" })
        vim.keymap.set("v", "<C-/>", "gc", { remap = true, desc = "Comment selection" })
        vim.keymap.set("v", "<C-_>", "gc", { remap = true, desc = "Comment selection" })
        
        print("個人按鍵設定已覆寫 LazyVim 預設值")
    end,
})
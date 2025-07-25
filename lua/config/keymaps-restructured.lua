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

-- 註解：註解快捷鍵現在統一在 plugins/shared.lua 中的 mini.comment 配置
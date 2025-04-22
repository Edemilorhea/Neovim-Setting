-- init.lua：完整啟動模組化設定
local is_vscode = vim.g.vscode == 1
require("core.options")
require("keymap").setup()

if is_vscode then
    require("keymap.vscode").setup()
end

require("PluginsList")

-- ✅ Plugin 個別設定（模組化初始化）
require("plugin.config.flash").setup()
require("plugin.config.nvimtree").setup()
require("plugin.config.peek").setup()
require("plugin.config.imselect").setup()
require("plugin.config.lualine").setup()
require("plugin.config.telescope").setup()
require("plugin.config.surround").setup()

-- ✅ 只有非 VSCode 模式才載入 LSP 與 Treesitter
if not is_vscode then
    require("plugin.config.treesitter").setup()
    require("plugin.config.ufo").setup()
    require("plugin.config.mason").enable()
    require("plugin.config.lsp").setup()
end

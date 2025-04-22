-- init.lua：完整啟動模組化設定
local is_vscode = vim.g.vscode == 1
require("core.options")
require("keymap").setup()

if is_vscode then
    require("keymap.vscode").setup()
end

require("PluginsList")

if not is_vscode then
    require("plugin.config.mason").enable()
    require("plugin.config.lsp").setup()
end

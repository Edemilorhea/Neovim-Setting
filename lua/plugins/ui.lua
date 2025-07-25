-- plugins/ui.lua
-- UI 插件已重新組織，請查看 ui-restructured.lua
-- 保留此檔案以維持相容性

if vim.g.vscode then
    vim.defer_fn(function()
        print("⚠️  UI 插件在 VSCode 中已停用")
    end, 500)
else
    vim.defer_fn(function()
        print("🎨 UI 插件已重新結構化")
    end, 500)
end

return {}
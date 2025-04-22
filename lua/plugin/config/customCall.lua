local M = {}
local is_enabled = false

function M.enable_all()
    if is_enabled then
        vim.notify("已啟用，略過重複載入", vim.log.levels.WARN)
        return
    end

    require("plugin.config.mason").enable()
    require("plugin.config.treesitter").setup()
    require("plugin.config.ufo").setup()
    require("plugin.config.lsp").setup()
    require("plugin.config.null-ls").setup()

    is_enabled = true
    vim.notify("✅ 所有開發相關設定已啟用", vim.log.levels.INFO)
end

function M.disable_all()
    if not is_enabled then
        vim.notify("尚未啟用，無須關閉", vim.log.levels.WARN)
        return
    end

    require("plugin.config.mason").disable()

    -- 可依你自己的模組設計加上 disable，如果沒有就略過
    -- require("plugin.config.lsp").disable()
    -- require("plugin.config.null-ls").disable()
    -- require("plugin.config.treesitter").disable()

    is_enabled = false
    vim.notify("⛔ 所有開發相關設定已停用", vim.log.levels.INFO)
end

function M.toggle()
    if is_enabled then
        M.disable_all()
    else
        M.enable_all()
    end
end

return M

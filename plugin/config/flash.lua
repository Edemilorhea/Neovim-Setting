local M = {}

function M.setup()
    local flash = require("flash")
    -- ✅ 啟用 flash 的整合（推薦放最前面）
    flash.setup({
        modes = {
            search = {
                enabled = true, -- 整合 `/` 搜尋
                highlight = true, -- 搜尋時自動高亮
                jump = {
                    history = true
                } -- 可記錄跳轉歷史
            }
        }
    })
    vim.keymap.set({"n", "x", "o"}, "<leader>hf", flash.jump, {
        silent = true,
        desc = "[H]op [F]lash"
    })
    vim.keymap.set({"n", "x", "o"}, "<leader>hF", flash.treesitter, {
        silent = true,
        desc = "Flash Treesitter"
    })
    vim.keymap.set({"o", "x"}, "<leader>hr", flash.treesitter_search, {
        silent = true,
        desc = "Treesitter Search"
    })
    vim.keymap.set("n", "<leader>he", flash.toggle, {
        silent = true,
        desc = "Toggle Flash Search"
    })
end

return M

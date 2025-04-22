local M = {}

function M.setup()
    local flash = require("flash")

    -- ✅ 正確設定 flash，解決 highlight 報錯
    flash.setup({
        modes = {
            search = {
                enabled = true,
                highlight = {
                    backdrop = true,
                    matches = true
                },
                jump = {
                    history = true
                }
            }
        }
    })

end

return M

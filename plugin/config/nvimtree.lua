local M = {}

function M.setup()
    require("nvim-tree").setup({
        renderer = {
            icons = {
                show = {
                    file = true,
                    folder = true,
                    folder_arrow = true,
                    git = true
                }
            }
        },
        view = {
            width = 30,
            side = "left"
        }
    })
end

return M

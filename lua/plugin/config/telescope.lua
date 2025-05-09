local M = {}

function M.setup()
    require("telescope").setup({
        defaults = {
            prompt_prefix = "> ",
            selection_caret = "> ",
            path_display = {"smart"}
        }
    })

end

return M

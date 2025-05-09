local M = {}

function M.setup()
    require("bufferline").setup {
        options = {
            mode = "buffers", -- 也可設為 "tabs"
            diagnostics = "nvim_lsp",
            separator_style = "slant",
            show_buffer_close_icons = true,
            show_close_icon = false,
            always_show_bufferline = true
        }
    }
end

return M

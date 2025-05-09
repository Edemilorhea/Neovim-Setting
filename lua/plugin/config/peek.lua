local M = {}

function M.setup()
    require("peek").setup({
        auto_load = true,
        syntax = true,
        theme = "dark",
        update_on_change = true,
        filetype = {"markdown"},
        app = "browser"
    })
    vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
    vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
end

return M

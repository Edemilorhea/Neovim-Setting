local M = {}

function M.setup()
    local null_ls = require("null-ls")

    local sources = {null_ls.builtins.formatting.stylua, null_ls.builtins.formatting.prettier,
                     require("none-ls.diagnostics.eslint_d")}

    null_ls.setup({
        sources = sources
    })
end

return M


local M = {}

function M.setup()
    require("nvim-treesitter.configs").setup({
        ensure_installed = {
            "html", "css", "scss", "javascript", "typescript",
            "markdown", "vue", "c_sharp", "python"
        },
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false
        },
        indent = { enable = true },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "gnn",
                node_incremental = "grn",
                scope_incremental = "grc",
                node_decremental = "grm"
            }
        },
        fold = { enable = true }
    })
end

return M

-- neovimorg.lua => 模組化為 plugin/config/lsp.lua
local M = {}

function M.setup()
    -- Treesitter（可選，如果 PluginsList.lua 已處理可省略）
    local ts_ok, treesitter = pcall(require, "nvim-treesitter.configs")
    if ts_ok then
        treesitter.setup({
            ensure_installed = {"html", "javascript", "vue", "css", "python", "c_sharp"},
            highlight = {
                enable = true
            },
            indent = {
                enable = true
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "gnn",
                    node_incremental = "grn",
                    scope_incremental = "grc",
                    node_decremental = "grm"
                }
            }
        })
    end

    -- nvim-cmp（補全引擎）
    local cmp = require("cmp")
    cmp.setup({
        snippet = {
            expand = function(args)
                require("luasnip").lsp_expand(args.body)
            end
        },
        mapping = cmp.mapping.preset.insert({
            ["<C-y>"] = cmp.mapping.confirm({
                select = true
            }),
            ["<C-Space>"] = cmp.mapping.complete()
        }),
        sources = cmp.config.sources({{
            name = "nvim_lsp"
        }, {
            name = "luasnip"
        }}, {{
            name = "buffer"
        }, {
            name = "path"
        }})
    })

    -- null-ls
    local null_ls = require("null-ls")
    null_ls.setup({
        sources = {null_ls.builtins.formatting.prettier, -- html/css/js/vue
        null_ls.builtins.diagnostics.eslint, -- eslint
        null_ls.builtins.formatting.black -- python
        }
    })
end

return M


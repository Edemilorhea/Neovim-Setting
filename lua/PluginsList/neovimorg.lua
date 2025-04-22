---@diagnostic disable: undefined-global
local M = {}
function M.setup()
    -- Treesitter：語法高亮和增量選擇
    require("nvim-treesitter.configs").setup({
        ensure_installed = {"html", "javascript", "vue", "css", "python", "c_sharp"},
        highlight = {
            enable = true
        }, -- 啟用語法高亮
        indent = {
            enable = true
        }, -- 啟用智能縮排
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

    -- 配置自動補全
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
            }), -- 確認補全
            ["<C-Space>"] = cmp.mapping.complete() -- 手動觸發補全
        }),
        sources = cmp.config.sources({{
            name = "nvim_lsp"
        }, -- LSP 補全
        {
            name = "luasnip"
        } -- 代碼片段補全
        }, {{
            name = "buffer"
        }, -- 緩衝區補全
        {
            name = "path"
        } -- 文件路徑補全
        })
    })

    -- 配置 null-ls
    local null_ls = require("null-ls")
    null_ls.setup({
        sources = {null_ls.builtins.formatting.prettier, -- Prettier 用於格式化 HTML/CSS/JS/Vue
        null_ls.builtins.diagnostics.eslint, -- ESLint 用於 JS/Vue 診斷
        null_ls.builtins.formatting.black -- Black 用於格式化 Python
        }
    })
end

-- 移除這行，避免在 require 時就執行
-- print('lsp load')

return M

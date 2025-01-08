local M = {}

function M.setup()
    -- Treesitter：語法高亮和增量選擇
    require("nvim-treesitter.configs").setup {
        ensure_installed = { "html", "javascript", "vue", "css", "python", "c_sharp" },
        highlight = {
            enable = true, -- 啟用語法高亮
        },
        indent = {
            enable = true, -- 啟用智能縮排
        },
        incremental_selection = {
            enable = true, -- 啟用增量選擇
            keymaps = {
                init_selection = "gnn",
                node_incremental = "grn",
                scope_incremental = "grc",
                node_decremental = "grm",
            },
        },
    }

    -- 配置 Mason
    require("mason").setup()
    require("mason-lspconfig").setup({
        ensure_installed = {
            "html",       -- HTML 支持
            "cssls",      -- CSS 支持
            "tsserver",   -- JavaScript/TypeScript 支持
            "volar",      -- Vue 支持
            "pyright",    -- Python 支持
            "omnisharp",  -- C# 支持
        }
    })

    -- 配置 LSP
    local lspconfig = require("lspconfig")
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    lspconfig.html.setup({ capabilities = capabilities })
    lspconfig.cssls.setup({ capabilities = capabilities })
    lspconfig.tsserver.setup({ capabilities = capabilities })
    lspconfig.volar.setup({ capabilities = capabilities })
    lspconfig.pyright.setup({ capabilities = capabilities })
    lspconfig.omnisharp.setup({
        capabilities = capabilities,
        cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
    })

    -- 配置自動補全
    local cmp = require("cmp")
    cmp.setup({
        snippet = {
            expand = function(args)
                require("luasnip").lsp_expand(args.body)
            end,
        },
        mapping = cmp.mapping.preset.insert({
            ["<C-y>"] = cmp.mapping.confirm({ select = true }), -- 確認補全
            ["<C-Space>"] = cmp.mapping.complete(), -- 手動觸發補全
        }),
        sources = cmp.config.sources({
            { name = "nvim_lsp" }, -- LSP 補全
            { name = "luasnip" },  -- 代碼片段補全
        }, {
            { name = "buffer" },   -- 緩衝區補全
            { name = "path" },     -- 文件路徑補全
        }),
    })

    -- 配置 null-ls
    local null_ls = require("null-ls")
    null_ls.setup({
        sources = {
            null_ls.builtins.formatting.prettier, -- Prettier 用於格式化 HTML/CSS/JS/Vue
            null_ls.builtins.diagnostics.eslint, -- ESLint 用於 JS/Vue 診斷
            null_ls.builtins.formatting.black,   -- Black 用於格式化 Python
        },
    })
end

return M

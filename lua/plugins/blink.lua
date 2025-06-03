return {
    "saghen/blink.cmp",
    dependencies = {
        "rafamadriz/friendly-snippets",
    },
    version = "v0.*",
    opts = {
        -- 按鍵對應
        keymap = {
            preset = "default", -- 使用預設按鍵配置
            -- 或者自訂按鍵：
            ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
            -- ["<C-e>"] = { "hide" },
            ["<Tab>"] = { "accept", "fallback" },
            -- ["<CR>"] = { "accept", "fallback" },
            -- ["<Tab>"] = { "select_next", "fallback" },
            -- ["<S-Tab>"] = { "select_prev", "fallback" },
            -- ["<C-n>"] = { "select_next", "fallback" },
            -- ["<C-p>"] = { "select_prev", "fallback" },
        },

        -- 外觀設定
        appearance = {
            use_nvim_cmp_as_default = true,
            nerd_font_variant = "mono",
        },

        -- 完成設定
        completion = {
            accept = {
                auto_brackets = {
                    enabled = true,
                },
            },
            menu = {
                draw = {
                    treesitter = { "lsp" },
                },
            },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 200,
            },
        },

        -- 資料來源
        sources = {
            default = { "lsp", "path", "snippets", "buffer" },
            providers = {
                lsp = {
                    name = "LSP",
                    module = "blink.cmp.sources.lsp",
                },
                path = {
                    name = "Path",
                    module = "blink.cmp.sources.path",
                    score_offset = 3,
                },
                snippets = {
                    name = "Snippets",
                    module = "blink.cmp.sources.snippets",
                },
                buffer = {
                    name = "Buffer",
                    module = "blink.cmp.sources.buffer",
                },
            },
        },

        -- 簽名幫助
        signature = {
            enabled = true,
        },
    },
}

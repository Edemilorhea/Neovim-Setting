-- plugins/development.lua
-- 開發相關插件 (LSP、自動完成、搜尋工具)

return {
    -- Plenary - 基礎工具庫 (被依賴時自動載入)
    {
        "nvim-lua/plenary.nvim",
        lazy = true, -- 被其他插件依賴時會自動載入
        vscode = true,
    },

    -- Telescope 文件搜尋 (只在 Neovim 中使用)
    {
        "nvim-telescope/telescope.nvim",
        cmd = { "Telescope" },
        cond = not vim.g.vscode,
        dependencies = {
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                enabled = vim.fn.executable("make") == 1,
            },
        },
        config = function()
            require("telescope").setup({
                defaults = {
                    prompt_prefix = "> ",
                    selection_caret = "> ",
                    path_display = { "smart" },
                    file_ignore_patterns = { "node_modules", ".git/" },
                    layout_config = {
                        horizontal = {
                            preview_width = 0.55,
                            results_width = 0.8,
                        },
                        vertical = {
                            mirror = false,
                        },
                        width = 0.87,
                        height = 0.80,
                        preview_cutoff = 120,
                    },
                },
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    },
                },
            })
            pcall(require("telescope").load_extension, "fzf")
        end,
        keys = {
            { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find Files" },
            { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Live Grep" },
            { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
            { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help Tags" },
            { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Recent Files" },
            { "<leader>fw", "<cmd>Telescope grep_string<CR>", desc = "Find Word" },
        },
    },

    -- Mason LSP 管理器 (只在 Neovim 中使用)
    {
        "williamboman/mason.nvim",
        cmd = { "Mason", "MasonInstall", "MasonLog" },
        build = ":MasonUpdate",
        cond = not vim.g.vscode,
        opts = {},
    },

    {
        "williamboman/mason-lspconfig.nvim",
        event = "VeryLazy",
        cond = not vim.g.vscode,
        opts = {
            ensure_installed = {
                "lua_ls",
                "jsonls", 
                "ts_ls",
                "html",
                "cssls",
                "volar",
                "emmet_ls",
                "eslint",
                "omnisharp",
                "pyright",
                "marksman",
            },
        },
    },

    -- LSP 配置 (只在 Neovim 中使用)
    {
        "neovim/nvim-lspconfig",
        cond = not vim.g.vscode,
        opts = function()
            local Keys = require("lazyvim.plugins.lsp.keymaps").get()
            vim.list_extend(Keys, {
                { "gd", false },
                { "gr", false },
                { "gI", false },
                { "gy", false },
            })
        end,
    },

    -- 自動完成增強 (按需載入)
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter", -- 進入插入模式時載入
        dependencies = {
            "hrsh7th/cmp-emoji",
        },
    },

    -- Visual 模式重複操作 (VSCode + Neovim 共用)
    {
        "inkarkat/vim-visualrepeat",
        event = "VeryLazy",
        vscode = true,
    },
}
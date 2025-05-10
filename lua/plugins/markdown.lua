return { -- Glow Markdown 終端預覽 (LazyVim 沒有)
{
    "ellisonleao/glow.nvim",
    lazy = true,
    cmd = "Glow",
    config = function()
        if vim.g.vscode then
            return
        end

        require("glow").setup({
            style = "dark", -- 可設 "light" or "dark"
            width = 120,
            pager = false
        })
    end
}, -- Markdown 渲染增強 (LazyVim 沒有)
{
    "MeanderingProgrammer/render-markdown.nvim",
    lazy = true,
    dependencies = {"nvim-treesitter"},
    ft = "markdown",
    config = function()
        if vim.g.vscode then
            return
        end

        require("render-markdown").setup({})
    end
}, -- Markdown 瀏覽器預覽 (LazyVim 沒有)
{
    "toppair/peek.nvim",
    build = "deno task --quiet build:fast", -- 構建命令
    lazy = true,
    ft = "markdown", -- 只在 markdown 文件中加載
    cmd = {"PeekOpen", "PeekClose"}, -- 通過命令觸發加載
    config = function()
        if vim.g.vscode then
            return
        end

        require("peek").setup({
            auto_load = true,
            syntax = true,
            theme = "dark",
            update_on_change = true,
            filetype = {"markdown"},
            app = "browser"
        })

        -- 創建用戶命令
        vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
        vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
    end,
    -- 可選：添加快捷鍵
    keys = {{
        "<leader>mp",
        "<cmd>PeekOpen<CR>",
        desc = "打開 Markdown 預覽"
    }, {
        "<leader>mc",
        "<cmd>PeekClose<CR>",
        desc = "關閉 Markdown 預覽"
    }}
}, {
    "iamcco/markdown-preview.nvim",
    lazy = true,
    ft = "markdown",
    build = function()
        vim.fn["mkdp#util#install"]()
    end
}}

return { -- 程式碼折疊 (LazyVim 沒有)
{
    "kevinhwang91/nvim-ufo",
    dependencies = {"kevinhwang91/promise-async"},
    lazy = true,
    event = "BufReadPost", -- 在緩衝區讀取後加載
    config = function()
        if vim.g.vscode then
            return
        end

        require("ufo").setup({
            provider_selector = function(_, _, _)
                return {"treesitter", "indent"}
            end
        })

        -- 可選：設定折疊相關選項
        vim.o.foldlevel = 99 -- 打開文件時不自動折疊
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true
    end,
    -- 可選：添加快捷鍵
    keys = { -- 示例快捷鍵，您可以根據需要修改
    {
        "zR",
        function()
            require("ufo").openAllFolds()
        end,
        desc = "打開所有折疊"
    }, {
        "zM",
        function()
            require("ufo").closeAllFolds()
        end,
        desc = "關閉所有折疊"
    }, {
        "zr",
        function()
            require("ufo").openFoldsExceptKinds()
        end,
        desc = "打開一層折疊"
    }, {
        "zm",
        function()
            require("ufo").closeFoldsWith()
        end,
        desc = "關閉一層折疊"
    }, {
        "zp",
        function()
            require("ufo").peekFoldedLinesUnderCursor()
        end,
        desc = "預覽折疊內容"
    }}
}, -- 自動列表 (LazyVim 沒有)
{
    "gaoDean/autolist.nvim",
    lazy = true,
    ft = {"markdown", "text", "tex", "plaintex", "norg"},
    config = function()
        if vim.g.vscode then
            return
        end

        require("autolist").setup({})

        -- 縮排按鍵設定
        vim.keymap.set("i", "<Tab>", "<Cmd>AutolistTab<CR>", {
            desc = "Autolist Indent"
        })
        vim.keymap.set("i", "<S-Tab>", "<Cmd>AutolistShiftTab<CR>", {
            desc = "Autolist Dedent"
        })
        vim.keymap.set("n", "<C-r>", "<Cmd>AutolistRecalculate<CR>", {
            desc = "Autolist Recalculate"
        })
        vim.keymap.set("n", "<CR>", "<Cmd>AutolistToggleCheckbox<CR><CR>", {
            desc = "Autolist Toggle Checkbox"
        })

        -- 循環切換清單類型
        vim.keymap.set("n", "<leader>cn", require("autolist").cycle_next_dr, {
            expr = true,
            desc = "Autolist Cycle Next"
        })
        vim.keymap.set("n", "<leader>cp", require("autolist").cycle_prev_dr, {
            expr = true,
            desc = "Autolist Cycle Prev"
        })

        -- 編輯操作後自動重新計算
        vim.keymap.set("n", ">>", ">><Cmd>AutolistRecalculate<CR>", {
            desc = "Indent + Autolist Recalc"
        })
        vim.keymap.set("n", "<<", "<<<Cmd>AutolistRecalculate<CR>", {
            desc = "Dedent + Autolist Recalc"
        })

        -- 刪除行與重新計算
        vim.keymap.set("n", "dd", function()
            vim.cmd('normal! "_dd')
            vim.cmd("AutolistRecalculate")
        end, {
            desc = "Delete Line + Autolist Recalc"
        })

        -- 視覺模式操作
        vim.keymap.set("v", "d", function()
            vim.cmd('normal! "_d')
            vim.cmd("AutolistRecalculate")
        end, {
            desc = "Delete Visual + Autolist Recalc"
        })

        vim.keymap.set("v", "p", "p<Cmd>AutolistRecalculate<CR>", {
            desc = "Paste Visual + Autolist Recalc"
        })
    end
}, -- 輸入法切換 (LazyVim 沒有)
{
    "keaising/im-select.nvim",
    lazy = true,
    event = "InsertEnter",
    config = function()
        if vim.g.vscode then
            return
        end

        require("im_select").setup({
            -- 您的設定...
        })
    end
}, {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    opts = {
        -- 保留任何您想修改的原始設定
        -- options = { ... }
    },
    config = function(_, opts)
        if vim.g.vscode then
            return
        end

        -- 先正常設定 mini.comment
        require("mini.comment").setup(opts)

        -- 設定 Ctrl+/ 和 Ctrl+_ 快捷鍵

        -- Normal 模式：註釋當前行
        vim.keymap.set("n", "<C-/>", function()
            require("mini.comment").toggle_lines(vim.fn.line("."), vim.fn.line("."))
        end, {
            noremap = true,
            silent = true,
            desc = "Comment toggle current line"
        })

        vim.keymap.set("n", "<C-_>", function()
            require("mini.comment").toggle_lines(vim.fn.line("."), vim.fn.line("."))
        end, {
            noremap = true,
            silent = true,
            desc = "Comment toggle current line (C-_)"
        })

        -- Visual 模式：註釋選中行
        vim.keymap.set("v", "<C-/>", function()
            local start_line = vim.fn.line("'<")
            local end_line = vim.fn.line("'>")
            require("mini.comment").toggle_lines(start_line, end_line)
        end, {
            noremap = true,
            silent = true,
            desc = "Comment toggle visual lines"
        })

        vim.keymap.set("v", "<C-_>", function()
            local start_line = vim.fn.line("'<")
            local end_line = vim.fn.line("'>")
            require("mini.comment").toggle_lines(start_line, end_line)
        end, {
            noremap = true,
            silent = true,
            desc = "Comment toggle visual lines (C-_)"
        })

        -- 打印設定完成訊息
        print("mini.comment keymaps setup complete")
    end
}, {
    "numToStr/Comment.nvim",
    enabled = false, -- 預設禁用，需要時可切換為 true
    lazy = true,
    event = {"BufReadPost", "BufNewFile"},
    config = function()
        if vim.g.vscode then
            return
        end

        -- 基本設定
        require("Comment").setup()

        -- 載入 Comment.nvim 的 API 模組
        local comment_api = require("Comment.api")

        -- --- 設定 Comment.nvim 的 Ctrl+/ 和 Ctrl+_ 快捷鍵 ---

        -- 將 Ctrl+/ 映射到切換目前行註解 (Normal 模式)
        vim.keymap.set("n", "<C-/>", function()
            comment_api.toggle.linewise.current()
        end, {
            noremap = true,
            silent = true,
            desc = "Comment toggle current line"
        })

        -- 將 Ctrl+/ 映射到切換選取範圍的行註解 (Visual 模式)
        vim.keymap.set("v", "<C-/>", function()
            comment_api.toggle.linewise(vim.fn.visualmode())
        end, {
            noremap = true,
            silent = true,
            desc = "Comment toggle visual lines"
        })

        -- 同樣為 Ctrl+_ (某些終端機的備用) 進行映射
        vim.keymap.set("n", "<C-_>", function()
            comment_api.toggle.linewise.current()
        end, {
            noremap = true,
            silent = true,
            desc = "Comment toggle current line (C-_)"
        })

        vim.keymap.set("v", "<C-_>", function()
            comment_api.toggle.linewise(vim.fn.visualmode())
        end, {
            noremap = true,
            silent = true,
            desc = "Comment toggle visual lines (C-_)"
        })

        -- 在配置完成後輸出調試信息
        print("Comment.nvim keymaps setup complete")
    end
}, -- 修改 Treesitter 設定 (LazyVim 有但要補充設定)
{
    "nvim-treesitter/nvim-treesitter",
    lazy = vim.g.vscode, -- 在 VSCode 中懶加載
    build = ":TSUpdate",
    config = function()
        if vim.g.vscode then
            return
        end

        -- 設定 Treesitter 的安裝選項
        require("nvim-treesitter.install").prefer_git = true

        -- 指定使用預編譯的解析器
        require("nvim-treesitter.install").compilers = {"clang", "gcc", "cl", "zig"}

        require("nvim-treesitter.configs").setup({
            ensure_installed = {"lua", "vim", "vimdoc", "query" -- 先確保基本的能工作
            -- 添加其他語言前先確認以上工作正常
            },
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
}, -- Treesitter Playground (LazyVim 沒有)
{
    "nvim-treesitter/playground",
    lazy = true,
    cmd = {"TSPlaygroundToggle", "TSHighlightCapturesUnderCursor"}
}, {
    "kdheepak/lazygit.nvim",
    cmd = "LazyGit",
    keys = {{
        "<leader>lg",
        "<cmd>LazyGit<CR>",
        desc = "開啟 LazyGit"
    }},
    dependencies = {"nvim-lua/plenary.nvim"},
    config = function()
        if vim.g.vscode then
            return
        end

        -- 設定 lazygit 額外視窗樣式
        vim.g.lazygit_floating_window_winblend = 0
        vim.g.lazygit_floating_window_scaling_factor = 0.9
        vim.g.lazygit_use_neovim_remote = 1
    end
}}

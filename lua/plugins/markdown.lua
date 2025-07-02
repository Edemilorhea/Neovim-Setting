return { -- Glow Markdown 終端預覽 (LazyVim 沒有)
    {
        "ellisonleao/glow.nvim",
        lazy = true,
        cmd = "Glow",
        config = function()
            require("glow").setup({
                glow_path = "", -- will be filled automatically with your glow bin in $PATH, if any
                install_path = "~/.local/bin", -- default path for installing glow binary
                border = "shadow", -- floating window border config
                style = "dark", -- filled automatically with your current editor background, you can override using glow json style
                pager = false,
                width = 80,
                height = 100,
                width_ratio = 0.7, -- maximum width of the Glow window compared to the nvim window size (overrides `width`)
                height_ratio = 0.7,
            })
        end,
    }, -- Markdown 渲染增強 (LazyVim 沒有)
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
        ft = { "markdown" },
        opts = {
            -- 渲染模式
            enabled = true,
            debounce = 150,
            max_file_size = 5.0, -- MB，超過此大小不渲染

            -- 標題設定
            heading = {
                enabled = true,
                sign = true, -- 顯示標題符號
                position = "overlay", -- 'overlay' | 'inline' | 'right'
                icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
                signs = { "󰫎 " },
                width = "full", -- 'full' | 'block'
                backgrounds = { -- 標題背景顏色
                    "RenderMarkdownH1Bg",
                    "RenderMarkdownH2Bg",
                    "RenderMarkdownH3Bg",
                    "RenderMarkdownH4Bg",
                    "RenderMarkdownH5Bg",
                    "RenderMarkdownH6Bg",
                },
                foregrounds = { -- 標題前景顏色
                    "RenderMarkdownH1",
                    "RenderMarkdownH2",
                    "RenderMarkdownH3",
                    "RenderMarkdownH4",
                    "RenderMarkdownH5",
                    "RenderMarkdownH6",
                },
            },

            -- 代碼塊設定
            code = {
                enabled = true,
                sign = true,
                style = "full", -- 'full' | 'normal' | 'language' | 'none'
                position = "left", -- 'left' | 'right'
                language_pad = 2,
                -- disable_background = { "diff" },
                width = "full", -- 'full' | 'block'
                pad = 3,
                border = "thick", -- 'thick' | 'thin'
                above = "▀", -- 更細緻的邊框
                below = "▄",
                highlight_border = "RenderMarkdownCodeBorder",
                highlight_fallback = "RenderMarkdownCodeFallback",
                highlight = "RenderMarkdownCode",
                highlight_inline = "RenderMarkdownCodeInlineBg",
            },

            -- 清單設定（優雅的多層級圖標）
            bullet = {
                enabled = true,
                icons = { "◉", "○", "✸", "✿" }, -- 層次感更強的圖標
                left_pad = 0,
                right_pad = 1,
                highlight = "RenderMarkdownBullet",
            },

            -- 核取方塊設定（現代簡約風格）
            checkbox = {
                enabled = true,
                unchecked = {
                    icon = "⬜",
                    highlight = "RenderMarkdownUnchecked",
                    scope_highlight = nil,
                },
                checked = {
                    icon = "✅",
                    highlight = "RenderMarkdownChecked",
                    scope_highlight = nil,
                },
                custom = {
                    todo = { raw = "[-]", rendered = "⏳ ", highlight = "RenderMarkdownTodo" },
                    important = { raw = "[!]", rendered = "❗ ", highlight = "RenderMarkdownImportant" },
                    question = { raw = "[?]", rendered = "❓ ", highlight = "RenderMarkdownQuestion" },
                    progress = { raw = "[/]", rendered = "🔄 ", highlight = "RenderMarkdownProgress" },
                    cancelled = { raw = "[~]", rendered = "❌ ", highlight = "RenderMarkdownCancelled" },
                    star = { raw = "[*]", rendered = "⭐ ", highlight = "RenderMarkdownStar" },
                },
                -- 添加間距設定
                right_pad = 1, -- 右側增加間距
            },
            -- 引用設定（更優雅的引用線）
            quote = {
                enabled = true,
                icon = "┃", -- 更細緻的垂直線
                repeat_linebreak = false,
                highlight = "RenderMarkdownQuote",
            },

            -- 表格設定（圓角美化表格）
            pipe_table = {
                enabled = true,
                preset = "round", -- 'none' | 'round' | 'double' | 'heavy'
                style = "full", -- 'full' | 'normal' | 'none'
                cell = "padded", -- 'padded' | 'raw' | 'overlay'
                border = {
                    "╭", -- 圓角左上
                    "┬", -- 頂部分隔
                    "╮", -- 圓角右上
                    "├", -- 左側分隔
                    "┼", -- 中央交叉
                    "┤", -- 右側分隔
                    "╰", -- 圓角左下
                    "┴", -- 底部分隔
                    "╯", -- 圓角右下
                    "│", -- 垂直線
                    "─", -- 水平線
                },
                alignment_indicator = "━",
                head = "RenderMarkdownTableHead",
                row = "RenderMarkdownTableRow",
                filler = "RenderMarkdownTableFill",
            },

            -- 連結設定（豐富的圖標類型）
            link = {
                enabled = true,
                image = "🖼️ ", -- 圖片
                email = "📧 ", -- 郵件
                hyperlink = "🔗 ", -- 超連結
                highlight = "RenderMarkdownLink",
                custom = {
                    internal_heading = {
                        pattern = "^#[^%s]",
                        icon = "📍 ",
                        highlight = "RenderMarkdownInternalLink",
                    },
                    web = { pattern = "^http", icon = "🌐 ", highlight = "RenderMarkdownLink" },
                    github = { pattern = "github%.com", icon = "🐙 ", highlight = "RenderMarkdownLink" },
                    youtube = { pattern = "youtube%.com", icon = "📺 ", highlight = "RenderMarkdownLink" },
                    file = { pattern = "^file:", icon = "📁 ", highlight = "RenderMarkdownLink" },
                    wiki = { pattern = "%[%[.*%]%]", icon = "📝 ", highlight = "RenderMarkdownWikiLink" },
                    obsidian = {
                        pattern = "obsidian://",
                        icon = "🔮 ",
                        highlight = "RenderMarkdownLink",
                    },
                    pdf = {
                        pattern = "%.pdf$",
                        icon = "📄 ",
                        highlight = "RenderMarkdownLink",
                    },
                    markdown = {
                        pattern = "%.md$",
                        icon = "📋 ",
                        highlight = "RenderMarkdownLink",
                    },
                    heading = {
                        pattern = "#[%w%-_]+",
                        icon = "🔗 ",
                        highlight = "RenderMarkdownHeadingLink",
                    },
                    anchor = {
                        pattern = "#.*",
                        icon = "⚓ ",
                        highlight = "RenderMarkdownAnchorLink",
                    },
                },
            },

            callout = {
                -- GitHub 風格標註
                note = { raw = "[!NOTE]", rendered = "󰋽 Note", highlight = "RenderMarkdownInfo" },
                tip = { raw = "[!TIP]", rendered = "󰌶 Tip", highlight = "RenderMarkdownSuccess" },
                important = { raw = "[!IMPORTANT]", rendered = "󰅾 Important", highlight = "RenderMarkdownHint" },
                warning = { raw = "[!WARNING]", rendered = "󰀪 Warning", highlight = "RenderMarkdownWarn" },
                caution = { raw = "[!CAUTION]", rendered = "󰳦 Caution", highlight = "RenderMarkdownError" },

                -- Obsidian 完整標註支援
                abstract = { raw = "[!ABSTRACT]", rendered = "󰨸 Abstract", highlight = "RenderMarkdownInfo" },
                summary = { raw = "[!SUMMARY]", rendered = "󰨸 Summary", highlight = "RenderMarkdownInfo" },
                tldr = { raw = "[!TLDR]", rendered = "󰨸 Tldr", highlight = "RenderMarkdownInfo" },
                info = { raw = "[!INFO]", rendered = "󰋽 Info", highlight = "RenderMarkdownInfo" },
                todo = { raw = "[!TODO]", rendered = "󰗡 Todo", highlight = "RenderMarkdownInfo" },
                hint = { raw = "[!HINT]", rendered = "󰌶 Hint", highlight = "RenderMarkdownSuccess" },
                success = { raw = "[!SUCCESS]", rendered = "󰄬 Success", highlight = "RenderMarkdownSuccess" },
                check = { raw = "[!CHECK]", rendered = "󰄬 Check", highlight = "RenderMarkdownSuccess" },
                done = { raw = "[!DONE]", rendered = "󰄬 Done", highlight = "RenderMarkdownSuccess" },
                question = { raw = "[!QUESTION]", rendered = "󰘥 Question", highlight = "RenderMarkdownWarn" },
                help = { raw = "[!HELP]", rendered = "󰘥 Help", highlight = "RenderMarkdownWarn" },
                faq = { raw = "[!FAQ]", rendered = "󰘥 Faq", highlight = "RenderMarkdownWarn" },
                attention = { raw = "[!ATTENTION]", rendered = "󰀪 Attention", highlight = "RenderMarkdownWarn" },
                failure = { raw = "[!FAILURE]", rendered = "󰅖 Failure", highlight = "RenderMarkdownError" },
                fail = { raw = "[!FAIL]", rendered = "󰅖 Fail", highlight = "RenderMarkdownError" },
                missing = { raw = "[!MISSING]", rendered = "󰅖 Missing", highlight = "RenderMarkdownError" },
                danger = { raw = "[!DANGER]", rendered = "󱐌 Danger", highlight = "RenderMarkdownError" },
                error = { raw = "[!ERROR]", rendered = "󱐌 Error", highlight = "RenderMarkdownError" },
                bug = { raw = "[!BUG]", rendered = "󰨰 Bug", highlight = "RenderMarkdownError" },
                example = { raw = "[!EXAMPLE]", rendered = "󰉹 Example", highlight = "RenderMarkdownHint" },
                quote = { raw = "[!QUOTE]", rendered = "󱆨 Quote", highlight = "RenderMarkdownQuote" },
                cite = { raw = "[!CITE]", rendered = "󱆨 Cite", highlight = "RenderMarkdownQuote" },
            },

            strikethrough = {
                enabled = true,
                highlight = "RenderMarkdownStrikethrough",
            },
            dash = {
                enabled = true,
                icon = "─",
                width = "full",
                highlight = "RenderMarkdownDash",
            },

            latex = {
                enabled = true,
                converter = "latex2text", -- 需要安裝 latex2text
                highlight = "RenderMarkdownMath",
                top_pad = 0,
                bottom_pad = 0,
            },

            -- 快捷鍵設定
            win_options = {
                conceallevel = {
                    default = vim.o.conceallevel,
                    rendered = 3,
                },
                concealcursor = {
                    default = vim.o.concealcursor,
                    rendered = "",
                },
            },
        },
    },
    {
        "iamcco/markdown-preview.nvim",
        lazy = false,
        build = "cd app && npm install", -- 改用 npm
        config = function()
            vim.g.mkdp_auto_start = 0
        end,
    },
    {
        -- 保留原有的 TOC 插件
        "mzlogin/vim-markdown-toc",
        ft = "markdown",
        config = function()
            vim.g.vmt_auto_update_on_save = 0 -- 關閉自動更新，避免覆蓋 Wiki 格式
            vim.g.vmt_fence_text = "TOC"
            vim.g.vmt_fence_closing_text = "/TOC"
        end,
        keys = {
            -- Markdown 格式 TOC
            { "<leader>mt", ":GenTocGFM<CR>", desc = "Generate Markdown TOC" },
            -- Wiki 格式 TOC（自訂函數）
            {
                "<leader>mw",
                function()
                    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
                    local toc = { "<!-- TOC -->" }

                    for _, line in ipairs(lines) do
                        local level, title = line:match("^(#+)%s+(.+)")
                        if level and title then
                            local indent = string.rep("    ", #level - 1)
                            table.insert(toc, string.format("%s* [[#%s]]", indent, title))
                        end
                    end

                    table.insert(toc, "<!-- /TOC -->")
                    table.insert(toc, "")
                    vim.api.nvim_buf_set_lines(0, 0, 0, false, toc)
                end,
                desc = "Generate Wiki TOC",
            },
        },
    },

    -- {
    --     "toppair/peek.nvim",
    --     build = "deno task --quiet build:fast", -- 構建命令
    --     lazy = true,
    --     ft = "markdown", -- 只在 markdown 文件中加載
    --     cmd = { "PeekOpen", "PeekClose" }, -- 通過命令觸發加載
    --     config = function()
    --         if vim.g.vscode then
    --             return
    --         end
    --
    --         require("peek").setup({
    --             auto_load = true,
    --             syntax = true,
    --             theme = "dark",
    --             update_on_change = true,
    --             filetype = { "markdown" },
    --             app = "browser",
    --         })
    --
    --         -- 創建用戶命令
    --         vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
    --         vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
    --     end,
    --     -- 可選：添加快捷鍵
    --     keys = {
    --         {
    --             "<leader>mp",
    --             "<cmd>PeekOpen<CR>",
    --             desc = "打開 Markdown 預覽",
    --         },
    --         {
    --             "<leader>mc",
    --             "<cmd>PeekClose<CR>",
    --             desc = "關閉 Markdown 預覽",
    --         },
    --     },
    -- },
}

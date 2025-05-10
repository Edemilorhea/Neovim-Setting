-- PluginsList.lua (已修正：避免在 VSCode 中執行不必要設定)
--local is_vscode = vim.g.vscode == 1
local packer_bootstrap = (function()
    local fn = vim.fn
    local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
        vim.cmd([[packadd packer.nvim]])
        return true
    end
    return false
end)()

return require("packer").startup(function(use)
    use({ "wbthomason/packer.nvim" })

    use({
        "williamboman/mason.nvim",
        tag = "v1.11.0", -- ✅ 最新 v1 穩定版（或你想要的其他 v1.x.x）
    })
    use({
        "williamboman/mason-lspconfig.nvim",
        tag = "v1.32.0", -- ✅ 第一個支援 setup_handlers 的版本
        requires = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    })
    use({
        "hrsh7th/nvim-cmp",
        requires = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "saadparwaiz1/cmp_luasnip",
            "L3MON4D3/LuaSnip",
        },
    })

    use({
        "nvimtools/none-ls.nvim", -- null-ls 的新名稱
        requires = { "nvim-lua/plenary.nvim", "nvimtools/none-ls-extras.nvim" },
    })

    use({
        "folke/flash.nvim",
    })

    use({
        "kylechui/nvim-surround",
        version = "*",
    })

    use({
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate",
    })

    use({
        "nvim-treesitter/playground",
        cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
    })

    use({
        "kevinhwang91/nvim-ufo",
        requires = "kevinhwang91/promise-async",
        config = function()
            require("plugin.config.ufo").setup()
        end,
    })

    use({
        "nvim-tree/nvim-tree.lua",
        requires = "nvim-tree/nvim-web-devicons",
    })

    use({
        "toppair/peek.nvim",
        run = "deno task --quiet build:fast",
    })

    use({
        "keaising/im-select.nvim",
    })

    use({
        "nvim-lualine/lualine.nvim",
        requires = {
            "nvim-tree/nvim-web-devicons",
            opt = true,
        },
    })

    use({
        "nvim-telescope/telescope.nvim",
        requires = { "nvim-lua/plenary.nvim" },
    })

    use({
        "folke/trouble.nvim",
        requires = "nvim-tree/nvim-web-devicons",
        config = function()
            require("trouble").setup({
                -- 可以設定 icons 或其他 options
            })
        end,
    })

    use({
        "akinsho/bufferline.nvim",
        tag = "*",
        requires = "nvim-tree/nvim-web-devicons",
    })

    use({ "Hoffs/omnisharp-extended-lsp.nvim" })

    use({
        "folke/tokyonight.nvim",
        config = function()
            vim.cmd("colorscheme tokyonight")
        end,
    })

    use({
        "epwalsh/obsidian.nvim",
        tag = "*", -- 推薦使用最新發布版本，而非最新提交
        requires = {
            -- 必需的依賴
            "nvim-lua/plenary.nvim",
        },
    })

    use({
        "kdheepak/lazygit.nvim",
        requires = { "nvim-lua/plenary.nvim" },
        cmd = { "LazyGit" },
    })

    use({
        "folke/which-key.nvim",
        config = function()
            require("which-key").setup({}) --沒有特別設定直接寫在這，如果有設定再移到外圍
        end,
    })

    use({
        "ellisonleao/glow.nvim",
        cmd = "Glow",
        config = function()
            require("glow").setup({
                style = "dark", -- 可設 "light" or "dark"
                width = 120,
                pager = false,
            })
        end,
    })

    --	use({
    --		"preservim/vim-markdown",
    --		ft = { "markdown" },
    --		config = function()
    --			-- 這裡可以設定一些 options
    --			vim.g.vim_markdown_folding_disabled = 1
    --			vim.g.vim_markdown_conceal = 2
    --			vim.g.vim_markdown_conceal_code_blocks = 0
    --			vim.g.vim_markdown_new_list_item_indent = 2
    --			vim.g.vim_markdown_auto_insert_bullets = 1
    --		end,
    --	})

    -- 在你的 lazy.nvim 設定檔中 (例如 lua/plugins/autolist.lua 或類似檔案)
    use({
        "gaoDean/autolist.nvim",
        -- ft 指定哪些檔案類型要啟用 autolist
        ft = {
            "markdown",
            "text",
            "tex",
            "plaintex",
            "norg",
            -- 你可以根據需要添加或移除檔案類型
        },
        config = function()
            -- 基本的 setup 仍然需要呼叫，以啟用核心功能
            require("autolist").setup({
                -- 在這裡可以放置你的自訂設定，例如 cycle 的順序等
                -- 如果不需要自訂，保留空的 setup() 或省略參數即可
                -- 例如:
                -- cycle = { "-", "*", "1.", "a)", "I." },
            })

            print("Autolist setup complete. Mappings (excluding CR/o/O) applied.") -- 除錯訊息

            -- === 設定你需要的按鍵映射 ===

            -- 縮排 (Indent): 使用 Tab 鍵縮排，並觸發 autolist 的上下文處理和重新計算
            vim.keymap.set("i", "<Tab>", "<Cmd>AutolistTab<CR>", { desc = "Autolist Indent" })

            -- 反縮排 (Dedent): 使用 Shift+Tab 鍵反縮排，並觸發 autolist 的上下文處理和重新計算
            vim.keymap.set("i", "<S-Tab>", "<Cmd>AutolistShiftTab<CR>", { desc = "Autolist Dedent" })

            -- 手動重新計算清單: 在 Normal 模式下按 Ctrl+r 觸發
            vim.keymap.set("n", "<C-r>", "<Cmd>AutolistRecalculate<CR>", { desc = "Autolist Recalculate" })

            -- 切換核取方塊狀態: 在 Normal 模式下按 Enter 鍵 (注意：這是 Normal 模式的 Enter)
            vim.keymap.set("n", "<CR>", "<Cmd>AutolistToggleCheckbox<CR><CR>", { desc = "Autolist Toggle Checkbox" })

            -- 循環切換清單類型 (支援 dot-repeat)
            -- 將 <leader>cn 映射到下一個清單類型
            vim.keymap.set(
                "n",
                "<leader>cn",
                require("autolist").cycle_next_dr,
                { expr = true, desc = "Autolist Cycle Next" }
            )
            -- 將 <leader>cp 映射到上一個清單類型
            vim.keymap.set(
                "n",
                "<leader>cp",
                require("autolist").cycle_prev_dr,
                { expr = true, desc = "Autolist Cycle Prev" }
            )

            -- (可選) 在常用編輯操作後自動重新計算 (讓 dd, >>, << 等操作後自動更新序號)
            vim.keymap.set("n", ">>", ">><Cmd>AutolistRecalculate<CR>", { desc = "Indent + Autolist Recalc" })
            vim.keymap.set("n", "<<", "<<<Cmd>AutolistRecalculate<CR>", { desc = "Dedent + Autolist Recalc" })

            -- Normal 模式：刪除整行 + Autolist
            vim.keymap.set("n", "dd", function()
                vim.cmd('normal! "_dd')
                vim.cmd("AutolistRecalculate")
            end, { desc = "Delete Line + Autolist Recalc" })

            -- Visual 模式：刪除選取 + Autolist
            vim.keymap.set("v", "d", function()
                vim.cmd('normal! "_d')
                vim.cmd("AutolistRecalculate")
            end, { desc = "Delete Visual + Autolist Recalc" })

            vim.keymap.set("v", "p", "p<Cmd>AutolistRecalculate<CR>", { desc = "Paste Visual + Autolist Recalc" }) -- 貼上後可能也需要

            vim.keymap.set("i", "<CR>", "<CR><cmd>AutolistNewBullet<cr>")                                 -- 不設定這個
            vim.keymap.set("n", "o", "o<cmd>AutolistNewBullet<cr><Esc>")                                  -- 不設定這個
            vim.keymap.set("n", "O", "O<cmd>AutolistNewBulletBefore<cr><Esc>")                            -- 不設定這個
        end,
    })

    use( -- lazy.nvim 的寫法
        {
            "numToStr/Comment.nvim",
            config = function()
                require("Comment").setup()
                -- 你可以在這裡加自訂快捷鍵
                vim.keymap.set("n", "<C-_>", function()
                    require("Comment.api").toggle.linewise.current()
                end, { noremap = true, silent = true })
                vim.keymap.set(
                    "v",
                    "<C-_>",
                    "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
                    { noremap = true, silent = true }
                )
            end,
        }
    )
    use({
        "MeanderingProgrammer/render-markdown.nvim",
        after = { "nvim-treesitter" },
        requires = { "echasnovski/mini.nvim", opt = true }, -- if you use the mini.nvim suite
        -- requires = { 'echasnovski/mini.icons', opt = true }, -- if you use standalone mini plugins
        -- requires = { 'nvim-tree/nvim-web-devicons', opt = true }, -- if you prefer nvim-web-devicons
        config = function()
            require("render-markdown").setup({})
        end,
    })

    use({
        "iamcco/markdown-preview.nvim",
        run = function()
            vim.fn["mkdp#util#install"]()
        end,
    })

    -- 加入 symbols-outline.nvim 插件，使用 use({}) 語法
    use({
        "simrat39/symbols-outline.nvim",
        config = function()
            -- *** 將你提供的 local opts 表格完整複製到這裡 ***
            local opts = {
                highlight_hovered_item = true,
                show_guides = true,
                auto_preview = false,
                position = "right",
                relative_width = true,
                width = 25,
                auto_close = false,
                show_numbers = false,
                show_relative_numbers = false,
                show_symbol_details = true,
                preview_bg_highlight = "Pmenu",
                autofold_depth = nil,
                auto_unfold_hover = true,
                fold_markers = { "", "" },
                wrap = false,
                keymaps = { -- These keymaps can be a string or a table for multiple keys
                    close = { "<Esc>", "q" },
                    goto_location = "<Cr>",
                    focus_location = "o",
                    hover_symbol = "<C-space>",
                    toggle_preview = "K",
                    rename_symbol = "r",
                    code_actions = "a",
                    fold = "h",
                    unfold = "l",
                    fold_all = "W",
                    unfold_all = "E",
                    fold_reset = "R",
                },
                lsp_blacklist = {},
                symbol_blacklist = {},
                symbols = {
                    File = { icon = "", hl = "@text.uri" },
                    Module = { icon = "", hl = "@namespace" },
                    Namespace = { icon = "", hl = "@namespace" },
                    Package = { icon = "", hl = "@namespace" },
                    Class = { icon = "𝓒", hl = "@type" },
                    Method = { icon = "ƒ", hl = "@method" },
                    Property = { icon = "", hl = "@method" },
                    Field = { icon = "", hl = "@field" },
                    Constructor = { icon = "", hl = "@constructor" },
                    Enum = { icon = "ℰ", hl = "@type" },
                    Interface = { icon = "ﰮ", hl = "@type" },
                    Function = { icon = "", hl = "@function" },
                    Variable = { icon = "", hl = "@constant" },
                    Constant = { icon = "", hl = "@constant" },
                    String = { icon = "𝓐", hl = "@string" },
                    Number = { icon = "#", hl = "@number" },
                    Boolean = { icon = "⊨", hl = "@boolean" },
                    Array = { icon = "", hl = "@constant" },
                    Object = { icon = "⦿", hl = "@type" },
                    Key = { icon = "🔐", hl = "@type" },
                    Null = { icon = "NULL", hl = "@type" },
                    EnumMember = { icon = "", hl = "@field" },
                    -- *** 請注意：你提供的 Struct 和 Event 以及最後兩行有語法錯誤，已在下方修正前兩個，請檢查後兩個或刪除 ***
                    Struct = { icon = "𝓢", hl = "@type" }, -- <--- 已修正: 加上 icon =
                    Event = { icon = "🗲", hl = "@type" }, -- <--- 已修正: 加上 icon =
                    -- 原來的 = { = "+", hl = "@" },          -- <--- 這行有語法錯誤，請檢查原始設定或刪除
                    TypeParameter = { icon = "𝙏", hl = "@parameter" }, -- 這行本來 icon = 就正確
                    Component = { icon = "", hl = "@function" }, -- 這行本來 icon = 就正確
                    -- 原來的 = { = "", hl = "@constant" },   -- <--- 這行有語法錯誤，請檢查原始設定或刪除
                },
                -- ... 你其他的選項 ...
            }
            -- *** 複製到這裡結束 ***

            -- 然後將這個 opts 表格傳遞給 setup 函數
            require("symbols-outline").setup(opts)
        end,
        -- 如果你選擇了延遲載入，保持 cmd 或 event 在這裡
        -- cmd = "SymbolsOutline",
    }) -- <-- 注意這裡的結束括號和圓括號

    use({
        "ray-x/lsp_signature.nvim",
        config = function()
            require("lsp_signature").setup({
                hint_enable = true,
                floating_window = false,
                hint_prefix = "💡 ",
            })
        end,
    })

    -- use({
    --     "rachartier/tiny-inline-diagnostic.nvim",
    --     event = "BufReadPost", -- ✅ Neovim 內建事件
    --     config = function()
    --         require("tiny-inline-diagnostic").setup()
    --         vim.diagnostic.config({ virtual_text = false })
    --     end,
    -- })

    use({
        "folke/noice.nvim",
        requires = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        config = function()
            require("noice").setup({
                presets = {
                    command_palette = true, -- 按 : 用浮動輸入列
                    lsp_doc_border = true,
                },
                cmdline = {
                    view = "cmdline_popup",
                    format = {
                        cmdline = { icon = "" },
                        search_down = { icon = " " },
                        search_up = { icon = " " },
                    },
                },
            })
        end,
    })

    if packer_bootstrap then
        require("packer").sync()
    end
end)

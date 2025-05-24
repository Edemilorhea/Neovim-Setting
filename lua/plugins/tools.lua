return { -- Peek Markdown 預覽 (LazyVim 沒有)
    {
        "inkarkat/vim-visualrepeat",
        event = "VeryLazy", -- 或你喜歡的啟動條件
    },
    {
        "toppair/peek.nvim",
        lazy = true,
        build = "deno task --quiet build:fast",
        ft = "markdown",
        config = function()
            if vim.g.vscode then
                return
            end

            require("peek").setup({
                -- 您的設定...
            })
        end,
    }, -- Obsidian 整合 (LazyVim 沒有)
    {
        "epwalsh/obsidian.nvim",
        version = "*", -- 使用最新穩定版
        vscode = false,
        -- 只在 Obsidian 筆記庫中載入
        -- 可選：只在 Obsidian 筆記庫中載入
        -- event = {
        --   "BufReadPre " .. vim.fn.expand "~" .. "/path/to/your/vault/*.md",
        --   "BufNewFile " .. vim.fn.expand "~" .. "/path/to/your/vault/*.md",
        -- },
        dependencies = {
            "nvim-lua/plenary.nvim", -- 必備依賴
            -- 可選依賴
            {
                "hrsh7th/nvim-cmp", -- 自動完成
                event = "VeryLazy",
            },
            "nvim-telescope/telescope.nvim", -- 搜尋功能
            "nvim-treesitter/nvim-treesitter", -- 語法高亮
        },
        opts = {
            -- 工作區設定 (相對路徑，支援多機同步)
            workspaces = {
                {
                    name = "main",
                    path = vim.fn.expand("~/Documents/Obsidian Vault"), -- 使用 ~ 自動展開用戶目錄
                },
                -- 如果有多個筆記庫可以添加更多
                -- {
                --   name = "work",
                --   path = vim.fn.expand("~/Documents/WorkVault"),
                -- },
            },

            -- 筆記管理設定
            notes_subdir = "notes", -- 筆記子目錄，可設為 nil 如果不需要
            new_notes_location = "notes_subdir", -- 新筆記建立位置

            -- 日記設定
            daily_notes = {
                folder = "dailies", -- 日記資料夾
                date_format = "%Y-%m-%d", -- 日期格式
                alias_format = "%B %-d, %Y", -- 別名格式
                default_tags = { "daily-notes" }, -- 預設標籤
                template = nil, -- 日記模板，可設定模板檔名
            },

            -- 自動完成設定
            completion = {
                nvim_cmp = true, -- 啟用 nvim-cmp 整合
                min_chars = 2, -- 觸發完成的最少字元數
            },

            -- 筆記 ID 生成函數
            note_id_func = function(title)
                local suffix = ""
                if title ~= nil then
                    -- 將標題轉換為有效檔名
                    suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
                else
                    -- 如果沒有標題，添加隨機字母
                    for _ = 1, 4 do
                        suffix = suffix .. string.char(math.random(65, 90))
                    end
                end
                return tostring(os.time()) .. "-" .. suffix
            end,

            -- 筆記路徑生成函數
            note_path_func = function(spec)
                local path = spec.dir / tostring(spec.id)
                return path:with_suffix(".md")
            end,

            -- 連結格式設定
            wiki_link_func = function(opts)
                return require("obsidian.util").wiki_link_id_prefix(opts)
            end,
            markdown_link_func = function(opts)
                return require("obsidian.util").markdown_link(opts)
            end,
            preferred_link_style = "wiki", -- "wiki" 或 "markdown"

            -- 前置資料 (frontmatter) 設定
            disable_frontmatter = false,
            note_frontmatter_func = function(note)
                if note.title then
                    note:add_alias(note.title)
                end
                local out = { id = note.id, aliases = note.aliases, tags = note.tags }
                if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
                    for k, v in pairs(note.metadata) do
                        out[k] = v
                    end
                end
                return out
            end,

            -- 模板設定
            templates = {
                folder = "templates", -- 模板資料夾
                date_format = "%Y-%m-%d", -- 日期格式
                time_format = "%H:%M", -- 時間格式
                substitutions = {
                    -- 自訂變數替換
                    yesterday = function()
                        return os.date("%Y-%m-%d", os.time() - 86400)
                    end,
                },
            },

            -- 外部連結處理 (跨平台)
            follow_url_func = function(url)
                local os_name = vim.loop.os_uname().sysname
                if os_name == "Windows_NT" then
                    vim.cmd(':silent exec "!start ' .. url .. '"')
                elseif os_name == "Darwin" then
                    vim.fn.jobstart({ "open", url })
                else -- Linux
                    vim.fn.jobstart({ "xdg-open", url })
                end
            end,

            -- 圖片處理 (跨平台)
            follow_img_func = function(img)
                local os_name = vim.loop.os_uname().sysname
                if os_name == "Windows_NT" then
                    vim.cmd(':silent exec "!start ' .. img .. '"')
                elseif os_name == "Darwin" then
                    vim.fn.jobstart({ "qlmanage", "-p", img })
                else -- Linux
                    vim.fn.jobstart({ "xdg-open", img })
                end
            end,

            -- 選擇器設定
            picker = {
                name = "telescope.nvim", -- 使用 telescope
                note_mappings = {
                    new = "<C-x>", -- 建立新筆記
                    insert_link = "<C-l>", -- 插入連結
                },
                tag_mappings = {
                    tag_note = "<C-x>", -- 標記筆記
                    insert_tag = "<C-l>", -- 插入標籤
                },
            },

            -- 搜尋設定
            sort_by = "modified", -- 按修改時間排序
            sort_reversed = true, -- 最新的在前
            search_max_lines = 1000, -- 搜尋最大行數

            -- 筆記開啟方式
            open_notes_in = "current", -- "current", "vsplit", "hsplit"

            -- 附件設定
            attachments = {
                img_folder = "assets/imgs", -- 圖片資料夾
                img_name_func = function()
                    return string.format("%s-", os.time()) -- 時間戳前綴
                end,
                img_text_func = function(client, path)
                    path = client:vault_relative_path(path) or path
                    return string.format("![%s](%s)", path.name, path)
                end,
            },

            -- **重要：停用 UI 功能，使用 render-markdown.nvim**
            ui = {
                enable = false,
                update_debounce = 50, -- 縮短 obsidian 更新時間
                checkboxes = {
                    [" "] = { char = " ", hl_group = "Normal" }, -- 保持原始，不干擾
                    ["x"] = { char = "x", hl_group = "Normal" },
                    [">"] = { char = ">", hl_group = "Normal" },
                    ["~"] = { char = "~", hl_group = "Normal" },
                    ["!"] = { char = "!", hl_group = "Normal" },
                    ["*"] = { char = "*", hl_group = "Normal" },
                    ["-"] = { char = "-", hl_group = "Normal" },
                    ["?"] = { char = "?", hl_group = "Normal" },
                    ["/"] = { char = "/", hl_group = "Normal" },
                },
            },
            -- 按鍵對應 (保留核心功能)
            mappings = {
                -- 跟隨連結
                ["gf"] = {
                    action = function()
                        return require("obsidian").util.gf_passthrough()
                    end,
                    opts = { noremap = false, expr = true, buffer = true },
                },
                -- 切換複選框
                ["<leader>ch"] = {
                    action = function()
                        return require("obsidian").util.toggle_checkbox()
                    end,
                    opts = { buffer = true },
                },
                -- 智慧動作 (跟隨連結或切換複選框)
                ["<cr>"] = {
                    action = function()
                        return require("obsidian").util.smart_action()
                    end,
                    opts = { buffer = true, expr = true },
                },
            },

            -- Obsidian 應用設定
            use_advanced_uri = false, -- 是否使用 Advanced URI 插件
            open_app_foreground = false, -- 是否將 Obsidian 應用帶到前台

            -- 回調函數 (可選)
            callbacks = {
                post_setup = function(client) end,
                enter_note = function(client, note) end,
                leave_note = function(client, note) end,
                pre_write_note = function(client, note) end,
                post_set_workspace = function(client, workspace) end,
            },
        },
    },
    --
    -- 修改 Telescope 設定 (LazyVim 有但要修改)
    {
        "nvim-lua/plenary.nvim",
        lazy = false, -- ✅ 立即加載，確保任何時候都能用
        vscode = true, -- ✅ 明確指定在 VSCode 中也會載入
    },
    {
        "nvim-telescope/telescope.nvim",
        vscode = false,
        version = false,
        lazy = false, -- 立即加載以避免命令延遲問題
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

            -- 載入 fzf 擴展
            pcall(require("telescope").load_extension, "fzf")
        end,
        keys = {
            { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find Files" },
            { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Live Grep" },
            { "fb", "Telescope buffers", desc = "Buffers" },
            { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help Tags" },
        },
    },
}

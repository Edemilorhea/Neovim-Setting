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
                    path = vim.fn.expand("~/Documents/Obsidian_Note"), -- 使用 ~ 自動展開用戶目錄
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
            -- 自訂 Wiki 連結函數處理中文標題
            wiki_link_func = function(opts)
                if opts.anchor then
                    local anchor = opts.anchor.anchor
                    if opts.path then
                        return string.format("[[%s#%s]]", opts.path, anchor)
                    else
                        return string.format("[[#%s]]", anchor)
                    end
                end
                if opts.label and opts.label ~= opts.path then
                    return string.format("[[%s|%s]]", opts.path or opts.id, opts.label)
                else
                    return string.format("[[%s]]", opts.path or opts.id)
                end
            end,
            markdown_link_func = function(opts)
                return require("obsidian.util").markdown_link(opts)
            end,
            preferred_link_style = "markdown", -- "wiki" 或 "markdown"
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
                enable = true,
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
            -- 按鍵對應 (保留核心功能 + 新增 TOC 功能)
            mappings = {
                -- 跟隨連結
                ["gf"] = {
                    action = function()
                        return require("obsidian").util.gf_passthrough()
                    end,
                    opts = { buffer = true, expr = true, noremap = true },
                },
                -- 切換複選框
                ["<leader>ch"] = {
                    action = function()
                        require("obsidian").util.toggle_checkbox()
                    end,
                    opts = { buffer = true, noremap = true },
                },
                -- 智慧動作 (跟隨連結或切換複選框)
                ["<CR>"] = {
                    action = function()
                        return require("obsidian").util.smart_action()
                    end,
                    opts = { buffer = true, expr = true, noremap = true },
                },

                -- **新增 TOC 功能**
                -- 生成 Wiki 格式 TOC (支援中文標題)
                ["<leader>mt"] = {
                    action = function()
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

                        -- 尋找並替換現有 TOC
                        local start_line, end_line = nil, nil
                        local current_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
                        for i, line in ipairs(current_lines) do
                            if line:match("<!-- TOC -->") then
                                start_line = i - 1
                            elseif line:match("<!-- /TOC -->") and start_line then
                                end_line = i
                                break
                            end
                        end

                        if start_line and end_line then
                            vim.api.nvim_buf_set_lines(0, start_line, end_line, false, toc)
                            print("TOC 已更新")
                        else
                            vim.api.nvim_buf_set_lines(0, 0, 0, false, toc)
                            print("TOC 已生成")
                        end
                    end,
                    opts = { buffer = true, noremap = true },
                },

                -- 生成標準 Markdown TOC
                ["<leader>mT"] = {
                    action = function()
                        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
                        local toc = { "<!-- TOC -->" }

                        for _, line in ipairs(lines) do
                            local level, title = line:match("^(#+)%s+(.+)")
                            if level and title then
                                local indent = string.rep("  ", #level - 1)
                                local anchor = title:lower():gsub("%s+", "-"):gsub("[^%w%-]", "")
                                table.insert(toc, string.format("%s- [%s](#%s)", indent, title, anchor))
                            end
                        end

                        table.insert(toc, "<!-- /TOC -->")
                        table.insert(toc, "")

                        -- 替換邏輯同上
                        local start_line, end_line = nil, nil
                        local current_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
                        for i, line in ipairs(current_lines) do
                            if line:match("<!-- TOC -->") then
                                start_line = i - 1
                            elseif line:match("<!-- /TOC -->") and start_line then
                                end_line = i
                                break
                            end
                        end

                        if start_line and end_line then
                            vim.api.nvim_buf_set_lines(0, start_line, end_line, false, toc)
                            print("Markdown TOC 已更新")
                        else
                            vim.api.nvim_buf_set_lines(0, 0, 0, false, toc)
                            print("Markdown TOC 已生成")
                        end
                    end,
                    opts = { buffer = true, noremap = true },
                },

                -- 移除 TOC
                ["<leader>mr"] = {
                    action = function()
                        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
                        local start_line, end_line = nil, nil

                        for i, line in ipairs(lines) do
                            if line:match("<!-- TOC -->") then
                                start_line = i - 1
                            elseif line:match("<!-- /TOC -->") and start_line then
                                end_line = i
                                break
                            end
                        end

                        if start_line and end_line then
                            vim.api.nvim_buf_set_lines(0, start_line, end_line, false, {})
                            print("TOC 已移除")
                        else
                            print("未找到 TOC")
                        end
                    end,
                    opts = { buffer = true, noremap = true },
                },

                -- 快速跳轉到 TOC
                ["<leader>mg"] = {
                    action = function()
                        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
                        for i, line in ipairs(lines) do
                            if line:match("<!-- TOC -->") then
                                vim.api.nvim_win_set_cursor(0, { i, 0 })
                                print("跳轉到 TOC")
                                return
                            end
                        end
                        print("未找到 TOC")
                    end,
                    opts = { buffer = true, noremap = true },
                },
            },

            -- Obsidian 應用設定
            use_advanced_uri = false, -- 是否使用 Advanced URI 插件
            open_app_foreground = false, -- 是否將 Obsidian 應用帶到前台

            -- 回調函數 (含自動 TOC 更新)
            callbacks = {
                post_setup = function(client)
                    print("Obsidian.nvim 已載入")
                end,
                enter_note = function(client, note) end,
                leave_note = function(client, note) end,

                -- **自動更新 TOC 功能**
                pre_write_note = function(client, note)
                    -- 保存前檢查是否需要更新 TOC
                    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
                    local has_toc = false

                    for _, line in ipairs(lines) do
                        if line:match("<!-- TOC -->") then
                            has_toc = true
                            break
                        end
                    end

                    -- 如果有 TOC 標記，自動重新生成 (可選功能，預設關閉)
                    -- 如果要啟用自動更新，請取消下面的註解
                    -- if has_toc then
                    --     vim.schedule(function()
                    --         -- 觸發 Wiki TOC 重新生成
                    --         local current_mappings = require("obsidian").get_client().opts.mappings
                    --         if current_mappings["<leader>mt"] then
                    --             current_mappings["<leader>mt"].action()
                    --         end
                    --     end)
                    -- end
                end,

                post_set_workspace = function(client, workspace)
                    print("切換到工作區: " .. workspace.name)
                end,
            },
        },
    },

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
    {
        "HakonHarnes/img-clip.nvim",
        opts = {
            default = {
                -- 儲存圖片到當前檔案目錄內的 assets 子資料夾
                dir_path = function()
                    local current_file = vim.api.nvim_buf_get_name(0)
                    local current_dir = vim.fn.fnamemodify(current_file, ":h")
                    return current_dir .. "/assets"
                end,

                extension = "png",

                -- 使用者可自訂檔名，否則自動以時間戳命名
                file_name = function()
                    local input = vim.fn.input("Image file name (no extension, leave blank for timestamp): ")
                    if input ~= "" then
                        return input
                    else
                        return os.date("%Y%m%d-%H%M%S")
                    end
                end,

                use_absolute_path = false,
                relative_to_current_file = true,
                -- 插入語法為 Markdown 格式
                template = "![$CURSOR]($RELATIVE_FILE_PATH)",
                url_encode_path = true,
                relative_template_path = true,
                use_cursor_in_template = true,
                insert_mode_after_paste = true,

                prompt_for_file_name = false, -- 自訂輸入邏輯已寫在 file_name 裡
                show_dir_path_in_prompt = false,

                -- base64 設定（不啟用）
                max_base64_size = 10,
                embed_image_as_base64 = false,

                -- 圖片處理
                process_cmd = "",
                copy_images = false,
                download_images = true,

                -- 拖曳貼圖
                drag_and_drop = {
                    enabled = true,
                    insert_mode = false,
                },
            },

            -- Markdown 專用插入格式
            filetypes = {
                markdown = {
                    template = "![$CURSOR]($FILE_PATH)",
                    url_encode_path = true,
                    download_images = false,
                },
            },
        },

        keys = {
            {
                "<leader>ip",
                function()
                    require("img-clip").paste_image()
                end,
                desc = "📎 貼上圖片並插入 Markdown 語法",
                mode = "n",
            },
        },
    },
}

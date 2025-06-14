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

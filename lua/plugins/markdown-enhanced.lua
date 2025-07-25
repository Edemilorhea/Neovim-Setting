-- plugins/markdown-enhanced.lua
-- 完整的 Markdown 生態系統插件

-- 安全檢查函數
local function check_obsidian_vault()
    local vault_path = vim.fn.expand("~/Documents/Obsidian_Note")
    if vim.fn.isdirectory(vault_path) == 1 and vim.fn.isdirectory(vault_path .. "/.obsidian") == 1 then
        return true, vault_path
    end
    return false, nil
end

local function check_deno()
    return vim.fn.executable("deno") == 1
end

local vault_exists, vault_path = check_obsidian_vault()
local deno_exists = check_deno()

return {
    -- Markdown 渲染增強 (只在 Neovim 中使用)
    {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
        ft = { "markdown" },
        cond = not vim.g.vscode,
        opts = {
            enabled = true,
            debounce = 150,
            max_file_size = 5.0,
            
            heading = {
                enabled = true,
                sign = true,
                position = "overlay",
                icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
                signs = { "󰫎 " },
                width = "full",
                backgrounds = {
                    "RenderMarkdownH1Bg", "RenderMarkdownH2Bg", "RenderMarkdownH3Bg",
                    "RenderMarkdownH4Bg", "RenderMarkdownH5Bg", "RenderMarkdownH6Bg",
                },
                foregrounds = {
                    "RenderMarkdownH1", "RenderMarkdownH2", "RenderMarkdownH3",
                    "RenderMarkdownH4", "RenderMarkdownH5", "RenderMarkdownH6",
                },
            },
            
            code = {
                enabled = true,
                sign = true,
                style = "full",
                position = "left",
                language_pad = 2,
                width = "full",
                pad = 3,
                border = "thick",
                above = "▀",
                below = "▄",
                highlight_border = "RenderMarkdownCodeBorder",
                highlight = "RenderMarkdownCode",
                highlight_inline = "RenderMarkdownCodeInlineBg",
            },
            
            bullet = {
                enabled = true,
                icons = { "◉", "○", "✸", "✿" },
                left_pad = 0,
                right_pad = 1,
                highlight = "RenderMarkdownBullet",
            },
            
            checkbox = {
                enabled = true,
                unchecked = { icon = "⬜", highlight = "RenderMarkdownUnchecked" },
                checked = { icon = "✅", highlight = "RenderMarkdownChecked" },
                custom = {
                    todo = { raw = "[-]", rendered = "⏳ ", highlight = "RenderMarkdownTodo" },
                    important = { raw = "[!]", rendered = "❗ ", highlight = "RenderMarkdownImportant" },
                    question = { raw = "[?]", rendered = "❓ ", highlight = "RenderMarkdownQuestion" },
                    progress = { raw = "[/]", rendered = "🔄 ", highlight = "RenderMarkdownProgress" },
                    cancelled = { raw = "[~]", rendered = "❌ ", highlight = "RenderMarkdownCancelled" },
                    star = { raw = "[*]", rendered = "⭐ ", highlight = "RenderMarkdownStar" },
                },
                right_pad = 1,
            },
            
            quote = {
                enabled = true,
                icon = "┃",
                repeat_linebreak = false,
                highlight = "RenderMarkdownQuote",
            },
            
            pipe_table = {
                enabled = true,
                preset = "round",
                style = "full",
                cell = "padded",
                border = { "╭", "┬", "╮", "├", "┼", "┤", "╰", "┴", "╯", "│", "─" },
                alignment_indicator = "━",
                head = "RenderMarkdownTableHead",
                row = "RenderMarkdownTableRow",
                filler = "RenderMarkdownTableFill",
            },
            
            link = {
                enabled = true,
                image = "🖼️ ",
                email = "📧 ",
                hyperlink = "🔗 ",
                highlight = "RenderMarkdownLink",
                custom = {
                    web = { pattern = "^http", icon = "🌐 ", highlight = "RenderMarkdownLink" },
                    github = { pattern = "github%.com", icon = "🐙 ", highlight = "RenderMarkdownLink" },
                    youtube = { pattern = "youtube%.com", icon = "📺 ", highlight = "RenderMarkdownLink" },
                    wiki = { pattern = "%[%[.*%]%]", icon = "📝 ", highlight = "RenderMarkdownWikiLink" },
                    obsidian = { pattern = "obsidian://", icon = "🔮 ", highlight = "RenderMarkdownLink" },
                    pdf = { pattern = "%.pdf$", icon = "📄 ", highlight = "RenderMarkdownLink" },
                    markdown = { pattern = "%.md$", icon = "📋 ", highlight = "RenderMarkdownLink" },
                },
            },
            
            callout = {
                note = { raw = "[!NOTE]", rendered = "󰋽 Note", highlight = "RenderMarkdownInfo" },
                tip = { raw = "[!TIP]", rendered = "󰌶 Tip", highlight = "RenderMarkdownSuccess" },
                important = { raw = "[!IMPORTANT]", rendered = "󰅾 Important", highlight = "RenderMarkdownHint" },
                warning = { raw = "[!WARNING]", rendered = "󰀪 Warning", highlight = "RenderMarkdownWarn" },
                caution = { raw = "[!CAUTION]", rendered = "󰳦 Caution", highlight = "RenderMarkdownError" },
            },
            
            win_options = {
                conceallevel = { default = vim.o.conceallevel, rendered = 3 },
                concealcursor = { default = vim.o.concealcursor, rendered = "" },
            },
        },
    },

    -- Obsidian 整合 (只在檢測到 vault 時啟用)
    {
        "epwalsh/obsidian.nvim",
        version = "*",
        enabled = vault_exists,
        cond = function() return vault_exists and not vim.g.vscode end,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "hrsh7th/nvim-cmp",
            "nvim-telescope/telescope.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        opts = function()
            if not vault_exists then return {} end
            
            return {
                workspaces = {
                    { name = "main", path = vault_path },
                },
                notes_subdir = "notes",
                new_notes_location = "notes_subdir",
                daily_notes = {
                    folder = "dailies",
                    date_format = "%Y-%m-%d",
                    alias_format = "%B %-d, %Y",
                    default_tags = { "daily-notes" },
                },
                completion = {
                    nvim_cmp = true,
                    min_chars = 2,
                },
                note_id_func = function(title)
                    local suffix = ""
                    if title ~= nil then
                        suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
                    else
                        for _ = 1, 4 do
                            suffix = suffix .. string.char(math.random(65, 90))
                        end
                    end
                    return tostring(os.time()) .. "-" .. suffix
                end,
                ui = { enable = false },
                mappings = {
                    ["gf"] = {
                        action = function() return require("obsidian").util.gf_passthrough() end,
                        opts = { buffer = true, expr = true, noremap = true },
                    },
                    ["<leader>ch"] = {
                        action = function() require("obsidian").util.toggle_checkbox() end,
                        opts = { buffer = true, noremap = true },
                    },
                    ["<CR>"] = {
                        action = function() return require("obsidian").util.smart_action() end,
                        opts = { buffer = true, expr = true, noremap = true },
                    },
                },
                callbacks = {
                    post_setup = function() print("Obsidian.nvim 已載入") end,
                    post_set_workspace = function(client, workspace)
                        print("切換到工作區: " .. workspace.name)
                    end,
                },
            }
        end,
    },

    -- Markdown 預覽插件
    {
        "iamcco/markdown-preview.nvim",
        ft = "markdown",
        cond = not vim.g.vscode,
        build = function() vim.fn["mkdp#util#install"]() end,
        config = function()
            vim.g.mkdp_auto_start = 0
            vim.g.mkdp_browser = "msedge"
            vim.g.mkdp_echo_preview_url = 1
        end,
        keys = {
            { "<leader>mp", "<cmd>MarkdownPreview<cr>", desc = "Markdown Preview" },
            { "<leader>ms", "<cmd>MarkdownPreviewStop<cr>", desc = "Stop Preview" },
        },
    },

    -- Glow 終端預覽
    {
        "ellisonleao/glow.nvim",
        cmd = "Glow",
        cond = not vim.g.vscode,
        config = function()
            require("glow").setup({
                border = "shadow",
                style = "dark",
                pager = false,
                width_ratio = 0.7,
                height_ratio = 0.7,
            })
        end,
        keys = {
            { "<leader>mg", "<cmd>Glow<cr>", desc = "Glow Preview" },
        },
    },

    -- Peek 瀏覽器預覽 (需要 deno)
    {
        "toppair/peek.nvim",
        enabled = deno_exists,
        cond = function() return deno_exists and not vim.g.vscode end,
        build = deno_exists and "deno task --quiet build:fast" or nil,
        ft = "markdown",
        config = function()
            require("peek").setup({
                auto_load = true,
                close_on_bdelete = true,
                syntax = true,
                theme = "dark",
                update_on_change = true,
                app = "webview",
                filetype = { "markdown" },
                throttle_at = 200000,
                throttle_time = "auto",
            })
        end,
        keys = {
            { "<leader>mp", "<cmd>PeekOpen<cr>", desc = "Peek Open" },
            { "<leader>mc", "<cmd>PeekClose<cr>", desc = "Peek Close" },
        },
    },

    -- 圖片貼上工具
    {
        "HakonHarnes/img-clip.nvim",
        ft = "markdown",
        cond = not vim.g.vscode,
        opts = {
            default = {
                dir_path = "assets",
                extension = "png",
                file_name = function()
                    local input = vim.fn.input("Image file name (no extension, leave blank for timestamp): ")
                    return input ~= "" and input or os.date("%Y%m%d-%H%M%S")
                end,
                use_absolute_path = false,
                relative_to_current_file = true,
                template = "![$CURSOR]($FILE_PATH)",
                url_encode_path = true,
                relative_template_path = true,
                use_cursor_in_template = true,
                insert_mode_after_paste = true,
                prompt_for_file_name = false,
                drag_and_drop = { enabled = true, insert_mode = false },
            },
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
                function() require("img-clip").paste_image() end,
                desc = "📎 貼上圖片並插入 Markdown 語法",
            },
        },
    },

    -- TOC 生成器
    {
        "mzlogin/vim-markdown-toc",
        ft = "markdown",
        cond = not vim.g.vscode,
        config = function()
            vim.g.vmt_auto_update_on_save = 0
            vim.g.vmt_fence_text = "TOC"
            vim.g.vmt_fence_closing_text = "/TOC"
        end,
        keys = {
            { "<leader>mt", ":GenTocGFM<CR>", desc = "Generate Markdown TOC" },
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
                    print("Wiki TOC 已生成")
                end,
                desc = "Generate Wiki TOC",
            },
        },
    },
}
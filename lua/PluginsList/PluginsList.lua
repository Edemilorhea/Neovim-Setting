-- 確保 packer.nvim 已安裝
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
        vim.cmd([[packadd packer.nvim]])
        return true
    end
    return false
end
local packer_bootstrap = ensure_packer()

-- 初始化插件管理器
return require("packer").startup(function(use)
    -- 插件管理器本身
    use { "wbthomason/packer.nvim" }

    -- Flash 插件（快速跳轉工具）
    use {
        "folke/flash.nvim",
        config = function()
            local flash = require("flash")
            vim.keymap.set({ "n", "x", "o" }, "<leader>hf", flash.jump, { silent = true, desc = "[H]op [F]lash" })
            vim.keymap.set({ "n", "x", "o" }, "<leader>hF", flash.treesitter, { silent = true, desc = "Flash Treesitter" })
            vim.keymap.set({ "o", "x" }, "<leader>hr", flash.treesitter_search, { silent = true, desc = "Treesitter Search" })
            vim.keymap.set("n", "<leader>he", flash.toggle, { silent = true, desc = "Toggle Flash Search" })
        end,
    }

    -- nvim-surround 插件（文字周圍添加/替換/刪除符號）
    use {
        "kylechui/nvim-surround",
        version = "*", -- 使用最新版本
        config = function()
            require("nvim-surround").setup({})
        end,
    }

    -- nvim-ufo 插件及依賴（代碼摺疊工具）
    use {
        'kevinhwang91/nvim-ufo', 
        requires = 'kevinhwang91/promise-async' -- nvim-ufo 的依賴
    }

    use {
        'neoclide/coc.nvim',
        branch = 'master',
        run = 'yarn install --frozen-lockfile' -- 確保安裝 coc.nvim 時使用 yarn
    }

    require('ufo').setup({
        provider_selector = function(bufnr, filetype, buftype)
            return {'treesitter', 'indent'} -- 使用 Treesitter 和縮排
        end
    })

    -- nvim-tree 插件（文件管理器）
    use {
        "nvim-tree/nvim-tree.lua",
        requires = "nvim-tree/nvim-web-devicons",
        config = function()
            require("nvim-tree").setup({
                renderer = {
                    icons = {
                        show = {
                            file = true,
                            folder = true,
                            folder_arrow = true,
                            git = true,
                        },
                    },
                },
                view = {
                    width = 30,
                    side = "left",
                },
            })
        end,
    }

    -- lualine 插件（狀態列）
    use {
        "nvim-lualine/lualine.nvim",
        requires = { "nvim-tree/nvim-web-devicons", opt = true },
        config = function()
            require("lualine").setup {
                options = {
                    theme = "dracula",
                    section_separators = { "", "" },
                    component_separators = { "", "" },
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch" },
                    lualine_c = { "filename" },
                    lualine_x = { "encoding", "fileformat", "filetype" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
            }
        end,
    }

    -- Telescope 插件（搜索工具）
    use {
        "nvim-telescope/telescope.nvim",
        requires = { "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").setup {
                defaults = {
                    prompt_prefix = "> ",
                    selection_caret = "> ",
                    path_display = { "smart" },
                },
            }
            vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { noremap = true, silent = true, desc = "Find Files" })
            vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { noremap = true, silent = true, desc = "Live Grep" })
            vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { noremap = true, silent = true, desc = "List Buffers" })
            vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { noremap = true, silent = true, desc = "Help Tags" })
        end,
    }


    -- markdown preview 插件
    use {
        "toppair/peek.nvim",
        run = "deno task --quiet build:fast",
        config = function()
            require("peek").setup({
                auto_load = true,
                syntax = true,
                theme = "dark",
                update_on_change = true,
                filetype = { "markdown" },
                app = "browser",
            })
            vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
            vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
        end,
    }

    use {
        'keaising/im-select.nvim',
        config = function()
            require('im_select').setup({
                -- 普通模式時使用 1033 (美式英文)
                default_im_select = "1033",
                -- 插入模式時切換為 1028 (繁體中文)
                defalut_input_method = "1028",
            })
        end,
    }

    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }

    require('nvim-treesitter.configs').setup({
        -- 確保安裝的語言解析器
        ensure_installed = {
            'html',        -- HTML
            'css',         -- CSS
            'scss',        -- SCSS
            'javascript',  -- JavaScript
            'typescript',  -- TypeScript
            'markdown',    -- Markdown
            'vue',         -- Vue.js
            'c_sharp',     -- C#
            'python'       -- Python
        },
    
        -- 啟用高亮
        highlight = {
            enable = true,            -- 啟用語法高亮
            additional_vim_regex_highlighting = false, -- 禁用 Vim 的正則高亮（更快）
        },
    
        -- 啟用縮排
        indent = {
            enable = true,            -- 啟用縮排
        },
    
        -- 啟用增強選擇
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "gnn",  -- 開始選擇區域
                node_incremental = "grn", -- 擴展到下一節點
                scope_incremental = "grc", -- 擴展到當前範圍
                node_decremental = "grm", -- 縮小選擇
            },
        },
    
        -- 啟用摺疊
        fold = {
            enable = true,
        },
    })

    -- 如果是首次安裝 packer.nvim，則同步插件
    if packer_bootstrap then
        require("packer").sync()
    end
end)

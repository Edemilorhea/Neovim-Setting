-- PluginsList.lua
local is_vscode = vim.g.vscode == 1

print(is_vscode)
-- 確保 packer.nvim 已安裝
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
        vim.cmd([[packadd packer.nvim]])
        return true
    end
    return false
end
local packer_bootstrap = ensure_packer()

-- 初始化插件管理器 
return require("packer").startup(function(use)
    -- 插件管理器本身 
    use {"wbthomason/packer.nvim"}

    -- Mason 相關插件（僅下載/安裝）

    use {
        "williamboman/mason.nvim",
        requires = {"williamboman/mason-lspconfig.nvim", "neovim/nvim-lspconfig"},
        config = function()
            -- 預設不初始化，等手動啟動
        end
    }
    --
    -- 其他插件（**完整保留你的順序**）
    use {
        "folke/flash.nvim",
        config = function()
            local flash = require("flash")
            vim.keymap.set({"n", "x", "o"}, "<leader>hf", flash.jump, {
                silent = true,
                desc = "[H]op [F]lash"
            })
            vim.keymap.set({"n", "x", "o"}, "<leader>hF", flash.treesitter, {
                silent = true,
                desc = "Flash Treesitter"
            })
            vim.keymap.set({"o", "x"}, "<leader>hr", flash.treesitter_search, {
                silent = true,
                desc = "Treesitter Search"
            })
            vim.keymap.set("n", "<leader>he", flash.toggle, {
                silent = true,
                desc = "Toggle Flash Search"
            })
        end
    }

    use {
        "kylechui/nvim-surround",
        version = "*",
        config = function()
            require("nvim-surround").setup({})
        end
    }

    use {
        "kevinhwang91/nvim-ufo",
        requires = "kevinhwang91/promise-async",
        config = function()
            require('ufo').setup({
                provider_selector = function(bufnr, filetype, buftype)
                    return {'treesitter', 'indent'}
                end
            })
        end
    }

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
                            git = true
                        }
                    }
                },
                view = {
                    width = 30,
                    side = "left"
                }
            })
        end
    }

    use {
        "toppair/peek.nvim",
        run = "deno task --quiet build:fast",
        config = function()
            require("peek").setup({
                auto_load = true,
                syntax = true,
                theme = "dark",
                update_on_change = true,
                filetype = {"markdown"},
                app = "browser"
            })
            vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
            vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
        end
    }

    use {
        'keaising/im-select.nvim',
        config = function()
            require('im_select').setup({
                -- 普通模式時使用 1033 (美式英文)
                default_im_select = "1033",
                -- 插入模式時切換為 1028 (繁體中文)
                defalut_input_method = "1028"
            })
        end
    }

    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }

    require('nvim-treesitter.configs').setup({
        -- 確保安裝的語言解析器
        ensure_installed = {'html', -- HTML
        'css', -- CSS
        'scss', -- SCSS
        'javascript', -- JavaScript
        'typescript', -- TypeScript
        'markdown', -- Markdown
        'vue', -- Vue.js
        'c_sharp', -- C#
        'python' -- Python
        },

        -- 啟用高亮
        highlight = {
            enable = true, -- 啟用語法高亮
            additional_vim_regex_highlighting = false -- 禁用 Vim 的正則高亮（更快）
        },

        -- 啟用縮排
        indent = {
            enable = true -- 啟用縮排
        },

        -- 啟用增強選擇
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "gnn", -- 開始選擇區域
                node_incremental = "grn", -- 擴展到下一節點
                scope_incremental = "grc", -- 擴展到當前範圍
                node_decremental = "grm" -- 縮小選擇
            }
        },

        -- 啟用摺疊
        fold = {
            enable = true
        }
    })

    use {
        "nvim-lualine/lualine.nvim",
        requires = {
            "nvim-tree/nvim-web-devicons",
            opt = true
        },
        config = function()
            require("lualine").setup {
                options = {
                    theme = "dracula",
                    section_separators = {"", ""},
                    component_separators = {"", ""}
                },
                sections = {
                    lualine_a = {"mode"},
                    lualine_b = {"branch"},
                    lualine_c = {"filename"},
                    lualine_x = {"encoding", "fileformat", "filetype"},
                    lualine_y = {"progress"},
                    lualine_z = {"location"}
                }
            }
        end
    }

    use {
        "nvim-telescope/telescope.nvim",
        requires = {"nvim-lua/plenary.nvim"},
        config = function()
            require("telescope").setup {
                defaults = {
                    prompt_prefix = "> ",
                    selection_caret = "> ",
                    path_display = {"smart"}
                }
            }
            vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", {
                noremap = true,
                silent = true,
                desc = "Find Files"
            })
            vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", {
                noremap = true,
                silent = true,
                desc = "Live Grep"
            })
            vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", {
                noremap = true,
                silent = true,
                desc = "List Buffers"
            })
            vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", {
                noremap = true,
                silent = true,
                desc = "Help Tags"
            })
        end
    }

    -- **完整保留你的所有插件順序**

    -- 如果是首次安裝 packer.nvim，則同步插件 
    if packer_bootstrap then
        require("packer").sync()
    end
end)


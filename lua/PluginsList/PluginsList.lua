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

-- 配置插件
return require("packer").startup(function(use)
    -- 插件管理器
    use { "wbthomason/packer.nvim" }

    -- Flash 插件（快速跳轉工具）
    use {
        "folke/flash.nvim",
        config = function()
            local flash = require("flash")
            vim.keymap.set({ "n", "x", "o" }, "<leader>hf", flash.jump, { silent = true })
            vim.keymap.set({ "n", "x", "o" }, "<leader>hF", flash.treesitter, { desc = "[H]op [F]lash", silent = true })
            vim.keymap.set({ "o", "x" }, "<leader>hr", flash.treesitter_search, { desc = "Flash Treesitter Search", silent = true })
            vim.keymap.set({ "n" }, "<leader>he", flash.toggle, { desc = "[H]op Toggle Flash Search", silent = true })
        end
    }

    -- nvim-surround 插件（文字周圍添加/替換/刪除符號）
    use {
        "kylechui/nvim-surround",
        version = "*", -- 使用最新版本
        config = function()
            require("nvim-surround").setup({})
        end
    }

    -- nvim-ufo 插件及依賴（代碼摺疊工具）
    use {
        "kevinhwang91/nvim-ufo",
        requires = "kevinhwang91/promise-async",
        config = function()
            require("ufo").setup({})
        end
    }

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
        end
    }

    -- lualine 插件（狀態列）
    use {
        "nvim-lualine/lualine.nvim",
        requires = { "nvim-tree/nvim-web-devicons", opt = true },
        config = function()
            require("lualine").setup {
                options = {
                    theme = "dracula", -- 主題樣式
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
        end
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
            -- 快捷鍵設置
            vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { noremap = true, silent = true })
        end
    }

    -- 如果是首次安裝 packer.nvim，則同步插件
    if packer_bootstrap then
        require("packer").sync()
    end
end)



local packer_exists = pcall(vim.cmd, [[packadd packer.nvim]])

return require("packer").startup(function()
    -- 插件管理器
    use { "wbthomason/packer.nvim", opt = true }

    -- Flash 插件
    use { "folke/flash.nvim",
        keys = { "<leader>hf", "f", "R", "v" },
        config = function()
            local flash = require("flash")
            local keymap = vim.keymap

            keymap.set({ "n", "x", "o" }, "<leader>hf", function()
                flash.jump()
            end, { silent = true })

            keymap.set({ "n", "x", "o" }, "<leader>hF", function()
                flash.treesitter()
            end, { desc = "[H]op [F]lash", silent = true })

            keymap.set({ "o", "x", "v" }, "<leader>hr", function()
                flash.treesitter_search()
            end, { desc = "Flash Treesitter Search", silent = true })

            keymap.set({ "n" }, "<leader>he", function()
                flash.toggle()
            end, { desc = "[H]op Toggle Flash Search", silent = true })
        end
    }

    -- nvim-surround 插件
   use {
	  "kylechui/nvim-surround",
	  version = "*", -- 使用最新版本
	  config = function()
		require("nvim-surround").setup({})
	  end
	} 

    -- nvim-ufo 插件及依賴 code摺疊
    use { "kevinhwang91/nvim-ufo",
        requires = "kevinhwang91/promise-async",
        config = function()
            require("ufo").setup({})
        end
    }

    --nvimtree 插件 文件管理器
    use {
    'nvim-tree/nvim-tree.lua',
    requires = {
    'nvim-tree/nvim-web-devicons', -- 可選: 提供文件類型圖標
    },
    config = function()
    require("nvim-tree").setup({
        -- 移除過時的選項，使用新的配置方式
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
    
    --下方狀態列
    use {
      'nvim-lualine/lualine.nvim',
      requires = { 'nvim-tree/nvim-web-devicons', opt = true }  -- 可選的圖示支持
    }
    -- 配置 lualine 下方狀態列
    require('lualine').setup {
      options = {
        theme = 'dracula',   -- 您可以選擇任何主題，例如 'gruvbox' 或 'dracula'
        section_separators = {'', ''},
        component_separators = {'', ''},
      },
      sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch'},
        lualine_c = {'filename'},
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
      },
    }

    --搜尋工具
    use {
      'nvim-telescope/telescope.nvim',
      requires = { {'nvim-lua/plenary.nvim'} }
    }

    -- 基本配置
    require('telescope').setup{
      defaults = {
        prompt_prefix = "> ",
        selection_caret = "> ",
        path_display = {"smart"},
      }
    }

    -- 常用快捷鍵設置
    vim.api.nvim_set_keymap('n', '<leader>ff', "<cmd>Telescope find_files<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<leader>fg', "<cmd>Telescope live_grep<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<leader>fb', "<cmd>Telescope buffers<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap('n', '<leader>fh', "<cmd>Telescope help_tags<CR>", { noremap = true, silent = true })

    end
)

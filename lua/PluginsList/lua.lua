local packer_exists = pcall(vim.cmd, [[packadd packer.nvim]])
return require("packer").startup(
    function()
	use {"wbthomason/packer.nvim", opt = true}
	use {'nvim-treesitter/nvim-treesitter', run = ":TSUpdate"}
	use {"folke/flash.nvim",
		keys ={"<leader>hf","f", "R", "v"},
		config = function()
			local flash = require("flash")
			local keymap = vim.keymap
			keymap.set({ "n", "x", "o" }, "<leader>hf", function()
				flash.jump()
			end,{silent = true})

			keymap.set({ "n", "x", "o" }, "<leader>hF", function()
				flash.treesitter()
			end, { desc = "[H]op [F]lash", silent = true })

			keymap.set({ "o", "x", "v" }, "<leader>hr", function()
				flash.treesitter_search()
			end, { desc = "Flash Treesitter Search", silent = true })

			keymap.set({ "c" }, "<leader>hc", function()
				flash.toggle()
			end, { desc = "[H]op Toggle Flash Search", silent = true })
		end
	}
	use {'kylechui/nvim-surround',tag="*"}
	use {'kevinhwang91/nvim-ufo', requires = 'kevinhwang91/promise-async'}
	--use {"nvim-tressitter/nvim-treesitter-textobjects", after="nvim/treesitter",requires = "nvim-treesitter/nvim-treesitter"}
    end
)

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
		requires = { "williamboman/mason-lspconfig.nvim", "neovim/nvim-lspconfig" },
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

	if packer_bootstrap then
		require("packer").sync()
	end
end)

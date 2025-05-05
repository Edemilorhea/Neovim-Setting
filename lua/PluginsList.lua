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

	use({
		"ellisonleao/glow.nvim",
		cmd = "Glow",
		config = function()
			require("glow").setup({
				style = "dark", -- 可設 "light" or "dark"
				width = 120,
				pager = false,
			})
		end,
	})

	--	use({
	--		"preservim/vim-markdown",
	--		ft = { "markdown" },
	--		config = function()
	--			-- 這裡可以設定一些 options
	--			vim.g.vim_markdown_folding_disabled = 1
	--			vim.g.vim_markdown_conceal = 2
	--			vim.g.vim_markdown_conceal_code_blocks = 0
	--			vim.g.vim_markdown_new_list_item_indent = 2
	--			vim.g.vim_markdown_auto_insert_bullets = 1
	--		end,
	--	})

	-- 在你的 lazy.nvim 設定檔中 (例如 lua/plugins/autolist.lua 或類似檔案)
	use({
		"gaoDean/autolist.nvim",
		-- ft 指定哪些檔案類型要啟用 autolist
		ft = {
			"markdown",
			"text",
			"tex",
			"plaintex",
			"norg",
			-- 你可以根據需要添加或移除檔案類型
		},
		config = function()
			-- 基本的 setup 仍然需要呼叫，以啟用核心功能
			require("autolist").setup({
				-- 在這裡可以放置你的自訂設定，例如 cycle 的順序等
				-- 如果不需要自訂，保留空的 setup() 或省略參數即可
				-- 例如:
				-- cycle = { "-", "*", "1.", "a)", "I." },
			})

			print("Autolist setup complete. Mappings (excluding CR/o/O) applied.") -- 除錯訊息

			-- === 設定你需要的按鍵映射 ===

			-- 縮排 (Indent): 使用 Tab 鍵縮排，並觸發 autolist 的上下文處理和重新計算
			vim.keymap.set("i", "<Tab>", "<Cmd>AutolistTab<CR>", { desc = "Autolist Indent" })

			-- 反縮排 (Dedent): 使用 Shift+Tab 鍵反縮排，並觸發 autolist 的上下文處理和重新計算
			vim.keymap.set("i", "<S-Tab>", "<Cmd>AutolistShiftTab<CR>", { desc = "Autolist Dedent" })

			-- 手動重新計算清單: 在 Normal 模式下按 Ctrl+r 觸發
			vim.keymap.set("n", "<C-r>", "<Cmd>AutolistRecalculate<CR>", { desc = "Autolist Recalculate" })

			-- 切換核取方塊狀態: 在 Normal 模式下按 Enter 鍵 (注意：這是 Normal 模式的 Enter)
			vim.keymap.set("n", "<CR>", "<Cmd>AutolistToggleCheckbox<CR><CR>", { desc = "Autolist Toggle Checkbox" })

			-- 循環切換清單類型 (支援 dot-repeat)
			-- 將 <leader>cn 映射到下一個清單類型
			vim.keymap.set(
				"n",
				"<leader>cn",
				require("autolist").cycle_next_dr,
				{ expr = true, desc = "Autolist Cycle Next" }
			)
			-- 將 <leader>cp 映射到上一個清單類型
			vim.keymap.set(
				"n",
				"<leader>cp",
				require("autolist").cycle_prev_dr,
				{ expr = true, desc = "Autolist Cycle Prev" }
			)

			-- (可選) 在常用編輯操作後自動重新計算 (讓 dd, >>, << 等操作後自動更新序號)
			vim.keymap.set("n", ">>", ">><Cmd>AutolistRecalculate<CR>", { desc = "Indent + Autolist Recalc" })
			vim.keymap.set("n", "<<", "<<<Cmd>AutolistRecalculate<CR>", { desc = "Dedent + Autolist Recalc" })
			vim.keymap.set("n", "dd", "dd<Cmd>AutolistRecalculate<CR>", { desc = "Delete Line + Autolist Recalc" })
			vim.keymap.set("v", "d", "d<Cmd>AutolistRecalculate<CR>", { desc = "Delete Visual + Autolist Recalc" })
			vim.keymap.set("v", "p", "p<Cmd>AutolistRecalculate<CR>", { desc = "Paste Visual + Autolist Recalc" }) -- 貼上後可能也需要

			-- === 以下是我們 *刻意省略* 的按鍵映射 ===
			vim.keymap.set("i", "<CR>", "<CR><cmd>AutolistNewBullet<cr>") -- 不設定這個
			vim.keymap.set("n", "o", "o<cmd>AutolistNewBullet<cr><Esc>") -- 不設定這個
			vim.keymap.set("n", "O", "O<cmd>AutolistNewBulletBefore<cr><Esc>") -- 不設定這個
		end,
	})

	use( -- lazy.nvim 的寫法
		{
			"numToStr/Comment.nvim",
			config = function()
				require("Comment").setup()
				-- 你可以在這裡加自訂快捷鍵
				vim.keymap.set("n", "<C-_>", function()
					require("Comment.api").toggle.linewise.current()
				end, { noremap = true, silent = true })
				vim.keymap.set(
					"v",
					"<C-_>",
					"<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
					{ noremap = true, silent = true }
				)
			end,
		}
	)

	if packer_bootstrap then
		require("packer").sync()
	end
end)

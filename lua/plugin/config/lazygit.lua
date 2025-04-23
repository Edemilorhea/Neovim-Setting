-- ~/.config/nvim/lua/plugin/lazygit.lua
local M = {}

function M.setup()
	-- optional: 設定 lazygit 額外視窗樣式
	vim.g.lazygit_floating_window_winblend = 0
	vim.g.lazygit_floating_window_scaling_factor = 0.9
	vim.g.lazygit_use_neovim_remote = 1

	-- optional: 快捷鍵綁定
	vim.keymap.set("n", "<leader>lg", "<cmd>LazyGit<CR>", {
		desc = "開啟 LazyGit",
		noremap = true,
		silent = true,
	})
end

return M

local M = {}

function M.setup()
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "markdown",
		callback = function()
			local buf = vim.api.nvim_get_current_buf()

			-- ✅ 正確設定 keymap，包含 desc，讓 which-key 自動讀取
			vim.keymap.set("n", "<leader>ch", function()
				return require("obsidian").util.toggle_checkbox()
			end, { buffer = buf, desc = "切換 checkbox" })

			vim.keymap.set("n", "gf", function()
				return require("obsidian").util.gf_passthrough()
			end, { buffer = buf, expr = true, desc = "跳轉 wiki link" })

			vim.keymap.set("n", "<CR>", function()
				return require("obsidian").util.smart_action()
			end, { buffer = buf, expr = true, desc = "智慧操作 (link/checkbox)" })

			-- ❌ 不用 wk.register：讓 which-key 自動從 keymap 中讀 desc！
		end,
	})
end

return M

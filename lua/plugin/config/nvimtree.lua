-- ~/.config/nvim/lua/plugin/config/nvimtree.lua

local M = {}

function M.setup()
	local api = require("nvim-tree.api")

	require("nvim-tree").setup({
		sort = {
			sorter = "case_sensitive",
		},
		view = {
			width = 30,
			side = "left",
			preserve_window_proportions = true,
			number = false,
			relativenumber = false,
		},
		renderer = {
			group_empty = true,
			icons = {
				show = {
					file = true,
					folder = true,
					folder_arrow = true,
					git = true,
				},
			},
		},
		update_focused_file = {
			enable = true,
			update_root = true,
		},
		filters = {
			dotfiles = false,
		},
		git = {
			enable = true,
			ignore = false,
		},
		actions = {
			open_file = {
				resize_window = true,
			},
		},
		on_attach = function(bufnr)
			local function opts(desc)
				return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
			end

			api.config.mappings.default_on_attach(bufnr)

			-- 自定快捷鍵
			vim.keymap.set("n", "<C-t>", api.tree.change_root_to_parent, opts("返回上層資料夾"))
			vim.keymap.set("n", "L", api.tree.change_root_to_node, opts("切換 root 到此資料夾"))
			vim.keymap.set("n", "?", api.tree.toggle_help, opts("顯示說明"))
		end,
	})
end

return M

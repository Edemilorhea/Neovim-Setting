-- ~/.config/nvim/lua/plugin/config/obsidian.lua

local M = {}

function M.setup()
	local home = vim.fn.expand("~")

	require("obsidian").setup({
		workspaces = {
			{
				name = "personal",
				path = home .. "\\Documents\\Obsidian Vault",
			},
		},

		notes_subdir = "notes",

		daily_notes = {
			folder = "notes/dailies",
			date_format = "%Y-%m-%d",
			alias_format = "%B %-d, %Y",
			default_tags = { "daily-notes" },
			template = nil,
		},

		completion = {
			nvim_cmp = true,
			min_chars = 2,
		},

		mappings = {
			["gf"] = {
				action = function()
					return require("obsidian").util.gf_passthrough()
				end,
				opts = { noremap = false, expr = true, buffer = true },
			},
			["<leader>ch"] = {
				action = function()
					return require("obsidian").util.toggle_checkbox()
				end,
				opts = { buffer = true },
			},
			["<CR>"] = {
				action = function()
					return require("obsidian").util.smart_action()
				end,
				opts = { buffer = true, expr = true },
			},
		},

		new_notes_location = "notes_subdir",

		note_id_func = function(title)
			local suffix = ""
			if title ~= nil then
				suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
			else
				for _ = 1, 4 do
					suffix = suffix .. string.char(math.random(65, 90))
				end
			end
			return tostring(os.time()) .. "-" .. suffix
		end,

		wiki_link_func = function(opts)
			return require("obsidian.util").wiki_link_id_prefix(opts)
		end,

		preferred_link_style = "wiki",

		templates = {
			folder = "templates",
			date_format = "%Y-%m-%d",
			time_format = "%H:%M",
			substitutions = {
				date = os.date("%Y-%m-%d"),
				time = os.date("%H:%M"),
				user = os.getenv("USERNAME") or "TC",
			},
		},

		ui = {
			enable = true,
			checkboxes = {
				[" "] = { char = "󰄱", hl_group = "ObsidianTodo" },
				["x"] = { char = "", hl_group = "ObsidianDone" },
				[">"] = { char = "", hl_group = "ObsidianRightArrow" },
				["~"] = { char = "󰰱", hl_group = "ObsidianTilde" },
				["!"] = { char = "", hl_group = "ObsidianImportant" },
			},
			bullets = { char = "•", hl_group = "ObsidianBullet" },
		},

		attachments = {
			img_folder = "assets/imgs",
			img_name_func = function()
				return string.format("%s-", os.time())
			end,
		},
	})
end

return M

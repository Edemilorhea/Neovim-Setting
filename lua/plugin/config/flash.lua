local M = {}

function M.setup()
	local flash = require("flash")

	flash.setup({
		modes = {
			search = {
				enabled = true,
				autojump = false,
				autohide = false,
				highlight = {
					backdrop = true,
					matches = true,
				},
				jump = {
					history = true,
				},
			},
			char = {
				enabled = true,
				autojump = true, -- 保持 f/t 即時跳
				autohide = false, -- ✅ 必須加這行，才能防止提前跳走
				jump = {
					history = true,
				},
			},
		},
	})
end

return M

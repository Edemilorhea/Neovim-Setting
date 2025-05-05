-- 檔案路徑範例: lua/core/keymaps.lua

local M = {}

-- 這個 setup 函數將包含設定 Comment.nvim 快捷鍵的邏輯
function M.setup()
	print("Setting up Comment.nvim keymaps...") -- 加入一個訊息方便除錯

	-- 載入 Comment.nvim 的 API 模組
	local comment_api = require("Comment.api")

	-- --- 設定 Comment.nvim 的 Ctrl+/ 和 Ctrl+_ 快捷鍵 ---

	-- 將 Ctrl+/ 映射到切換目前行註解 (Normal 模式)
	vim.keymap.set("n", "<C-/>", function()
		comment_api.toggle.linewise.current() -- 修正：使用 .toggle.linewise.current()
	end, { noremap = true, silent = true, desc = "Comment toggle current line" }) -- 建議加上 noremap 和 silent

	-- 將 Ctrl+/ 映射到切換選取範圍的行註解 (Visual 模式)
	vim.keymap.set("v", "<C-/>", function()
		comment_api.toggle.linewise(vim.fn.visualmode()) -- 修正：使用 .toggle.linewise()
	end, { noremap = true, silent = true, desc = "Comment toggle visual lines" }) -- 建議加上 noremap 和 silent

	-- 同樣為 Ctrl+_ (某些終端機的備用) 進行映射
	vim.keymap.set("n", "<C-_>", function()
		comment_api.toggle.linewise.current() -- 修正：使用 .toggle.linewise.current()
	end, { noremap = true, silent = true, desc = "Comment toggle current line (C-_)" }) -- 建議加上 noremap 和 silent

	vim.keymap.set("v", "<C-_>", function()
		comment_api.toggle.linewise(vim.fn.visualmode()) -- 修正：使用 .toggle.linewise()
	end, { noremap = true, silent = true, desc = "Comment toggle visual lines (C-_)" }) -- 建議加上 noremap 和 silent

	-- 注意：你原本範例中的 bufferline 設定與 Comment.nvim 無關，
	-- 所以我沒有把它包含在這個 keymaps 模組的 setup 函數中。
	-- 如果你的目的是建立一個通用的按鍵映射設定函數，你可以在這裡加入其他的 vim.keymap.set(...)
end

return M

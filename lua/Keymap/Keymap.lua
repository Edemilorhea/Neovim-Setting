-- 定義全局選項
local opts = { noremap = true, silent = true }

-- 簡化的鍵映射
vim.keymap.set("n", "o", "o<Esc>", opts)
vim.keymap.set("n", "O", "O<Esc>", opts)
vim.keymap.set({ "n", "v" }, "d", [["_d]], opts)
vim.keymap.set("n", "D", [["_D]], opts)
vim.keymap.set("n", "dd", [["_dd]], opts)
vim.keymap.set("i", "<S-Tab>", "<C-d>", opts)
vim.keymap.set("v", "p", [["_dP]], opts)
vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", opts)
-- 基本按鍵修改

-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<Esc>", "<Esc>:nohlsearch<CR>", { silent = true })

require("keymap.general").setup()

require("keymap.hotKeyMaps").setup()

-- 移除原始的終端映射
vim.keymap.del("n", "<C-/>")
vim.keymap.del("n", "<C-_>") -- 也移除 Ctrl+_ 映射

-- 添加註釋功能映射
if vim.g.vscode then
  require("keymap.vscode").setup()

  -- VSCode 環境下不需要配置
else
  -- 使用 mini.comment
  vim.keymap.set("n", "<C-/>", function()
    require("mini.comment").toggle_lines(vim.fn.line("."), vim.fn.line("."))
  end, { desc = "Comment toggle current line" })

  vim.keymap.set("v", "<C-/>", function()
    local start_line = vim.fn.line("'<")
    local end_line = vim.fn.line("'>")
    require("mini.comment").toggle_lines(start_line, end_line)
  end, { desc = "Comment toggle visual selection" })

  -- 同樣設置 Ctrl+_ 以確保兼容性
  vim.keymap.set("n", "<C-_>", function()
    require("mini.comment").toggle_lines(vim.fn.line("."), vim.fn.line("."))
  end, { desc = "Comment toggle current line" })

  vim.keymap.set("v", "<C-_>", function()
    local start_line = vim.fn.line("'<")
    local end_line = vim.fn.line("'>")
    require("mini.comment").toggle_lines(start_line, end_line)
  end, { desc = "Comment toggle visual selection" })
end

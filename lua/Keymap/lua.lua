-- 基本按鍵修改
vim.api.nvim_set_keymap("n", "o", "o<Esc>", {noremap = true})
vim.api.nvim_set_keymap("n", "O", "O<Esc>", {noremap = true})
vim.api.nvim_set_keymap("v", "d", "\"_d", {noremap = true})
vim.api.nvim_set_keymap("n", "d", "\"_d", {noremap = true})
vim.api.nvim_set_keymap("n", "D", "\"_D", {noremap = true})
vim.api.nvim_set_keymap("n", "dd", "\"_dd", {noremap = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "<C-d>", {noremap = true})
vim.api.nvim_set_keymap('v', 'p', '"_dP', { noremap = true })

vim.api.nvim_set_keymap("n", "<Leader>qq", ":vsc Edit.FindinFiles<CR>", {noremap = true})
-- like vscode command
vim.api.nvim_set_keymap("n", "<Leader>xm", ":vsc View.Terminal<CR>", {noremap = true})
-- 擴展選取
vim.api.nvim_set_keymap("n", "<Leader>xx", ":vsc Edit.ExpandSelection<CR>", {noremap = true})

-- 針對vscode 摺疊功能

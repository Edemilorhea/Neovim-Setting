vim.keymap.set('i', '<C-[>', '<Esc>', { noremap = true })
vim.keymap.set('n', 'za', "<Cmd>lua vim.fn.VSCodeNotify('editor.toggleFold')<CR>", {silent = true})
vim.keymap.set('n', 'zR', "<Cmd>lua vim.fn.VSCodeNotify('editor.unfoldAll')<CR>", {silent = true})
vim.keymap.set('n', 'zM', "<Cmd>lua vim.fn.VSCodeNotify('editor.foldAll')<CR>", {silent = true})
vim.keymap.set('n', 'zo', "<Cmd>lua vim.fn.VSCodeNotify('editor.unfold')<CR>", {silent = true})
vim.keymap.set('n', 'zO', "<Cmd>lua vim.fn.VSCodeNotify('editor.unfoldRecursively')<CR>", {silent = true})
vim.keymap.set('n', 'zc', "<Cmd>lua vim.fn.VSCodeNotify('editor.fold')<CR>", {silent = true})
vim.keymap.set('n', 'zC', "<Cmd>lua vim.fn.VSCodeNotify('editor.foldRecursively')<CR>", {silent = true})
vim.keymap.set('n', 'z1', "<Cmd>lua vim.fn.VSCodeNotify('editor.foldLevel1')<CR>", {silent = true})
vim.keymap.set('n', 'z2', "<Cmd>lua vim.fn.VSCodeNotify('editor.foldLevel2')<CR>", {silent = true})
vim.keymap.set('n', 'z3', "<Cmd>lua vim.fn.VSCodeNotify('editor.foldLevel3')<CR>", {silent = true})
vim.keymap.set('n', 'z4', "<Cmd>lua vim.fn.VSCodeNotify('editor.foldLevel4')<CR>", {silent = true})
vim.keymap.set('n', 'z5', "<Cmd>lua vim.fn.VSCodeNotify('editor.foldLevel5')<CR>", {silent = true})
vim.keymap.set('n', 'z6', "<Cmd>lua vim.fn.VSCodeNotify('editor.foldLevel6')<CR>", {silent = true})
vim.keymap.set('n', 'z7', "<Cmd>lua vim.fn.VSCodeNotify('editor.foldLevel7')<CR>", {silent = true})
vim.keymap.set('x', 'zV', "<Cmd>lua vim.fn.VSCodeNotify('editor.foldAllExcept')<CR>", {silent = true})
vim.keymap.set('n', 'zj', "<Cmd>lua vim.fn.VSCodeNotify('editor.gotoNextFold')<CR>", {silent = true})
vim.keymap.set('n', 'zk', "<Cmd>lua vim.fn.VSCodeNotify('editor.gotoPreviousFold')<CR>", {silent = true})	

-- Normal mode mappings
vim.keymap.set('n', 'j', 'gj', { silent = true })
vim.keymap.set('n', 'k', 'gk', { silent = true })

-- Visual mode mappings
vim.keymap.set('v', 'j', 'gj', { silent = true })
vim.keymap.set('v', 'k', 'gk', { silent = true })

-- Normal mode mappings for <Down> and <Up>
vim.keymap.set('n', '<Down>', 'gj', { silent = true })
vim.keymap.set('n', '<Up>', 'gk', { silent = true })

-- Visual mode mappings for <Down> and <Up>
vim.keymap.set('v', '<Down>', 'gj', { silent = true })
vim.keymap.set('v', '<Up>', 'gk', { silent = true })

vim.keymap.set("n", "<Leader>qq", ":vsc Edit.FindinFiles<CR>", {noremap = true})
-- like vscode command
vim.keymap.set("n", "<Leader>xm", ":vsc View.Terminal<CR>", {noremap = true})
-- 擴展選取
vim.keymap.set("n", "<Leader>xx", ":vsc Edit.ExpandSelection<CR>", {noremap = true})

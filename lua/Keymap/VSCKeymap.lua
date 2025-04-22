-- 基本按鍵修改
vim.keymap.set('i', '<C-[>', '<Esc>', {
    noremap = true
})
vim.keymap.set('n', 'zM', '<Cmd>call VSCodeNotify("editor.foldAll")<CR>', {
    noremap = true,
    silent = true
})
vim.keymap.set('n', 'zR', '<Cmd>call VSCodeNotify("editor.unfoldAll")<CR>', {
    noremap = true,
    silent = true
})
vim.keymap.set('n', 'zc', '<Cmd>call VSCodeNotify("editor.fold")<CR>', {
    noremap = true,
    silent = true
})
vim.keymap.set('n', 'zC', '<Cmd>call VSCodeNotify("editor.foldRecursively")<CR>', {
    noremap = true,
    silent = true
})
vim.keymap.set('n', 'zo', '<Cmd>call VSCodeNotify("editor.unfold")<CR>', {
    noremap = true,
    silent = true
})
vim.keymap.set('n', 'zO', '<Cmd>call VSCodeNotify("editor.unfoldRecursively")<CR>', {
    noremap = true,
    silent = true
})
vim.keymap.set('n', 'za', '<Cmd>call VSCodeNotify("editor.toggleFold")<CR>', {
    noremap = true,
    silent = true
})
-- vim.keymap.set('n', 'za', "<Cmd>lua vim.fn.VSCodeNotify('editor.toggleFold')<CR>", {silent = true})
-- vim.keymap.set('n', 'zR', "<Cmd>lua vim.fn.VSCodeNotify('editor.unfoldAll')<CR>", {silent = true})
-- vim.keymap.set('n', 'zM', "<Cmd>lua vim.fn.VSCodeNotify('editor.foldAll')<CR>", {silent = true})
-- vim.keymap.set('n', 'zo', "<Cmd>lua vim.fn.VSCodeNotify('editor.unfold')<CR>", {silent = true})
-- vim.keymap.set('n', 'zO', "<Cmd>lua vim.fn.VSCodeNotify('editor.unfoldRecursively')<CR>", {silent = true})
-- vim.keymap.set('n', 'zc', "<Cmd>lua vim.fn.VSCodeNotify('editor.fold')<CR>", {silent = true})
-- vim.keymap.set('n', 'zC', "<Cmd>lua vim.fn.VSCodeNotify('editor.foldRecursively')<CR>", {silent = true})
-- vim.keymap.set('n', 'z1', "<Cmd>lua vim.fn.VSCodeNotify('editor.foldLevel1')<CR>", {silent = true})
-- vim.keymap.set('n', 'z2', "<Cmd>lua vim.fn.VSCodeNotify('editor.foldLevel2')<CR>", {silent = true})
-- vim.keymap.set('n', 'z3', "<Cmd>lua vim.fn.VSCodeNotify('editor.foldLevel3')<CR>", {silent = true})
-- vim.keymap.set('n', 'z4', "<Cmd>lua vim.fn.VSCodeNotify('editor.foldLevel4')<CR>", {silent = true})
-- vim.keymap.set('n', 'z5', "<Cmd>lua vim.fn.VSCodeNotify('editor.foldLevel5')<CR>", {silent = true})
-- vim.keymap.set('n', 'z6', "<Cmd>lua vim.fn.VSCodeNotify('editor.foldLevel6')<CR>", {silent = true})
-- vim.keymap.set('n', 'z7', "<Cmd>lua vim.fn.VSCodeNotify('editor.foldLevel7')<CR>", {silent = true})
-- vim.keymap.set('x', 'zV', "<Cmd>lua vim.fn.VSCodeNotify('editor.foldAllExcept')<CR>", {silent = true})
-- vim.keymap.set('n', 'zj', "<Cmd>lua vim.fn.VSCodeNotify('editor.gotoNextFold')<CR>", {silent = true})
-- vim.keymap.set('n', 'zk', "<Cmd>lua vim.fn.VSCodeNotify('editor.gotoPreviousFold')<CR>", {silent = true})	
-- Visual mode

-- Normal mode mappings
vim.keymap.set('n', 'j',
    [[:<C-u>call VSCodeCall('cursorMove', { 'to': 'down', 'by': 'wrappedLine', 'value': v:count ? v:count : 1 })<CR>]],
    {
        noremap = true,
        silent = true
    })
vim.keymap.set('n', 'k',
    [[:<C-u>call VSCodeCall('cursorMove', { 'to': 'up', 'by': 'wrappedLine', 'value': v:count ? v:count : 1 })<CR>]], {
        noremap = true,
        silent = true
    })

local function move(d)
    return function()
        -- 獲取當前模式
        local mode = vim.api.nvim_get_mode().mode

        -- 檢查是否處於字符視覺模式（'v'）或行視覺模式（'V'）
        if not (mode == 'v' or mode == 'V') then
            -- 如果不是視覺模式，返回原始的 'gj' 或 'gk' 行為
            return 'g' .. d
        end

        -- 根據視覺模式設置 'by' 參數
        local by_option = 'wrappedLine' -- 默認為字符視覺模式
        if mode == 'V' then
            by_option = 'line' -- 行視覺模式
        end

        -- 執行 vscode-neovim 的 cursorMove 操作
        require('vscode-neovim').action('cursorMove', {
            args = {{
                to = d == 'j' and 'down' or 'up',
                by = by_option,
                value = vim.v.count1,
                select = true
            }}
        })

        -- 忽略原始按鍵行為
        return '<Ignore>'
    end
end

vim.keymap.set({'v'}, 'j', move('j'), {
    expr = true
})
vim.keymap.set({'v'}, 'k', move('k'), {
    expr = true
})

vim.keymap.set("n", "<Leader>qq", ":vsc Edit.FindinFiles<CR>", {
    noremap = true
})
-- like vscode command
vim.keymap.set("n", "<Leader>xm", ":vsc View.Terminal<CR>", {
    noremap = true
})
-- 擴展選取
vim.keymap.set("n", "<Leader>xx", ":vsc Edit.ExpandSelection<CR>", {
    noremap = true
})

print("Vscode Keymap Loaded")

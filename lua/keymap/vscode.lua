-- keymap/vscode.lua

local M = {}

function M.setup()
    local opts = { noremap = true, silent = true }

    vim.keymap.set("i", "<C-[>", "<Esc>", opts)

    local fold_mappings = {
        { key = "zM", command = "editor.foldAll" },
        { key = "zR", command = "editor.unfoldAll" },
        { key = "zc", command = "editor.fold" },
        { key = "zC", command = "editor.foldRecursively" },
        { key = "zo", command = "editor.unfold" },
        { key = "zO", command = "editor.unfoldRecursively" },
        { key = "za", command = "editor.toggleFold" },
        { key = "z1", command = "editor.foldLevel1" },
        { key = "z2", command = "editor.foldLevel2" },
        { key = "z3", command = "editor.foldLevel3" },
        { key = "z4", command = "editor.foldLevel4" },
        { key = "z5", command = "editor.foldLevel5" },
        { key = "z6", command = "editor.foldLevel6" },
        { key = "z7", command = "editor.foldLevel7" },
        { key = "zj", command = "editor.gotoNextFold" },
        { key = "zk", command = "editor.gotoPreviousFold" }
    }

    local vscode = require("vscode")
    vim.keymap.set("n", "gd", function()
      vscode.call("editor.action.revealDefinition")
    end, { silent = true })
    vim.keymap.set("n", "gy", function()
      vscode.call("editor.action.goToTypeDefinition")
    end, { silent = true })
    vim.keymap.set("n", "gi", function()
      vscode.call("editor.action.goToImplementation")
    end, { silent = true })
    vim.keymap.set("n", "gr", function()
      vscode.call("editor.action.goToReferences")
    end, { silent = true })

    for _, map in ipairs(fold_mappings) do
        vim.keymap.set("n", map.key, [[<Cmd>call VSCodeNotify("]] .. map.command .. [[")<CR>]], opts)
    end

    vim.keymap.set("n", "j", [[:<C-u>call VSCodeCall('cursorMove', { 'to': 'down', 'by': 'wrappedLine', 'value': v:count ? v:count : 1 })<CR>]], opts)
    vim.keymap.set("n", "k", [[:<C-u>call VSCodeCall('cursorMove', { 'to': 'up', 'by': 'wrappedLine', 'value': v:count ? v:count : 1 })<CR>]], opts)
    vim.keymap.set("n", "<Leader>qq", ":vsc Edit.FindinFiles<CR>", opts)
    vim.keymap.set("n", "<Leader>xm", ":vsc View.Terminal<CR>", opts)
    vim.keymap.set("n", "<Leader>xx", ":vsc Edit.ExpandSelection<CR>", opts)
end


-- 維持摺疊行選取跳過折疊，但是太多不舒服的問題了 Maintain the folding line and choose to skip folding, but there are too many uncomfortable problems
-- local function move(d)
--     return function()
--         -- 獲取當前模式
--         local mode = vim.api.nvim_get_mode().mode

--         -- 檢查是否處於字符視覺模式（'v'）或行視覺模式（'V'）
--         if not (mode == 'v' or mode == 'V') then
--             -- 如果不是視覺模式，返回原始的 'gj' 或 'gk' 行為
--             return 'g' .. d
--         end

--         -- 根據視覺模式設置 'by' 參數
--         local by_option = 'wrappedLine' -- 默認為字符視覺模式
--         if mode == 'V' then
--             by_option = 'line' -- 行視覺模式
--         end

--         -- 執行 vscode-neovim 的 cursorMove 操作
--         require('vscode-neovim').action('cursorMove', {
--             args = {{
--                 to = d == 'j' and 'down' or 'up',
--                 by = by_option,
--                 value = vim.v.count1,
--                 select = true
--             }}
--         })

--         -- 如果是行視覺模式，添加 <Esc>gvV 保持 Visual Line 模式
--         if mode == 'V' then
--             return '<Esc>gvV'
--         end

--         -- 否則忽略原始按鍵行為
--         return '<Ignore>'
--     end
-- end

-- vim.keymap.set({'v'}, 'j', move('j'), {
--     expr = true
-- })
-- vim.keymap.set({'v'}, 'k', move('k'), {
--     expr = true
-- })


return M

-- dummy content, replaced from canvas
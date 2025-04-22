local M = {}

function M.setup()
    local opts = { noremap = true, silent = true }

    -- 常用模式快捷鍵（共用於 Neovim + VSCode）
    vim.keymap.set("n", "o", "o<Esc>", opts)
    vim.keymap.set("n", "O", "O<Esc>", opts)
    vim.keymap.set({"n", "v"}, "d", '"_d', opts)
    vim.keymap.set("n", "D", '"_D', opts)
    vim.keymap.set("n", "dd", '"_dd', opts)
    vim.keymap.set("i", "<S-Tab>", "<C-d>", opts)
    vim.keymap.set("v", "p", '"_dP', opts)

    -- 僅 Neovim 使用 NvimTreeToggle
    if not vim.g.vscode then
        vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", opts)
    end
end

return M

local M = {}

function M.setup()
    local opts = { noremap = true, silent = true }

    vim.keymap.set("n", "<Esc>", "<Esc>:nohlsearch<CR>", { silent = true })

    vim.keymap.set("n", "<C-u>", function()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
    end, { noremap = true, silent = true })

    vim.keymap.set("n", "<C-i>", function()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
    end, { noremap = true, silent = true })

    -- Redo with <Esc>
    vim.keymap.set("n", "<C-r>", function()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
    end, { noremap = true, silent = true })

    -- Undo with <Esc>
    vim.keymap.set("n", "u", function()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("u<Esc>", true, false, true), "n", false)
    end, { noremap = true, silent = true })

    -- 常用模式快捷鍵（共用於 Neovim + VSCode）
    vim.keymap.set("n", "o", "o<Esc>", opts)
    vim.keymap.set("n", "O", "O<Esc>", opts)
    vim.keymap.set({ "n", "v" }, "d", '"_d', opts)
    vim.keymap.set("n", "D", '"_D', opts)
    vim.keymap.set("n", "dd", '"_dd', opts)
    vim.keymap.set("i", "<S-Tab>", "<C-d>", opts)
    vim.keymap.set("v", "p", '"_dP', opts)

    local function reload_lazyvim()
        local ok, reload = pcall(require, "lazy.core.reload")
        if ok and reload and reload.reload then
            reload.reload()
            vim.cmd("source $MYVIMRC")
            vim.cmd("doautocmd ColorScheme")
            vim.notify("🔁 LazyVim 設定已重新載入", vim.log.levels.INFO)
        else
            vim.notify("❌ LazyVim reload 失敗", vim.log.levels.ERROR)
        end
    end

    vim.keymap.set("n", "<leader>r", reload_lazyvim, { desc = "Reload LazyVim config" })
end

return M

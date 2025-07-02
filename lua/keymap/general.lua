local M = {}

function M.setup()
    local opts = { noremap = true, silent = true }

    vim.keymap.set("n", "<Esc>", "<Esc>:nohlsearch<CR>", { silent = true })

    -- 防止進入visualmode
    local function safe_command(cmd_key, desc)
        return function()
            -- 執行原始命令
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(cmd_key, true, false, true), "n", true)

            -- 延遲檢查並條件式回到 Normal Mode
            vim.schedule(function()
                local mode = vim.fn.mode()
                if mode == "v" or mode == "V" or mode == "\22" then
                    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
                end
            end)
        end
    end

    vim.keymap.set("n", "<C-o>", safe_command("<C-o>", "Previous location"))
    vim.keymap.set("n", "<C-i>", safe_command("<C-i>", "Next location"))
    vim.keymap.set("n", "u", safe_command("u", "Undo"))
    vim.keymap.set("n", "<C-r>", safe_command("<C-r>", "Redo"))

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

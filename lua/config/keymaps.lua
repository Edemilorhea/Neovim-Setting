-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<Esc>", "<Esc>:nohlsearch<CR>", { silent = true })

require("keymap.general").setup()

require("keymap.hotKeyMaps").setup()


if vim.g.vscode then
  require("keymap.vscode").setup()
end

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    -- 安全地移除 LazyVim 綁定
    pcall(vim.keymap.del, "n", "<C-/>")
    pcall(vim.keymap.del, "v", "<C-/>")

    -- 加入你自己的註解綁定
    if not vim.g.vscode then
      local toggle_comment = function(start_line, end_line)
        require("mini.comment").toggle_lines(start_line, end_line)
      end

      vim.keymap.set("n", "<C-/>", function()
        toggle_comment(vim.fn.line("."), vim.fn.line("."))
      end, { desc = "Toggle comment (current line)" })

      vim.keymap.set("v", "<C-/>", function()
        toggle_comment(vim.fn.line("'<"), vim.fn.line("'>"))
      end, { desc = "Toggle comment (visual selection)" })

      -- Ctrl-_ 作為兼容鍵
      vim.keymap.set("n", "<C-_>", function()
        toggle_comment(vim.fn.line("."), vim.fn.line("."))
      end, { desc = "Toggle comment (current line)" })

      vim.keymap.set("v", "<C-_>", function()
        toggle_comment(vim.fn.line("'<"), vim.fn.line("'>"))
      end, { desc = "Toggle comment (visual selection)" })
    end
  end,
})

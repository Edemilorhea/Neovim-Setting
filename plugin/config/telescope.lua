local M = {}

function M.setup()
    require("telescope").setup({
        defaults = {
            prompt_prefix = "> ",
            selection_caret = "> ",
            path_display = {"smart"}
        }
    })
    vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", {noremap = true, silent = true, desc = "Find Files"})
    vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", {noremap = true, silent = true, desc = "Live Grep"})
    vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", {noremap = true, silent = true, desc = "List Buffers"})
    vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", {noremap = true, silent = true, desc = "Help Tags"})
end

return M

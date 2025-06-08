local M = {}

function M.setup()
    -- Buffer 快捷鍵

    vim.keymap.set("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", {
        desc = "切換到下一個 Buffer",
    })
    vim.keymap.set("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", {
        desc = "切換到上一個 Buffer",
    })
    vim.keymap.set("n", "<leader>bc", "<cmd>BufferLinePickClose<CR>", {
        desc = "選擇關閉 Buffer",
    })
    vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", {
        desc = "關閉當前 Buffer",
    })

    -- Flash 快捷鍵
    local flash = require("flash")
    vim.keymap.set({ "n", "x", "o" }, "<leader>hf", flash.jump, {
        silent = true,
        desc = "[H]op [F]lash",
    })
    vim.keymap.set({ "n", "x", "o" }, "<leader>hF", flash.treesitter, {
        silent = true,
        desc = "Flash Treesitter",
    })
    vim.keymap.set({ "o", "x" }, "<leader>hr", flash.treesitter_search, {
        silent = true,
        desc = "Treesitter Search",
    })
    vim.keymap.set("n", "<leader>he", flash.toggle, {
        silent = true,
        desc = "Toggle Flash Search",
    })

    -- Telescope 快捷鍵
    vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", {
        noremap = true,
        silent = true,
        desc = "Find Files",
    })
    vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", {
        noremap = true,
        silent = true,
        desc = "Live Grep",
    })
    vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", {
        noremap = true,
        silent = true,
        desc = "List Buffers",
    })
    vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", {
        noremap = true,
        silent = true,
        desc = "Help Tags",
    })
    vim.keymap.set("n", "<leader>td", "<cmd>Telescope diagnostics<CR>", {
        noremap = true,
        silent = true,
        desc = "Telescope Diagnostics",
    })

    -- LSP 快捷鍵
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, {
        desc = "跳轉至定義",
    })
    vim.keymap.set("n", "ca", vim.lsp.buf.code_action, {
        desc = "LSP Code Action",
    })
    vim.keymap.set("n", "<leader>id", function()
        vim.diagnostic.open_float(nil, {
            focus = false,
        })
    end, {
        desc = "顯示行內診斷訊息",
    })

    -- 僅為了 WhichKey 顯示用，不重新綁定
    vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
            vim.keymap.set("n", "gnn", "", {
                desc = "初始化選取區塊",
            })
            vim.keymap.set("n", "grn", "", {
                desc = "擴展選取區塊",
            })
            vim.keymap.set("n", "grc", "", {
                desc = "擴展至範圍",
            })
            vim.keymap.set("n", "grm", "", {
                desc = "縮減選取區塊",
            })
        end,
    })

    -- nvim-cmp（補全）
    vim.keymap.set("i", "<C-Space>", "", {
        desc = "觸發補全",
    })
    vim.keymap.set("i", "<C-y>", "", {
        desc = "確認補全 (Ctrl + y)",
    })

    vim.keymap.set("n", "<leader>mp", "<cmd>Glow<CR>", { desc = "Markdown 預覽" })
end

return M

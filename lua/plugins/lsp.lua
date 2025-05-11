return {
  {
    "neovim/nvim-lspconfig",
    vscode = true,
    lazy = true,
    opts = function()
      local Keys = require("lazyvim.plugins.lsp.keymaps").get()
    -- stylua: ignore
    vim.list_extend(Keys, {
      { "gd", false },
      { "gr", false },
      { "gI", false },
      { "gy", false },
      { "<leader>ss", function() Snacks.picker.lsp_symbols({ filter = LazyVim.config.kind_filter }) end, desc = "LSP Symbols", has = "documentSymbol" },
      { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols({ filter = LazyVim.config.kind_filter }) end, desc = "LSP Workspace Symbols", has = "workspace/symbols" },
    })
    end,
  },
  {
    "williamboman/mason.nvim",
    version = "^1.0.0",
    cmd = { "Mason", "MasonInstall", "MasonLog" },
    build = ":MasonUpdate",
    vscode = true,
    lazy = true,
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    version = "^1.0.0",
    lazy = true,
    event = "VeryLazy",
    vscode = true,
    opts = {
      ensure_installed = {
        "lua_ls",
        "jsonls",
        "ts_ls",
        "html",
        "cssls",
        "volar",
        "emmet_ls",
        "eslint",
        "omnisharp",
        "pyright",
        "marksman",
      },
    },
  },
}

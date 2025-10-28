return {
  {
    "neovim/nvim-lspconfig",
    keys = {
      -- 禁用預設按鍵
      { "gd", false },
      { "gr", false },
      { "gI", false },
      { "gy", false },
      -- 自定義按鍵
      { "<leader>ss", "<cmd>Telescope lsp_document_symbols<cr>", desc = "LSP Symbols" },
      { "<leader>sS", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "LSP Workspace Symbols" },
    },
    opts = {
      servers = {
        jsonls = {},
        ts_ls = {},
        html = {},
        cssls = {},
        emmet_ls = {},
        eslint = {},
        omnisharp = {},
        pyright = {},
        marksman = {},
      },
    },
  },
  {
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonLog" },
    build = ":MasonUpdate",
    vscode = false,
    lazy = true,
    cond = function()
      return not vim.g.vscode
    end,
    opts = {},
  },
  {
    "mason-org/mason-lspconfig.nvim",
    lazy = true,
    event = "VeryLazy",
    vscode = false,
    cond = function()
      return not vim.g.vscode
    end,
    opts = {
      ensure_installed = {
        "jsonls",
        "ts_ls",
        "html",
        "cssls",
        "emmet_ls",
        "eslint",
        "omnisharp",
        "pyright",
        "marksman",
      },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    lazy = true,
    event = "VeryLazy",
    vscode = false,
    dependencies = { "mason.nvim" },
    cond = function()
      return not vim.g.vscode
    end,
    opts = {
      ensure_installed = {
        "stylua",
        "prettier",
        "black",
      },
      auto_update = false,
      run_on_start = true,
      start_delay = 3000,
      debounce_hours = 5,
      integrations = {
        ["mason-lspconfig"] = false,
        ["mason-null-ls"] = false,
        ["mason-nvim-dap"] = false,
      },
    },
  },
}

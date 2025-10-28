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
        -- Disable stylua as LSP (it's a formatter, not an LSP server)
        -- stylua = false,
        -- Fix vue_ls naming issue (LazyVim uses wrong name)
        -- vue_ls = false,
        lua_ls = {},
        jsonls = {},
        ts_ls = {},
        html = {},
        cssls = {},
        -- volar = {},
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
        "lua_ls",
        "jsonls",
        "ts_ls",
        "html",
        "cssls",
        -- "volar",
        "emmet_ls",
        "eslint",
        "omnisharp",
        "pyright",
        "marksman",
      },
    },
  },
}

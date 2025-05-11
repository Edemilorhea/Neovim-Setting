return {
  {
    "neovim/nvim-lspconfig",
    lazy = true, -- 確保 VSCode 中也能註冊 command
    vscode = true,
    dependencies = {
      { "Hoffs/omnisharp-extended-lsp.nvim", vscode = true },
    },
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
  {
    "williamboman/mason.nvim",
    version = "^1.0.0",
    cmd = { "Mason", "MasonInstall", "MasonLog" },
    build = ":MasonUpdate",
    vscode = true,
    lazy = true, -- 確保 VSCode 中也能註冊 command
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    version = "^1.0.0",
    lazy = true, -- 確保 VSCode 中也能註冊 command
    event = "VeryLazy",
    vscode = true,
    opts = {},
  },
}

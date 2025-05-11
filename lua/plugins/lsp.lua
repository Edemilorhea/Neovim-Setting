return {
  {
    "neovim/nvim-lspconfig",
    lazy = true, -- 確保 VSCode 中也能註冊 command
    vscode = true,
    dependencies = {
      { "Hoffs/omnisharp-extended-lsp.nvim", vscode = true },
    },
    opts = {},
  },
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonLog" },
    build = ":MasonUpdate",
    vscode = true,
    lazy = true, -- 確保 VSCode 中也能註冊 command
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = true, -- 確保 VSCode 中也能註冊 command
    event = "VeryLazy",
    vscode = true,
    opts = {},
  },
}

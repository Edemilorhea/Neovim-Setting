return {
  {
    "windwp/nvim-autopairs",
    enabled = true, -- 預設禁用，但仍需要出現在 Lazy 註冊清單
    vscode = true,
    lazy = true,
    init = function()
      -- 強制在 Lazy 註冊 plugin，即使 LazyVim 核心禁用它
      require("lazy.core.config").plugins["nvim-autopairs"].enabled = true
    end,
    config = function()
      require("nvim-autopairs").setup({})
      print("nvim-autopairs 手動載入成功")
    end,
    cmd = { "EnableAutopairs" },
  }
}


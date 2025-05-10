-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
if vim.g.vscode then
    vim.notify = print
    -- or直接用這個：
    print("這是在 VSCode 顯示的訊息")
  else
    vim.notify("這是 Neovim 的 notify")
  end
  vim.api.nvim_create_user_command("EnableAutopairs", function()
    require("lazy").load({ plugins = { "nvim-autopairs" } })
  end, {})



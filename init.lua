require("config.lazy")

if vim.g.vscode then
  -- VSCode 特定補丁與通知處理
  vim.notify = print

  -- 修補 LSP 清除引用以避免報錯
  vim.lsp = vim.lsp or {}
  vim.lsp.buf = vim.lsp.buf or {}
  vim.lsp.buf.clear_references = function() end
  require("plugin.lsp")
  print("這是在 VSCode 中顯示的訊息")
else
  -- 非 VSCode 才載入 LSP 設定與快捷鍵
  require("plugin.lsp").auto_enable_lsp() -- ← 請替換為你的 LSP 配置檔路徑
  require("config.keymaps")
  vim.notify("這是 Neovim 的 notify")
end

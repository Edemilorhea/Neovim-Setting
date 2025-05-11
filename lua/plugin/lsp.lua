local M = {}

local function setup_installed_servers()
  local lspconfig = require("lspconfig")
  local mason_lspconfig = require("mason-lspconfig")

  for _, name in ipairs(mason_lspconfig.get_installed_servers()) do
    lspconfig[name].setup({})
  end
end

-- 自動啟動 LSP（僅限 Neovim，不在 VSCode）
function M.auto_enable_lsp()
  if not vim.g.vscode then
    setup_installed_servers()
    vim.notify("[LSP] Neovim 啟動：已註冊語言伺服器", vim.log.levels.INFO)
  end
end

-- 手動切換 LSP：供 VSCode 下使用
function M.toggle_lsp()
  local clients = vim.lsp.get_clients()
  if #clients > 0 then
    for _, client in ipairs(clients) do
      client.stop()
    end
    vim.notify("[LSP] 所有語言伺服器已停止")
  else
    setup_installed_servers()
    vim.cmd("LspStart")
    vim.notify("[LSP] 已註冊並啟動所有已安裝的語言伺服器")
  end
end

-- 手動註冊指令（VSCode 專用）
vim.api.nvim_create_user_command("MasonToggle", function()
  require("plugin.lsp").toggle_lsp()
end, {})

function M.clear_references()
  if not vim.g.vscode and vim.lsp.buf.clear_references then
    vim.lsp.buf.clear_references()
  end
end

function M.hover()
  if vim.lsp.buf.hover then
    vim.lsp.buf.hover()
  end
end

function M.rename()
  if vim.lsp.buf.rename then
    vim.lsp.buf.rename()
  end
end

function M.definition()
  if vim.lsp.buf.definition then
    vim.lsp.buf.definition()
  end
end

function M.code_action()
  if vim.lsp.buf.code_action then
    vim.lsp.buf.code_action()
  end
end

return M

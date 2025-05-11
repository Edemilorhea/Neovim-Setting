local M = {}

-- 快捷鍵註冊 on_attach
local function on_attach(client, bufnr)
  local opts = { buffer = bufnr }

  vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "跳轉至定義", buffer = bufnr })
  vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "顯示提示", buffer = bufnr })
  vim.keymap.set("n", "ca", vim.lsp.buf.code_action, { desc = "LSP Code Action", buffer = bufnr })
  vim.keymap.set("n", "<leader>e", function()
    vim.diagnostic.open_float(nil, { focus = false })
  end, { desc = "顯示行內診斷訊息", buffer = bufnr })
end

-- 自訂語言伺服器設定（如 omnisharp）
local function get_custom_server_config()
  local ok_ext, omnisharp_extended = pcall(require, "omnisharp_extended")

  return {
    omnisharp = {
      handlers = ok_ext and {
        ["textDocument/definition"] = omnisharp_extended.definition_handler,
        ["textDocument/typeDefinition"] = omnisharp_extended.type_definition_handler,
        ["textDocument/references"] = omnisharp_extended.references_handler,
        ["textDocument/implementation"] = omnisharp_extended.implementation_handler,
      } or nil,
      settings = {
        FormattingOptions = { EnableEditorConfigSupport = true },
        RoslynExtensionsOptions = { EnableAnalyzersSupport = true },
        Sdk = { IncludePrereleases = true },
      },
    },
    -- 你也可以加入其他如 lua_ls/tsserver 的自訂設定
    -- lua_ls = { settings = { Lua = {...} } }
  }
end

local function setup_installed_servers()
  local lspconfig = require("lspconfig")
  local mason_lspconfig = require("mason-lspconfig")
  local custom_servers = get_custom_server_config()

  for _, name in ipairs(mason_lspconfig.get_installed_servers()) do
    local opts = custom_servers[name] or {}
    opts.on_attach = on_attach
    lspconfig[name].setup(opts)
  end
end

-- 自動啟動 LSP（不在 VSCode 時）
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

-- VSCode 使用：手動註冊
vim.api.nvim_create_user_command("MasonToggle", function()
  require("plugin.lsp").toggle_lsp()
end, {})

-- 常用操作封裝
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

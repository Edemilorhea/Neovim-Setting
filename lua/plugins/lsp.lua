return {
  {
    "williamboman/mason.nvim",
    version = "v1.*",
    lazy = vim.g.vscode,
    priority = 800,
    config = function()
      if vim.g.vscode then return end 
      require("mason").setup({ 
        ui = { 
          border = "rounded", 
          icons = { 
            package_installed = "✓", 
            package_pending = "➜", 
            package_uninstalled = "✗" 
          }
        }
      })
    end
  },

  {
    "williamboman/mason-lspconfig.nvim",
    version = "v1.*",
    lazy = vim.g.vscode,
    priority = 700,
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      if vim.g.vscode then return end
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls", "pyright", "tsserver", "html", "cssls", "jsonls", "marksman", "omnisharp"
        },
        automatic_installation = true
      })
    end
  },

  {
    "neovim/nvim-lspconfig",
    lazy = vim.g.vscode,
    priority = 50,
    config = function()
      if vim.g.vscode then
        vim.notify("VSCode 環境中，LSP 未啟動")
        return
      end

      vim.notify("Neovim 模式，LSP 自動啟動")

      local on_attach = function(client, bufnr)
        local opts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "ca", vim.lsp.buf.code_action, opts)

        local has_sig, sig = pcall(require, "lsp_signature")
        if has_sig then
          sig.on_attach({
            hint_enable = true,
            floating_window = false,
            hint_prefix = "💡 "
          }, bufnr)
        end
      end

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      if has_cmp then
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
      end

      local lspconfig = require("lspconfig")

      -- Lua 設定
      lspconfig.lua_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false }
          }
        }
      })

      -- 其他通用 LSP
      local common_servers = { "pyright", "tsserver", "html", "cssls", "jsonls", "marksman" }
      for _, server in ipairs(common_servers) do
        lspconfig[server].setup({
          on_attach = on_attach,
          capabilities = capabilities,
        })
      end

      -- OmniSharp (修正 cmd)
      local omnisharp_bin = vim.fn.stdpath("data") .. "/mason/packages/omnisharp/OmniSharp.exe"
      if vim.fn.filereadable(omnisharp_bin) == 1 then
        local has_ext, omnisharp_ext = pcall(require, "omnisharp_extended")
        local handlers = {}
        if has_ext then
          handlers = {
            ["textDocument/definition"] = omnisharp_ext.definition_handler,
            ["textDocument/typeDefinition"] = omnisharp_ext.type_definition_handler,
            ["textDocument/references"] = omnisharp_ext.references_handler,
            ["textDocument/implementation"] = omnisharp_ext.implementation_handler
          }
        end

        lspconfig.omnisharp.setup({
          cmd = { omnisharp_bin, "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
          on_attach = on_attach,
          capabilities = capabilities,
          handlers = handlers,
          settings = {
            FormattingOptions = {
              EnableEditorConfigSupport = true,
            },
            RoslynExtensionsOptions = {
              EnableAnalyzersSupport = true,
            },
          },
        })
      else
        vim.notify("找不到 OmniSharp.exe，請執行 :MasonInstall omnisharp")
      end
    end
  },

  {
    "ray-x/lsp_signature.nvim",
    lazy = vim.g.vscode,
    config = function()
      if vim.g.vscode then return end
      require("lsp_signature").setup({
        hint_enable = true,
        floating_window = false,
        hint_prefix = "💡 "
      })
    end
  },

  {
    "Hoffs/omnisharp-extended-lsp.nvim",
    lazy = vim.g.vscode,
    ft = vim.g.vscode and {} or { "cs", "csharp" }
  },

  { 
    "rachartier/tiny-inline-diagnostic.nvim", 
    lazy = vim.g.vscode, 
    event = vim.g.vscode and "VeryLazy" or "BufReadPost", 
    config = function() 
      if vim.g.vscode then return end 
      require("tiny-inline-diagnostic").setup() 
      vim.diagnostic.config({ 
        virtual_text = false 
      }) 
    end
  },
}

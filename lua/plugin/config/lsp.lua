local M = {}
local mason_enabled = false

function M.setup()
	-- ==================== Treesitter 配置 ====================
	local ts_ok, treesitter = pcall(require, "nvim-treesitter.configs")
	if ts_ok then
		treesitter.setup({
			ensure_installed = { "html", "javascript", "vue", "css", "python", "c_sharp", "lua", "typescript" },
			highlight = { enable = true },
			indent = { enable = true },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "gnn",
					node_incremental = "grn",
					scope_incremental = "grc",
					node_decremental = "grm",
				},
			},
		})
	end

	-- ==================== nvim-cmp 配置 ====================
	local cmp_ok, cmp = pcall(require, "cmp")
	if cmp_ok then
		cmp.setup({
			snippet = {
				expand = function(args)
					local luasnip_ok, luasnip = pcall(require, "luasnip")
					if luasnip_ok then
						luasnip.lsp_expand(args.body)
					end
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<CR>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.confirm({ select = true })
					else
						fallback()
					end
				end, { "i", "s" }),
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					else
						fallback()
					end
				end, { "i", "s" }),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					else
						fallback()
					end
				end, { "i", "s" }),
				["<C-l>"] = cmp.mapping.complete(),
				["<C-y>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.confirm({ select = true })
					else
						fallback()
					end
				end, { "i", "s" }),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
			}, {
				{ name = "buffer" },
				{ name = "path" },
			}),
		})
	end

	-- ==================== null-ls 配置 ====================
	local null_ok, nullls_config = pcall(require, "plugin.config.null-ls")
	if null_ok then
		nullls_config.setup()
	end

	-- ==================== 啟用 LSP ====================
	M.enable_lsp()
end

function M.enable_lsp()
	if mason_enabled then
		return
	end

	local mason_ok, mason = pcall(require, "mason")
	local mason_lsp_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
	local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
	if not (mason_ok and mason_lsp_ok and lspconfig_ok) then
		vim.notify("[Mason] mason/mason-lspconfig/lspconfig 載入失敗", vim.log.levels.ERROR)
		return
	end

	mason.setup({
		ui = {
			border = "rounded",
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},
		},
	})

	mason_lspconfig.setup({
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
		automatic_installation = false,
	})

	vim.diagnostic.config({
		virtual_text = true,
		signs = true,
		underline = true,
		update_in_insert = false,
		severity_sort = true,
		float = {
			border = "rounded",
			source = "always",
		},
	})

	local on_attach = function(client, bufnr)
		local opts = { buffer = bufnr, remap = false }
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		local sig_ok, sig = pcall(require, "lsp_signature")
		if sig_ok then
			sig.on_attach({
				hint_enable = true,
				floating_window = false,
				hint_prefix = "💡 ",
			}, bufnr)
		end
	end

	-- ==================== 特別處理 Omnisharp ====================
	local ok_ext, omnisharp_ext = pcall(require, "omnisharp_extended")
	local omnisharp_dll = vim.fn.stdpath("data") .. "/mason/packages/omnisharp/libexec/OmniSharp.dll"
	local omnisharp_cmd = { "dotnet", omnisharp_dll }

	lspconfig.omnisharp.setup({
		cmd = omnisharp_cmd,
		root_dir = lspconfig.util.root_pattern("*.csproj", "*.sln", ".git"),
		enable_roslyn_analyzers = true,
		enable_import_completion = true,
		organize_imports_on_format = true,
		on_attach = on_attach,
		handlers = ok_ext and {
			["textDocument/definition"] = omnisharp_ext.definition_handler,
			["textDocument/typeDefinition"] = omnisharp_ext.type_definition_handler,
			["textDocument/references"] = omnisharp_ext.references_handler,
			["textDocument/implementation"] = omnisharp_ext.implementation_handler,
		} or nil,
		settings = {
			FormattingOptions = { EnableEditorConfigSupport = true },
			RoslynExtensionsOptions = { EnableAnalyzersSupport = true },
			Sdk = { IncludePrereleases = true },
		},
		capabilities = {
			workspace = {
				didChangeWatchedFiles = { dynamicRegistration = false },
				workspaceFolders = false,
			},
		},
	})

	-- ==================== 統一透過 handler 管理 LSP ====================
	mason_lspconfig.setup_handlers({
		function(server_name)
			lspconfig[server_name].setup({
				on_attach = on_attach,
			})
		end,

		["lua_ls"] = function()
			lspconfig.lua_ls.setup({
				on_attach = on_attach,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			})
		end,
	})

	mason_enabled = true
	vim.notify("[Mason] 啟用成功")
end

function M.disable_lsp()
	if not mason_enabled then
		return
	end
	for _, client in pairs(vim.lsp.get_clients()) do
		client.stop()
	end
	mason_enabled = false
	vim.notify("[Mason] 所有 LSP 已停止")
end

function M.toggle_lsp()
	if mason_enabled then
		M.disable_lsp()
	else
		M.enable_lsp()
	end
end

function M.enable()
	return M.enable_lsp()
end

function M.disable()
	return M.disable_lsp()
end

function M.toggle()
	return M.toggle_lsp()
end

if not vim.g.vscode then
	vim.schedule(function()
		M.setup()
	end)
end

vim.api.nvim_create_user_command("MasonToggle", function()
	require("plugin.config.lsp").toggle_lsp()
end, {})

return M

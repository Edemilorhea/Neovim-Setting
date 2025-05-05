local M = {}
local mason_enabled = false

function M.enable()
	if mason_enabled then
		vim.notify("[Mason] 已經啟用，略過重複設定")
		return
	end

	local ok_mason, mason = pcall(require, "mason")
	local ok_mason_lsp, mason_lspconfig = pcall(require, "mason-lspconfig")
	local ok_lspconfig, lspconfig = pcall(require, "lspconfig")
	if not (ok_mason and ok_mason_lsp and ok_lspconfig) then
		vim.notify("[Mason] 載入失敗，請確認 mason / mason-lspconfig / lspconfig 是否安裝")
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

	local on_attach = function(client, bufnr)
		local opts = {
			buffer = bufnr,
			remap = false,
		}
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	end

	-- 特別處理 C#：OmniSharp
	local ok_ext, omnisharp_extended = pcall(require, "omnisharp_extended")
	local omnisharp_path = vim.fn.stdpath("data") .. "/mason/bin/omnisharp"
	if vim.fn.has("win32") == 1 then
		omnisharp_path = omnisharp_path .. ".cmd"
	end

	lspconfig.omnisharp.setup({
		cmd = { omnisharp_path },
		root_dir = lspconfig.util.root_pattern("*.csproj", "*.sln", ".git"),
		enable_roslyn_analyzers = true,
		enable_import_completion = true,
		organize_imports_on_format = true,
		on_attach = on_attach,
		handlers = ok_ext and {
			["textDocument/definition"] = omnisharp_extended.definition_handler,
			["textDocument/typeDefinition"] = omnisharp_extended.type_definition_handler,
			["textDocument/references"] = omnisharp_extended.references_handler,
			["textDocument/implementation"] = omnisharp_extended.implementation_handler,
		} or nil,
	})

	mason_lspconfig.setup_handlers({
		function(server_name)
			if server_name ~= "omnisharp" then
				lspconfig[server_name].setup({
					on_attach = on_attach,
				})
			end
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
		-- ✅ marksman 設定（Markdown）
		["marksman"] = function()
			lspconfig.marksman.setup({
				on_attach = on_attach,
				filetypes = { "markdown" },
			})
		end,
	})

	mason_enabled = true
	vim.notify("[Mason] 啟用成功")
end

function M.disable()
	if not mason_enabled then
		return
	end
	for _, client in pairs(vim.lsp.get_active_clients()) do
		client.stop()
	end
	mason_enabled = false
	vim.notify("[Mason] 所有 LSP 已停止")
end

function M.toggle()
	if mason_enabled then
		M.disable()
	else
		M.enable()
	end
end

-- 若不是在 vscode 中，自動啟用 mason
if not vim.g.vscode then
	vim.schedule(function()
		require("plugin.config.mason").enable()
	end)
end

-- 可用 :MasonToggle 切換
vim.api.nvim_create_user_command("MasonToggle", function()
	require("plugin.config.mason").toggle()
end, {})

return M

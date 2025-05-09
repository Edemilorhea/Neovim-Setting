-- neovimorg.lua => 模組化為 plugin/config/lsp.lua
local M = {}

function M.setup()
	-- Treesitter（可選，如果 PluginsList.lua 已處理可省略）
	local ts_ok, treesitter = pcall(require, "nvim-treesitter.configs")
	if ts_ok then
		treesitter.setup({
			ensure_installed = { "html", "javascript", "vue", "css", "python", "c_sharp" },
			highlight = {
				enable = true,
			},
			indent = {
				enable = true,
			},
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

	-- nvim-cmp（補全引擎）
	local cmp = require("cmp")
	cmp.setup({
		snippet = {
			expand = function(args)
				require("luasnip").lsp_expand(args.body)
			end,
		},
		mapping = cmp.mapping.preset.insert({
			-- Enter 鍵：補全時選擇，否則換行
			["<CR>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.confirm({ select = true })
				else
					fallback()
				end
			end, { "i", "s" }),

			-- Tab 鍵：補全時選下一個，否則照原本作用（例如縮排）
			["<Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				else
					fallback()
				end
			end, { "i", "s" }),

			-- Shift+Tab 鍵：補全時選上一個，否則照原本作用
			["<S-Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				else
					fallback()
				end
			end, { "i", "s" }),

			-- Ctrl+Space：打開補全（不需判斷）
			["<C-l>"] = cmp.mapping.complete(),

			-- Ctrl+y：補全時確認選擇，否則略過
			["<C-y>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.confirm({ select = true })
				else
					fallback()
				end
			end, { "i", "s" }),
		}),

		sources = cmp.config.sources(
			{ {
				name = "nvim_lsp",
			}, {
				name = "luasnip",
			} },
			{ {
				name = "buffer",
			}, {
				name = "path",
			} }
		),
	})

	local ok, nullls_config = pcall(require, "plugin.config.null-ls")
	if ok then
		nullls_config.setup()
	end
end

return M

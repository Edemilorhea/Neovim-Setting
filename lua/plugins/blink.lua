return {
  "saghen/blink.cmp",
  dependencies = {
    "rafamadriz/friendly-snippets",
  },
  version = "v0.*",
  opts = {
    -- 按鍵對應
    keymap = {
      preset = "default", -- 使用預設按鍵配置
      -- 或者自訂按鍵：
      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      -- ["<C-e>"] = { "hide" },
      ["<Tab>"] = { "accept", "fallback" },
      -- ["<CR>"] = { "accept", "fallback" },
      -- ["<Tab>"] = { "select_next", "fallback" },
      -- ["<S-Tab>"] = { "select_prev", "fallback" },
      -- ["<C-n>"] = { "select_next", "fallback" },
      -- ["<C-p>"] = { "select_prev", "fallback" },
    },

    -- 外觀設定
    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = "mono",
    },

    -- 完成設定
    completion = {
      accept = {
        auto_brackets = {
          enabled = true,
        },
      },
      menu = {
        draw = {
          treesitter = { "lsp" },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
      },
    },

    -- 資料來源
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
      providers = {
        lsp = {
          name = "LSP",
          module = "blink.cmp.sources.lsp",
        },
        path = {
          name = "Path",
          module = "blink.cmp.sources.path",
          score_offset = 3,
        },
        snippets = {
          name = "Snippets",
          module = "blink.cmp.sources.snippets",
        },
        buffer = {
          name = "Buffer",
          module = "blink.cmp.sources.buffer",
        },
      },
    },

    -- 簽名幫助
    signature = {
      enabled = true,
    },
  },
}
--
-- return {
--   {
--     "saghen/blink.cmp",
--     dependencies = { "rafamadriz/friendly-snippets" },
--     opts = function()
--       -- 檢查是否啟用了與 blink 的整合
--       local integration_enabled = vim.g.autolist_blink_integration or false
--       local autolist = nil
--
--       if integration_enabled then
--         local ok, al = pcall(require, "autolist")
--         if ok then
--           autolist = al
--         end
--       end
--       return {
--         keymap = {
--           preset = "none",
--           ["<Tab>"] = { "select_next", "fallback" },
--           ["<S-Tab>"] = { "select_prev", "fallback" },
--           ["<CR>"] = integration_enabled and autolist and {
--             "accept",
--             function(fallback)
--               local cr = vim.api.nvim_replace_termcodes("<CR>", true, false, true)
--               if autolist.create_mapping_hook then
--                 local result = autolist.create_mapping_hook(function()
--                   return cr
--                 end, true)()
--                 fallback(result)
--               else
--                 fallback(cr)
--               end
--             end,
--           } or { "accept", "fallback" },
--         },
--         appearance = {
--           nerd_font_variant = "mono",
--         },
--         completion = {
--           documentation = { auto_show = false },
--         },
--         sources = {
--           default = { "lsp", "path", "snippets", "buffer" },
--         },
--         fuzzy = {
--           implementation = "prefer_rust_with_warning",
--         },
--       }
--     end,
--     opts_extend = { "sources.default" },
--   },
-- }

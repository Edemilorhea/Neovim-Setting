return {
  {
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = function()
      -- 檢查是否啟用了與 blink 的整合
      local integration_enabled = vim.g.autolist_blink_integration or false
      local autolist = nil

      if integration_enabled then
        local ok, al = pcall(require, "autolist")
        if ok then
          autolist = al
        end
      end

      return {
        keymap = {
          preset = "none",
          ["<Tab>"] = { "select_next", "fallback" },
          ["<S-Tab>"] = { "select_prev", "fallback" },
          ["<CR>"] = integration_enabled and autolist and {
            "accept",
            function(fallback)
              local cr = vim.api.nvim_replace_termcodes("<CR>", true, false, true)
              if autolist.create_mapping_hook then
                local result = autolist.create_mapping_hook(function()
                  return cr
                end, true)()
                fallback(result)
              else
                fallback(cr)
              end
            end,
          } or { "accept", "fallback" },
        },
        appearance = {
          nerd_font_variant = "mono",
        },
        completion = {
          documentation = { auto_show = false },
        },
        sources = {
          default = { "lsp", "path", "snippets", "buffer" },
        },
        fuzzy = {
          implementation = "prefer_rust_with_warning",
        },
      }
    end,
    opts_extend = { "sources.default" },
  },
}

return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-emoji",
  },
  opts = function(_, opts)
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    opts.snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    }

    -- sources 設定，emoji 放後面，luasnip 提前並提升優先度
    table.insert(opts.sources, { name = "emoji" })
    table.insert(opts.sources, 1, {
      name = "luasnip",
      group_index = 1,
      priority = 101,
    })
  end,
}

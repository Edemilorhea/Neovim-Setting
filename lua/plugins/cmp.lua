return {
  "hrsh7th/nvim-cmp",
  dependencies = { "hrsh7th/cmp-emoji" },
  opts = function(_, opts)
    opts.snippet.expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end
    table.insert(opts.sources, { name = "emoji" })
    table.insert(opts.sources, 1, { name = "luasnip", group_index = 1, priority = 101 })
  end,
}

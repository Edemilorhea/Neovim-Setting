return {
  "hrsh7th/nvim-cmp",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-emoji",
  },
  opts = function(_, opts)
    local luasnip = require("luasnip")

    opts.snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    }

    -- 工具函式：檢查 source 是否已經存在
    local function has_source(name)
      for _, s in ipairs(opts.sources) do
        if s.name == name then
          return true
        end
      end
      return false
    end

    -- 插入 luasnip 到最前面
    if not has_source("luasnip") then
      table.insert(opts.sources, 1, {
        name = "luasnip",
        group_index = 1,
        priority = 101,
      })
    end

    -- 插入 emoji 到最後
    if not has_source("emoji") then
      table.insert(opts.sources, { name = "emoji" })
    end
  end,
}

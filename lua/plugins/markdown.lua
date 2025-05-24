return { -- Glow Markdown 終端預覽 (LazyVim 沒有)
  {
    "ellisonleao/glow.nvim",
    lazy = true,
    cmd = "Glow",
    config = function()
      if vim.g.vscode then
        return
      end

      require("glow").setup({
        glow_path = "", -- will be filled automatically with your glow bin in $PATH, if any
        install_path = "~/.local/bin", -- default path for installing glow binary
        border = "shadow", -- floating window border config
        style = "dark", -- filled automatically with your current editor background, you can override using glow json style
        pager = false,
        width = 80,
        height = 100,
        width_ratio = 0.7, -- maximum width of the Glow window compared to the nvim window size (overrides `width`)
        height_ratio = 0.7,
      })
    end,
  }, -- Markdown 渲染增強 (LazyVim 沒有)
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown" },
    opts = {
      -- 渲染模式
      enabled = true,
      max_file_size = 10.0, -- MB，超過此大小不渲染

      -- 標題設定
      heading = {
        enabled = true,
        sign = true, -- 顯示標題符號
        position = "overlay", -- 'overlay' | 'inline' | 'right'
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
        signs = { "󰫎 " },
        width = "full", -- 'full' | 'block'
        backgrounds = { -- 標題背景顏色
          "RenderMarkdownH1Bg",
          "RenderMarkdownH2Bg",
          "RenderMarkdownH3Bg",
          "RenderMarkdownH4Bg",
          "RenderMarkdownH5Bg",
          "RenderMarkdownH6Bg",
        },
        foregrounds = { -- 標題前景顏色
          "RenderMarkdownH1",
          "RenderMarkdownH2",
          "RenderMarkdownH3",
          "RenderMarkdownH4",
          "RenderMarkdownH5",
          "RenderMarkdownH6",
        },
      },

      -- 代碼塊設定
      code = {
        enabled = true,
        sign = true,
        style = "full", -- 'full' | 'normal' | 'language' | 'none'
        position = "left", -- 'left' | 'right'
        language_pad = 0,
        disable_background = { "diff" },
        width = "full", -- 'full' | 'block'
        pad = 2,
        border = "thick", -- 'thick' | 'thin'
        above = "▄",
        below = "▀",
        highlight = "RenderMarkdownCodeBg",
        highlight_inline = "RenderMarkdownCodeInlineBg",
      },

      -- 清單設定
      bullet = {
        enabled = true,
        icons = { "●", "○", "◆", "◇" },
        ordered_icons = {},
        left_pad = 0,
        right_pad = 0,
        highlight = "RenderMarkdownBullet",
      },

      -- 核取方塊設定
      checkbox = {
        enabled = true,
        unchecked = {
          icon = "󰄱 ",
          highlight = "RenderMarkdownUnchecked",
        },
        checked = {
          icon = "󰱒 ",
          highlight = "RenderMarkdownChecked",
        },
        custom = {
          todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo" },
        },
      },

      -- 引用設定
      quote = {
        enabled = true,
        icon = "▋",
        repeat_linebreak = false,
        highlight = "RenderMarkdownQuote",
      },

      -- 分隔線設定
      pipe_table = {
        enabled = true,
        preset = "none", -- 'none' | 'round' | 'double' | 'heavy'
        style = "full", -- 'full' | 'normal' | 'none'
        cell = "padded", -- 'padded' | 'raw' | 'overlay'
        border = {
          "┌",
          "┬",
          "┐",
          "├",
          "┼",
          "┤",
          "└",
          "┴",
          "┘",
          "│",
          "─",
        },
        alignment_indicator = "━",
        head = "RenderMarkdownTableHead",
        row = "RenderMarkdownTableRow",
        filler = "RenderMarkdownTableFill",
      },

      -- 連結設定
      link = {
        enabled = true,
        image = "󰥶 ",
        email = "󰀓 ",
        hyperlink = "󰌹 ",
        highlight = "RenderMarkdownLink",
        custom = {
          web = { pattern = "^http", icon = "󰖟 ", highlight = "RenderMarkdownLink" },
        },
      },

      -- 數學公式設定
      latex = {
        enabled = true,
        converter = "latex2text", -- 需要安裝 latex2text
        highlight = "RenderMarkdownMath",
        top_pad = 0,
        bottom_pad = 0,
      },

      -- 快捷鍵設定
      win_options = {
        conceallevel = {
          default = vim.o.conceallevel,
          rendered = 3,
        },
        concealcursor = {
          default = vim.o.concealcursor,
          rendered = "",
        },
      },
    },
  },
  {
    "toppair/peek.nvim",
    build = "deno task --quiet build:fast", -- 構建命令
    lazy = true,
    ft = "markdown", -- 只在 markdown 文件中加載
    cmd = { "PeekOpen", "PeekClose" }, -- 通過命令觸發加載
    config = function()
      if vim.g.vscode then
        return
      end

      require("peek").setup({
        auto_load = true,
        syntax = true,
        theme = "dark",
        update_on_change = true,
        filetype = { "markdown" },
        app = "browser",
      })

      -- 創建用戶命令
      vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
      vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
    end,
    -- 可選：添加快捷鍵
    keys = {
      {
        "<leader>mp",
        "<cmd>PeekOpen<CR>",
        desc = "打開 Markdown 預覽",
      },
      {
        "<leader>mc",
        "<cmd>PeekClose<CR>",
        desc = "關閉 Markdown 預覽",
      },
    },
  },
}

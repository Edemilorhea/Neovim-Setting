return { -- 程式碼折疊 (LazyVim 沒有)
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    lazy = true,
    event = "BufReadPost", -- 在緩衝區讀取後加載
    config = function()
      if vim.g.vscode then
        return
      end

      require("ufo").setup({
        provider_selector = function(_, _, _)
          return { "treesitter", "indent" }
        end,
      })

      -- 可選：設定折疊相關選項
      vim.o.foldlevel = 99 -- 打開文件時不自動折疊
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
    -- 可選：添加快捷鍵
    keys = { -- 示例快捷鍵，您可以根據需要修改
      {
        "zR",
        function()
          require("ufo").openAllFolds()
        end,
        desc = "打開所有折疊",
      },
      {
        "zM",
        function()
          require("ufo").closeAllFolds()
        end,
        desc = "關閉所有折疊",
      },
      {
        "zr",
        function()
          require("ufo").openFoldsExceptKinds()
        end,
        desc = "打開一層折疊",
      },
      {
        "zm",
        function()
          require("ufo").closeFoldsWith()
        end,
        desc = "關閉一層折疊",
      },
      {
        "zp",
        function()
          require("ufo").peekFoldedLinesUnderCursor()
        end,
        desc = "預覽折疊內容",
      },
    },
  }, -- 自動列表 (LazyVim 沒有)
  {
    "gaoDean/autolist.nvim",
    lazy = true,
    ft = { "markdown", "text", "tex", "plaintex", "norg" },
    config = function()
      local autolist_basic_enabled = true
      local autolist_blink_integration = false

      if vim.g.vscode or not autolist_basic_enabled then
        return
      end

      vim.g.autolist_blink_integration = autolist_blink_integration

      local autolist = require("autolist")
      autolist.setup()

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "markdown", "text", "tex", "plaintex", "norg" },
        callback = function()
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = true, desc = desc })
          end

          -- map("i", "<Tab>", "<Cmd>AutolistTab<CR>", "Autolist Indent")
          -- map("i", "<S-Tab>", "<Cmd>AutolistShiftTab<CR>", "Autolist Dedent")

          -- 添加此映射以在輸入模式下自動延續列表
          map("i", "<CR>", "<CR><Cmd>AutolistNewBullet<CR>", "Auto continue list")

          map("n", "<CR>", "<Cmd>AutolistToggleCheckbox<CR><CR>", "Toggle checkbox")
          map("n", "<C-r>", "<Cmd>AutolistRecalculate<CR>", "Recalculate list")
          map("n", "cn", autolist.cycle_next_dr, "cycle next list type")
          map("n", "cp", autolist.cycle_prev_dr, "cycle prev list type")
          map("n", ">>", ">><Cmd>AutolistRecalculate<CR>", "Indent and recalc")
          map("n", "<<", "<<<Cmd>AutolistRecalculate<CR>", "Dedent and recalc")
          map("n", "dd", function()
            vim.cmd('normal! "_dd')
            vim.cmd("AutolistRecalculate")
          end, "Delete line and recalc")
          map("v", "d", function()
            vim.cmd('normal! "_d')
            vim.cmd("AutolistRecalculate")
          end, "Visual delete and recalc")
          map("v", "p", "pAutolistRecalculate", "Paste and recalc")
        end,
      })
    end,
  },
  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    opts = {
      -- 使用原生映射方式
      mappings = {
        -- 這將映射gcc和gc
        comment = "gc",
        -- 這會映射gcc
        comment_line = "gcc",
        -- 這會在visual模式下映射gc
        comment_visual = "gc",
        textobject = "gc",
      },
    },
    config = function(_, opts)
      if vim.g.vscode then
        return
      end
      require("mini.comment").setup(opts)
    end,
  },
  {
    "numToStr/Comment.nvim",
    enabled = false, -- 預設禁用，需要時可切換為 true
    lazy = true,
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      if vim.g.vscode then
        return
      end

      -- 基本設定
      require("Comment").setup()

      -- 載入 Comment.nvim 的 API 模組
      local comment_api = require("Comment.api")

      -- --- 設定 Comment.nvim 的 Ctrl+/ 和 Ctrl+_ 快捷鍵 ---

      -- 將 Ctrl+/ 映射到切換目前行註解 (Normal 模式)
      vim.keymap.set("n", "<C-/>", function()
        comment_api.toggle.linewise.current()
      end, {
        noremap = true,
        silent = true,
        desc = "Comment toggle current line",
      })

      -- 將 Ctrl+/ 映射到切換選取範圍的行註解 (Visual 模式)
      vim.keymap.set("v", "<C-/>", function()
        comment_api.toggle.linewise(vim.fn.visualmode())
      end, {
        noremap = true,
        silent = true,
        desc = "Comment toggle visual lines",
      })

      -- 同樣為 Ctrl+_ (某些終端機的備用) 進行映射
      vim.keymap.set("n", "<C-_>", function()
        comment_api.toggle.linewise.current()
      end, {
        noremap = true,
        silent = true,
        desc = "Comment toggle current line (C-_)",
      })

      vim.keymap.set("v", "<C-_>", function()
        comment_api.toggle.linewise(vim.fn.visualmode())
      end, {
        noremap = true,
        silent = true,
        desc = "Comment toggle visual lines (C-_)",
      })

      -- 在配置完成後輸出調試信息
      print("Comment.nvim keymaps setup complete")
    end,
  }, -- 修改 Treesitter 設定 (LazyVim 有但要補充設定)
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = vim.g.vscode, -- 在 VSCode 中懶加載
    vscode = false,
    build = ":TSUpdate",
    config = function()
      if vim.g.vscode then
        return
      end

      -- 設定 Treesitter 的安裝選項
      require("nvim-treesitter.install").prefer_git = true

      -- 指定使用預編譯的解析器
      require("nvim-treesitter.install").compilers = { "clang", "gcc", "cl", "zig" }

      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua",
          "vim",
          "vimdoc",
          "query", -- basic
          "html",
          "javascript",
          "vue",
          "css",
          "python",
          "c_sharp",
          "typescript", -- your extended list
        },
        sync_install = false, -- 不同步安裝（除非你想改成 true）
        auto_install = true, -- 自動安裝缺少的 parser
        ignore_install = {}, -- 忽略安裝的語言列表（預設空）
        modules = {},
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
    end,
  }, -- Treesitter Playground (LazyVim 沒有)
  {
    "nvim-treesitter/playground",
    lazy = true,
    vscode = false,
    cmd = { "TSPlaygroundToggle", "TSHighlightCapturesUnderCursor" },
  },
  {
    "kdheepak/lazygit.nvim",
    cmd = "LazyGit",
    keys = { {
      "<leader>lg",
      "<cmd>LazyGit<CR>",
      desc = "開啟 LazyGit",
    } },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      if vim.g.vscode then
        return
      end

      -- 設定 lazygit 額外視窗樣式
      vim.g.lazygit_floating_window_winblend = 0
      vim.g.lazygit_floating_window_scaling_factor = 0.9
      vim.g.lazygit_use_neovim_remote = 1
    end,
  },
  {
    "kylechui/nvim-surround",
    version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    vscode = true,
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end,
  },
}

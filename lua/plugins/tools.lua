return { -- Peek Markdown 預覽 (LazyVim 沒有)
  {
    "toppair/peek.nvim",
    lazy = true,
    build = "deno task --quiet build:fast",
    ft = "markdown",
    config = function()
      if vim.g.vscode then
        return
      end

      require("peek").setup({
        -- 您的設定...
      })
    end,
  }, -- Obsidian 整合 (LazyVim 沒有)
  {
    "epwalsh/obsidian.nvim",
    version = "*", -- 使用最新穩定版本
    lazy = true,
    ft = "markdown", -- markdown 檔才會觸發
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim", "hrsh7th/nvim-cmp" },
    config = function()
      if vim.g.vscode then
        return
      end

      local home = vim.fn.expand("~")

      -- 設定 conceallevel
      vim.opt.conceallevel = 2

      require("obsidian").setup({
        workspaces = {
          {
            name = "personal",
            path = home .. "/Documents/Obsidian Vault", -- ✅ 改為正確斜線
          },
        },

        notes_subdir = "notes",

        daily_notes = {
          default = {},
          folder = "notes/dailies", -- ✅ 改為正確斜線
          date_format = "%Y-%m-%d",
          alias_format = "%B %-d, %Y",
          default_tags = { "daily-notes" },
          template = nil,
        },

        -- ✅ 安全地檢查 cmp 是否存在
        completion = {
          default = {},
          nvim_cmp = pcall(require, "cmp"),
          min_chars = 2,
        },

        mappings = {
          default = {},
          ["gf"] = {
            action = function()
              return require("obsidian").util.gf_passthrough()
            end,
            opts = {
              noremap = false,
              expr = true,
              buffer = true,
            },
          },
          ["<leader>ch"] = {
            action = function()
              return require("obsidian").util.toggle_checkbox()
            end,
            opts = {
              buffer = true,
            },
          },
          ["<CR>"] = {
            action = function()
              return require("obsidian").util.smart_action()
            end,
            opts = {
              buffer = true,
              expr = true,
            },
          },
        },

        new_notes_location = "notes_subdir",

        note_id_func = function(title)
          local suffix = ""
          if title ~= nil then
            suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
          else
            for _ = 1, 4 do
              suffix = suffix .. string.char(math.random(65, 90))
            end
          end
          return tostring(os.time()) .. "-" .. suffix
        end,

        wiki_link_func = function(opts)
          return require("obsidian.util").wiki_link_id_prefix(opts)
        end,

        preferred_link_style = "wiki",

        templates = {
          folder = vim.fn.expand("~/Documents/Obsidian Vault/templates"),
          date_format = "%Y-%m-%d",
          time_format = "%H:%M",
          substitutions = {
            date = "%Y-%m-%d",
            time = "%H:%M",
            user = os.getenv("USERNAME") or "TC",
          },
          default = {},
        },

        --  ui = {
        --    enable = false,
        --    checkboxes = {
        --      [" "] = { char = "☐", hl_group = "ObsidianTodo" },
        --      ["x"] = { char = "☑", hl_group = "ObsidianDone" },
        --      [">"] = { char = "➤", hl_group = "ObsidianRightArrow" },
        --      ["~"] = { char = "∼", hl_group = "ObsidianTilde" },
        --      ["!"] = { char = "!", hl_group = "ObsidianImportant" },
        --    },
        --    bullets = {
        --      char = "•",
        --      hl_group = "ObsidianBullet",
        --    },
        --  },

        attachments = {
          img_folder = "assets/imgs", -- 你自己的圖片存放資料夾
          default = {},
          confirm_img_paste = true, -- 貼上圖片前是否提示
          img_text_func = function(client, path)
            return string.format("![%s](%s)", path.name, path.url)
          end,
        },
      })
    end,
  },
  -- 修改 Telescope 設定 (LazyVim 有但要修改)
  {
    "nvim-lua/plenary.nvim",
    lazy = false, -- ✅ 立即加載，確保任何時候都能用
    vscode = true, -- ✅ 明確指定在 VSCode 中也會載入
  },
  {
    "nvim-telescope/telescope.nvim",
    vscode = true,
    version = false,
    lazy = false, -- 立即加載以避免命令延遲問題
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        enabled = vim.fn.executable("make") == 1,
      },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          prompt_prefix = "> ",
          selection_caret = "> ",
          path_display = { "smart" },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      })

      -- 載入 fzf 擴展
      pcall(require("telescope").load_extension, "fzf")
    end,
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find Files" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Live Grep" },
      { "fb", "Telescope buffers", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help Tags" },
    },
  },
}

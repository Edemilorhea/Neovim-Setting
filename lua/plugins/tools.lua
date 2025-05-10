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
    ft = "markdown", -- 只在 markdown 文件中加載
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      -- 可以添加全局快捷鍵
      -- { "<leader>on", "<cmd>ObsidianNew<CR>", desc = "新建 Obsidian 筆記" },
      -- { "<leader>ot", "<cmd>ObsidianToday<CR>", desc = "今日筆記" },
    },
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
            path = home .. "\\Documents\\Obsidian Vault",
          },
        },

        notes_subdir = "notes",

        daily_notes = {
          folder = "notes\\dailies",
          date_format = "%Y-%m-%d",
          alias_format = "%B %-d, %Y",
          default_tags = { "daily-notes" },
          template = nil,
        },

        completion = {
          nvim_cmp = true,
          min_chars = 2,
        },

        mappings = {
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
            date = os.date("%Y-%m-%d"),
            time = os.date("%H:%M"),
            user = os.getenv("USERNAME") or "TC",
          },
        },

        ui = {
          enable = true,
          checkboxes = {
            [" "] = {
              char = "☐",
              hl_group = "ObsidianTodo",
            },
            ["x"] = {
              char = "☑",
              hl_group = "ObsidianDone",
            },
            [">"] = {
              char = "➤",
              hl_group = "ObsidianRightArrow",
            },
            ["~"] = {
              char = "∼",
              hl_group = "ObsidianTilde",
            },
            ["!"] = {
              char = "!",
              hl_group = "ObsidianImportant",
            },
          },
          bullets = {
            char = "•",
            hl_group = "ObsidianBullet",
          },
        },

        attachments = {
          img_folder = "assets\\imgs",
          img_name_func = function()
            return string.format("%s-", os.time())
          end,
        },
      })
    end,
  }, -- 修改 Telescope 設定 (LazyVim 有但要修改)
  {
    "nvim-telescope/telescope.nvim",
    enabled = not vim.g.vscode, -- 在 VSCode 中禁用
    cmd = "Telescope",
    version = false, -- 使用最新版本
    lazy = false, -- 立即加載避免命令延遲問題
    dependencies = {
      "nvim-lua/plenary.nvim",
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
      { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help Tags" },
    },
  },
}

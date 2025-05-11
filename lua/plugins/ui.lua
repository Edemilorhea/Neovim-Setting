return { -- 覆蓋 LazyVim 的主題設定 (LazyVim 有但要修改)
  {
    "folke/tokyonight.nvim",
    optional = true,
    opts = {
      -- 您的主題設定
    },
    config = function(_, opts)
      if vim.g.vscode then
        return
      end

      require("tokyonight").setup(opts)
      vim.cmd("colorscheme tokyonight")
    end,
  }, -- 禁用或修改 LazyVim 的 Neo-tree
  {
    "nvim-neo-tree/neo-tree.nvim",
    event = "VeryLazy",
    vscode = false, -- ✅ 避免在 VSCode 中載入
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true,
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = false, -- ✅ 停用診斷，避免重繪干擾
        open_files_do_not_replace_types = { "terminal", "trouble", "qf" },
        sort_case_insensitive = false,
        sort_function = nil,
        default_component_configs = {
          container = { enable_character_fade = true },
          indent = {
            indent_size = 2,
            padding = 1,
            with_markers = true,
            indent_marker = "│",
            last_indent_marker = "└",
            highlight = "NeoTreeIndentMarker",
            with_expanders = nil,
            expander_collapsed = "",
            expander_expanded = "",
            expander_highlight = "NeoTreeExpander",
          },
          icon = {
            folder_closed = "",
            folder_open = "",
            folder_empty = "ﰊ",
            folder_empty_open = "", -- ✅ 新增缺漏欄位，避免警告
            default = "*",
            highlight = "NeoTreeFileIcon",
          },
          modified = { symbol = "[+]", highlight = "NeoTreeModified" },
          name = {
            trailing_slash = false,
            use_git_status_colors = true,
            highlight = "NeoTreeFileName",
          },
          git_status = {
            symbols = {
              added = "",
              modified = "",
              deleted = "✖",
              renamed = "",
              untracked = "",
              ignored = "",
              unstaged = "",
              staged = "",
              conflict = "",
            },
          },
        },
        window = {
          position = "left",
          width = 25,
          mapping_options = { noremap = true, nowait = true },
        },
        nesting_rules = {},
        filesystem = {
          filtered_items = {
            visible = false,
            hide_dotfiles = false,
            hide_gitignored = true,
            hide_hidden = true,
            hide_by_name = { "node_modules" },
            hide_by_pattern = {},
            always_show = {},
            never_show = {},
            never_show_by_pattern = {},
          },
          follow_current_file = { enabled = false }, -- ✅ 停用自動追蹤避免閃爍
          group_empty_dirs = false,
          hijack_netrw_behavior = "open_default",
          use_libuv_file_watcher = true, -- ✅ 使用更穩定的檔案監控方式
          window = {
            mappings = {
              ["<bs>"] = "navigate_up",
              ["."] = "set_root",
              ["H"] = "toggle_hidden",
              ["/"] = "fuzzy_finder",
              ["D"] = "fuzzy_finder_directory",
              ["#"] = "fuzzy_sorter",
              ["f"] = "filter_on_submit",
              ["<c-x>"] = "clear_filter",
              ["[g"] = "prev_git_modified",
              ["]g"] = "next_git_modified",
            },
            fuzzy_finder_mappings = {
              ["<down>"] = "move_cursor_down",
              ["<C-n>"] = "move_cursor_down",
              ["<up>"] = "move_cursor_up",
              ["<C-p>"] = "move_cursor_up",
            },
          },
        },
        buffers = {
          follow_current_file = { enabled = true },
          group_empty_dirs = true,
          show_unloaded = true,
          window = {
            mappings = {
              ["bd"] = "buffer_delete",
              ["<bs>"] = "navigate_up",
              ["."] = "set_root",
            },
          },
        },
        git_status = {
          window = {
            position = "float",
            mappings = {
              ["A"] = "git_add_all",
              ["gu"] = "git_unstage_file",
              ["ga"] = "git_add_file",
              ["gr"] = "git_revert_file",
              ["gc"] = "git_commit",
              ["gp"] = "git_push",
              ["gg"] = "git_commit_and_push",
            },
          },
        },
      })
    end,
  },
  -- {
  --     "nvim-tree/nvim-tree.lua",
  --     enable = false,
  --     dependencies = {"nvim-tree/nvim-web-devicons"},
  --     cmd = {"NvimTreeToggle", "NvimTreeFocus"},
  --     keys = {{
  --         "<leader>e",
  --         "<cmd>NvimTreeToggle<CR>",
  --         desc = "檔案瀏覽器"
  --     } -- 您可以添加其他快捷鍵...
  --     },
  --     config = function()
  --         if vim.g.vscode then
  --             return
  --         end
  --         local api = require("nvim-tree.api")
  --         require("nvim-tree").setup({
  --             sort = {
  --                 sorter = "case_sensitive"
  --             },
  --             view = {
  --                 width = 30,
  --                 side = "left",
  --                 preserve_window_proportions = true,
  --                 number = false,
  --                 relativenumber = false
  --             },
  --             renderer = {
  --                 group_empty = true,
  --                 icons = {
  --                     show = {
  --                         file = true,
  --                         folder = true,
  --                         folder_arrow = true,
  --                         git = true
  --                     }
  --                 }
  --             },
  --             update_focused_file = {
  --                 enable = true,
  --                 update_root = true
  --             },
  --             filters = {
  --                 dotfiles = false
  --             },
  --             git = {
  --                 enable = true,
  --                 ignore = false
  --             },
  --             actions = {
  --                 open_file = {
  --                     resize_window = true
  --                 }
  --             },
  --             on_attach = function(bufnr)
  --                 local function opts(desc)
  --                     return {
  --                         desc = "nvim-tree: " .. desc,
  --                         buffer = bufnr,
  --                         noremap = true,
  --                         silent = true,
  --                         nowait = true
  --                     }
  --                 end
  --                 api.config.mappings.default_on_attach(bufnr)
  --                 -- 自定快捷鍵
  --                 vim.keymap.set("n", "<C-t>", api.tree.change_root_to_parent, opts("返回上層資料夾"))
  --                 vim.keymap.set("n", "L", api.tree.change_root_to_node, opts("切換 root 到此資料夾"))
  --                 vim.keymap.set("n", "?", api.tree.toggle_help, opts("顯示說明"))
  --             end
  --         })
  --     end
  -- }, -- trouble.nvim 修改 (LazyVim 有但要修改設定)
  {
    "folke/trouble.nvim",
    optional = true,
    opts = {
      -- 您的自定設定
    },
  }, -- bufferline 修改 (LazyVim 有但要修改設定)
  {
    "akinsho/bufferline.nvim",
    optional = true,
    opts = function(_, opts)
      if vim.g.vscode then
        return opts
      end

      -- 合併您的設定與 LazyVim 的默認設定
      return vim.tbl_deep_extend("force", opts or {}, {
        options = {
          mode = "buffers", -- 也可設為 "tabs"
          diagnostics = "nvim_lsp",
          separator_style = "slant",
          show_buffer_close_icons = true,
          show_close_icon = false,
          always_show_bufferline = true,
        },
      })
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    optional = true, -- 標記為可選，避免在非 LazyVim 環境下出錯
    event = "VeryLazy",
    opts = function(_, opts)
      if vim.g.vscode then
        return opts
      end

      -- 完全替換 LazyVim 的 lualine 設定
      return {
        options = {
          theme = "dracula",
          section_separators = { "", "" },
          component_separators = { "", "" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },
          lualine_c = { "filename" },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      }
    end,
  },
}

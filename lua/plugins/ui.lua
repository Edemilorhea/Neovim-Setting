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
    end
}, -- 禁用或修改 LazyVim 的 Neo-tree
{
    "nvim-neo-tree/neo-tree.nvim",
    optional = true,
    opts = function(_, opts)
        if vim.g.vscode then
            return opts
        end

        -- 調整 Neo-tree 配置以匹配之前的 nvim-tree 體驗
        return vim.tbl_deep_extend("force", opts, {
            close_if_last_window = true,
            window = {
                width = 30,
                position = "left"
            },
            filesystem = {
                filtered_items = {
                    hide_dotfiles = false, -- 對應 nvim-tree 的 dotfiles = false
                    hide_gitignored = false -- 對應 nvim-tree 的 git.ignore = false
                },
                follow_current_file = {
                    enabled = true -- 對應 nvim-tree 的 update_focused_file.enable
                },
                use_libuv_file_watcher = true
            },
            event_handlers = {
                -- 保持與您習慣的行為一致的其他事件處理程序
            },
            default_component_configs = {
                icon = {
                    folder_closed = "",
                    folder_open = "",
                    folder_empty = ""
                },
                git_status = {
                    symbols = {
                        -- 配置 git 圖標
                    }
                }
            }
        })
    end,
    -- 添加您習慣的快捷鍵
    keys = function(_, keys)
        -- 保留原有的按鍵，添加自定義按鍵
        return vim.list_extend(keys or {}, { -- 類似於您在 nvim-tree 中使用的自定義按鍵
        {
            "<C-t>",
            function()
                vim.cmd("Neotree navigate parent")
            end,
            desc = "返回上層資料夾"
        }, {
            "L",
            function()
                vim.cmd("Neotree action=focus_node")
            end,
            desc = "切換 root 到此資料夾"
        }, {
            "?",
            function()
                vim.cmd("Neotree help")
            end,
            desc = "顯示說明"
        }})
    end
}, -- {
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
    }
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
                always_show_bufferline = true
            }
        })
    end
}, {
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
                section_separators = {"", ""},
                component_separators = {"", ""}
            },
            sections = {
                lualine_a = {"mode"},
                lualine_b = {"branch"},
                lualine_c = {"filename"},
                lualine_x = {"encoding", "fileformat", "filetype"},
                lualine_y = {"progress"},
                lualine_z = {"location"}
            }
        }
    end
}}

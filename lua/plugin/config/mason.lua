-- plugin/config/lsp.lua
local M = {}
local mason_enabled = false

function M.setup()
    -- ==================== Treesitter 配置 ====================
    local ts_ok, treesitter = pcall(require, "nvim-treesitter.configs")
    if ts_ok then
        treesitter.setup({
            ensure_installed = { "html", "javascript", "vue", "css", "python", "c_sharp", "lua" },
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
    end

    -- ==================== nvim-cmp 配置 ====================
    local cmp_ok, cmp = pcall(require, "cmp")
    if cmp_ok then
        cmp.setup({
            snippet = {
                expand = function(args)
                    local luasnip_ok, luasnip = pcall(require, "luasnip")
                    if luasnip_ok then
                        luasnip.lsp_expand(args.body)
                    end
                end,
            },
            mapping = cmp.mapping.preset.insert({
                -- Enter 鍵：補全時選擇，否則換行
                ["<CR>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.confirm({ select = true })
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                -- Tab 鍵：補全時選下一個，否則照原本作用（例如縮排）
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                -- Shift+Tab 鍵：補全時選上一個，否則照原本作用
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                -- Ctrl+Space：打開補全（不需判斷）
                ["<C-l>"] = cmp.mapping.complete(),
                -- Ctrl+y：補全時確認選擇，否則略過
                ["<C-y>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.confirm({ select = true })
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            }),
            sources = cmp.config.sources(
                { {
                    name = "nvim_lsp",
                }, {
                    name = "luasnip",
                } },
                { {
                    name = "buffer",
                }, {
                    name = "path",
                } }
            ),
        })
    end

    -- ==================== null-ls 配置 ====================
    local null_ok, nullls_config = pcall(require, "plugin.config.null-ls")
    if null_ok then
        nullls_config.setup()
    end

    -- ==================== LSP/Mason 配置 ====================
    M.enable_lsp()
end

-- 啟用 LSP 服務
function M.enable_lsp()
    if mason_enabled then return end

    -- 載入必要插件
    local status_mason, mason = pcall(require, "mason")
    local status_mason_lspconfig, mason_lspconfig = pcall(require, "mason-lspconfig")
    local status_lspconfig, lspconfig = pcall(require, "lspconfig")
    if not (status_mason and status_mason_lspconfig and status_lspconfig) then
        vim.notify("[Mason] mason/mason-lspconfig/lspconfig 載入失敗", vim.log.levels.ERROR)
        return
    end

    -- 設定 mason
    mason.setup({
        ui = {
            border = "rounded",
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗",
            },
        },
    })

    -- 設定 mason-lspconfig
    mason_lspconfig.setup({
        ensure_installed = {
            "lua_ls", "jsonls", "ts_ls", "html", "cssls", "volar",
            "emmet_ls", "eslint", "omnisharp", "pyright", "marksman",
        },
        automatic_installation = false,
    })

    -- 配置診斷顯示
    vim.diagnostic.config({
        virtual_text = true,      -- 啟用行內診斷文本
        signs = true,             -- 啟用診斷標誌
        underline = true,         -- 啟用診斷文本下劃線
        update_in_insert = false, -- 插入模式下不更新診斷
        severity_sort = true,     -- 按嚴重程度排序診斷
        float = {
            border = "rounded",
            source = "always",
        },
    })

    -- 通用 on_attach 設定
    local on_attach = function(client, bufnr)
        local opts = { buffer = bufnr, remap = false }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

        -- 啟用 inline signature 提示
        local sig_ok, lsp_signature = pcall(require, "lsp_signature")
        if sig_ok then
            lsp_signature.on_attach({
                hint_enable = true,
                floating_window = false,
                hint_prefix = "💡 ",
            }, bufnr)
        end
    end

    -- 改用 dotnet 執行 dll 版本，避免 INVALID_SERVER_MESSAGE
    local ok_ext, omnisharp_extended = pcall(require, "omnisharp_extended")
    local omnisharp_dll = vim.fn.stdpath("data") .. "/mason/packages/omnisharp/libexec/OmniSharp.dll"
    local omnisharp_cmd = { "dotnet", omnisharp_dll }

    lspconfig.omnisharp.setup({
        cmd = omnisharp_cmd,
        root_dir = lspconfig.util.root_pattern("*.csproj", "*.sln", ".git"),
        enable_roslyn_analyzers = true,
        enable_import_completion = true,
        organize_imports_on_format = true,
        on_attach = on_attach,
        handlers = ok_ext and {
            ["textDocument/definition"] = omnisharp_extended.definition_handler,
            ["textDocument/typeDefinition"] = omnisharp_extended.type_definition_handler,
            ["textDocument/references"] = omnisharp_extended.references_handler,
            ["textDocument/implementation"] = omnisharp_extended.implementation_handler,
        } or nil,
        settings = {
            FormattingOptions = { EnableEditorConfigSupport = true },
            RoslynExtensionsOptions = { EnableAnalyzersSupport = true },
            Sdk = { IncludePrereleases = true },
        },
        capabilities = {
            workspace = {
                didChangeWatchedFiles = { dynamicRegistration = false },
                workspaceFolders = false,
            },
        },
    })

    -- Lua 語言伺服器設定
    lspconfig.lua_ls.setup({
        on_attach = on_attach,
        settings = {
            Lua = {
                diagnostics = {
                    globals = { "vim" },
                },
            },
        },
    })

    -- Markdown 語言伺服器
    lspconfig.marksman.setup({
        on_attach = on_attach,
        filetypes = { "markdown" },
    })

    -- 其他常見 LSP 設定
    local servers = { "jsonls", "ts_ls", "html", "cssls", "volar", "emmet_ls", "eslint", "pyright" }
    for _, server in ipairs(servers) do
        lspconfig[server].setup({ on_attach = on_attach })
    end

    mason_enabled = true
    vim.notify("[Mason] 啟用成功")
end

-- 停用 LSP 服務
function M.disable_lsp()
    if not mason_enabled then return end
    for _, client in pairs(vim.lsp.get_clients()) do -- 修正此行
        client.stop()
    end
    mason_enabled = false
    vim.notify("[Mason] 所有 LSP 已停止")
end

-- 切換 LSP 服務狀態
function M.toggle_lsp()
    if mason_enabled then M.disable_lsp() else M.enable_lsp() end
end

-- 兼容舊代碼的函數
function M.enable()
    return M.enable_lsp()
end

function M.disable()
    return M.disable_lsp()
end

function M.toggle()
    return M.toggle_lsp()
end

-- 自動啟動（非 VSCode 環境）
if not vim.g.vscode then
    vim.schedule(function()
        M.setup()
    end)
end

-- 註冊切換命令
vim.api.nvim_create_user_command("MasonToggle", function()
    require("plugin.config.lsp").toggle_lsp()
end, {})

return M

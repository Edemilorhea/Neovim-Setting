-- pluginlist/mason.lua
-- 控制 Mason 是否已啟用的標誌 
local mason_enabled = false

-- 定義一個函數來啟用 Mason 和 LSP 
local function enable_mason_and_lsp()
    if mason_enabled then
        print("Mason 和 LSP 已經啟用，跳過...")
        return
    end

    print("啟用 Mason 和相關 LSP...")

    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")
    local lspconfig = require("lspconfig")

    -- 初始化 Mason
    mason.setup({
        ui = {
            border = "rounded",
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗"
            }
        }
    })

    mason_lspconfig.setup({
        ensure_installed = {"lua_ls", "jsonls", "ts_ls", "omnisharp", "pylsp"},
        automatic_installation = false
    })

    -- 通用的 on_attach 函數 
    local on_attach = function(client, bufnr)
        print(string.format("%s 已附加到緩衝區: %d", client.name, bufnr))
        local opts = {
            buffer = bufnr,
            remap = false
        }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    end

    -- 使用相對路徑構造 OmniSharp 的 cmd
    local mason_path = vim.fn.stdpath("data") .. "/mason/bin/omnisharp" .. (vim.fn.has("win32") == 1 and ".cmd" or "")
    mason_path = mason_path:gsub("/", "\\")

    -- OmniSharp 特定配置
    lspconfig.omnisharp.setup({
        cmd = {mason_path},
        root_dir = lspconfig.util.root_pattern("*.csproj", "*.sln", ".git"),
        enable_roslyn_analyzers = true,
        enable_import_completion = true,
        organize_imports_on_format = true,
        on_attach = on_attach
    })

    -- 自動設置其他 LSP
    mason_lspconfig.setup_handlers({
        function(server_name)
            if server_name ~= "omnisharp" then
                lspconfig[server_name].setup({
                    on_attach = on_attach
                })
            end
        end,
        ["lua_ls"] = function()
            lspconfig.lua_ls.setup({
                on_attach = on_attach,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = {"vim"}
                        }
                    }
                }
            })
        end
    })

    mason_enabled = true
    print("Mason 和 LSP 已成功啟用")
end

-- 定義一個函數來停用 Mason 和 LSP 
local function disable_mason_and_lsp()
    if not mason_enabled then
        print("Mason 和 LSP 已經停用，跳過...")
        return
    end

    print("停用 Mason 和相關 LSP...")

    -- 停止所有活躍的 LSP 客戶端 
    for _, client in pairs(vim.lsp.get_active_clients()) do
        client.stop()
    end

    mason_enabled = false
    print("Mason 和 LSP 已成功停用")
end

-- 提供公開的接口，供外部調用 
return {
    enable = enable_mason_and_lsp,
    disable = disable_mason_and_lsp
}


local M = {}

local required_tools = {
  -- 必要工具
  { cmd = "rg", name = "ripgrep", install = "scoop install ripgrep", desc = "快速搜尋工具 (用於 Telescope/grep)" },
  { cmd = "fd", name = "fd", install = "scoop install fd", desc = "快速檔案搜尋工具 (用於 Telescope)" },
  { cmd = "lazygit", name = "lazygit", install = "scoop install lazygit", desc = "Git TUI 工具" },

  -- LSP 相關
  { cmd = "node", name = "Node.js", install = "scoop install nodejs", desc = "執行 JavaScript LSP servers" },

  -- 格式化工具
  { cmd = "prettier", name = "Prettier", install = "npm install -g prettier", desc = "程式碼格式化工具" },

  -- 選用但建議安裝
  { cmd = "fzf", name = "fzf", install = "scoop install fzf", desc = "模糊搜尋工具 (選用)", optional = true },
  { cmd = "gh", name = "GitHub CLI", install = "scoop install gh", desc = "GitHub 命令列工具 (選用)", optional = true },
}

function M.check()
  local missing_required = {}
  local missing_optional = {}

  for _, tool in ipairs(required_tools) do
    if vim.fn.executable(tool.cmd) == 0 then
      if tool.optional then
        table.insert(missing_optional, tool)
      else
        table.insert(missing_required, tool)
      end
    end
  end

  if #missing_required > 0 then
    vim.notify("⚠️  缺少必要工具：", vim.log.levels.WARN)
    for _, tool in ipairs(missing_required) do
      vim.notify(
        string.format("  • %s (%s)\n    安裝: %s", tool.name, tool.desc, tool.install),
        vim.log.levels.INFO
      )
    end
  end

  if #missing_optional > 0 then
    vim.notify("ℹ️  缺少選用工具（建議安裝）：", vim.log.levels.INFO)
    for _, tool in ipairs(missing_optional) do
      vim.notify(
        string.format("  • %s (%s)\n    安裝: %s", tool.name, tool.desc, tool.install),
        vim.log.levels.INFO
      )
    end
  end

  if #missing_required == 0 and #missing_optional == 0 then
    vim.notify("✓ 所有依賴工具已安裝", vim.log.levels.INFO)
  end
end

-- 手動檢查命令
vim.api.nvim_create_user_command("CheckDeps", function()
  M.check()
end, { desc = "檢查缺少的依賴工具" })

return M

if vim.g.vscode then
    vim.notify = function(msg, level)
      vim.api.nvim_echo({{msg, "None"}}, true, {})
    end
  end
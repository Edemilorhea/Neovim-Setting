local M = {}

function M.setup()
    require("ufo").setup({
        provider_selector = function(_, _, _)
            return {"treesitter", "indent"}
        end
    })
end

return M

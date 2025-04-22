local M = {}

function M.setup()
    require("im_select").setup({
        default_im_select = "1033",
        defalut_input_method = "1028"
    })
end

return M

local config = function()
    local notify = require("notify")

    notify.setup({
        background_colour = "Normal",
        max_width = 60,
    })

    vim.notify = notify
end

return {
    {
        "rcarriga/nvim-notify",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = config,
    },
}

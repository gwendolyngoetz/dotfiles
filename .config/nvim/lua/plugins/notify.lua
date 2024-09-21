return {
    {
        "rcarriga/nvim-notify",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function(_, opts)
            local notify = require("notify")
            notify.setup(opts)
            vim.notify = notify
        end,
        opts = {
            background_colour = "Normal",
            max_width = 60,
        }
    },
}

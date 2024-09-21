local icons = require("config.settings").icons

return {
    {
        "lewis6991/gitsigns.nvim",
        opts = {
            signs = {
                add = {
                    text = icons.git.add,
                },
                change = {
                    text = icons.git.change,
                },
                delete = {
                    text = icons.git.delete,
                },
                topdelete = {
                    text = icons.git.topdelete,
                },
                changedelete = {
                    text = icons.git.changedelete,
                },
            },
        }
    },
}

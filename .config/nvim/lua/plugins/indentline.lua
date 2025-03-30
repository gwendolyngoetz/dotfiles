return {
    {
        "lukas-reineke/indent-blankline.nvim",
        tag = "v3.9.0",
        main = "ibl",
        opts = {
            indent = {
                char = require("config.settings").icons.indent.blankline_char,
            },
            exclude = {
                filetypes = {
                    "help",
                    "NvimTree",
                    "neo-tree",
                },
                buftypes = {
                    "terminal",
                    "nofile",
                },
            },
            scope = {
                char = require("config.settings").icons.indent.blankline_char,
                show_start = false,
                show_end = false,
            },
        }
    },
}

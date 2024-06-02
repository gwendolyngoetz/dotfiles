local config = function()
    local icons = require("config.settings").icons

    require("ibl").setup({
        indent = {
            char = icons.indent.blankline_char,
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
            char = icons.indent.blankline_char,
            show_start = false,
            show_end = false,
        },
    })
end

return {
    {
        "lukas-reineke/indent-blankline.nvim",
        tag = "v3.6.2",
        config = config,
    },
}

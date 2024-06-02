return {
    {
        "folke/tokyonight.nvim",
        commit = "7e5ef71",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("tokyonight-night")
        end,
    },
}

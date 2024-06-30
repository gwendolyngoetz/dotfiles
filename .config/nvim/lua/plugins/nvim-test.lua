local config = function()
    require("nvim-test").setup({
        term = "toggleterm",
        termOpts = {
            direction = "horizontal",
            width = 40,
            height = 15,
        },
    })
end

return {
    {
        "klen/nvim-test",
        config = config,
        dependencies = {
            {
                "akinsho/toggleterm.nvim",
            },
        },
    },
}

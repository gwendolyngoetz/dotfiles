return {
    {
        "klen/nvim-test",
        dependencies = {
            {
                "akinsho/toggleterm.nvim",
            },
        },
        opts = {
            term = "toggleterm",
            termOpts = {
                direction = "horizontal",
                width = 40,
                height = 15,
            }
        }
    },
}

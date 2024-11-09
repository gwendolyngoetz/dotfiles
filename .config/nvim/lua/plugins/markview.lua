return {
    {
        "OXY2DEV/markview.nvim",
        lazy = false,
        dependencies = {
            -- You will not need this if you installed the
            -- parsers manually
            -- Or if the parsers are in your $RUNTIMEPATH
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons"
        },
        keys = {
            { "<leader>mm", "<cmd>Markview toggleAll<CR>", { desc = "Toggle Markview" }},
        }
    }
}

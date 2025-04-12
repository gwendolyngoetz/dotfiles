return {
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            "Issafalcon/neotest-dotnet"
        },
        config = function(_, opts)
            require("neotest").setup({
                adapters = {
                    require('neotest-dotnet')
                }
            })
        end,
        keys = {
            { "<leader>tr", "<cmd>lua require('neotest').run.run()<CR>",        { desc = "[T]est [R]un" } },
            { "<leader>tt", "<cmd>lua require('neotest').summary.toggle()<CR>", { desc = "[T]est [T]oggle" } },
        }
    }
}

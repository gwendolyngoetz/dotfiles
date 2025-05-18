return {
    "folke/which-key.nvim",
    enabled = false,
    event = "VeryLazy",
    ---@module "which-key"
    ---@type wk.Config
    opts = {
        spec = {
            { "<leader>l",  group = "LSP", },
            { "<leader>lr", "<cmd>",       desc = "FF" }
        }
    },
    keys = {
        {
            "<leader>?",
            function()
                require("which-key").show({ global = false })
            end,
            desc = "Buffer Local Keymaps (which-key)"
        }
    }
}

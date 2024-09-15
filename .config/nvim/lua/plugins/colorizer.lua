return {
    {
        "NvChad/nvim-colorizer.lua",
        keys = {
            { "<C-c>", "<cmd>ColorizerToggle<CR>", desc = "Toggle Colorizer" }
        },
        opts = {
            filetypes = {
                "css",
                "javascript",
                "html",
            },
            user_default_options = {
                rgb_fn = true,
                hsl_fn = true,
            }
        }
    },
}

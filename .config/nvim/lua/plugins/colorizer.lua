return {
    {
        "catgoose/nvim-colorizer.lua",
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
                css = true,
                names = false
            }
        }
    },
}

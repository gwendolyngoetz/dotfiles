local config = function()
    require("colorizer").setup({
        filetypes = {
            "css",
            "javascript",
            "html",
        },
        user_default_options = {
            rgb_fn = true,
            hsl_fn = true,
        }
    })
end

return {
    {
        "NvChad/nvim-colorizer.lua",
        config = config,
        keys = {
            { "<C-c>", "<cmd>ColorizerToggle<CR>", desc = "Toggle Colorizer" }
        }
    },
}

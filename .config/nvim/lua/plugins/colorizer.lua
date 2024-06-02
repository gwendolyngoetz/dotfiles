local config = function()
    require("colorizer").setup({
        "css",
        "javascript",
        "html",
    }, {
        rgb_fn = true,
        hsl_fn = true,
    })
end

return {
    {
        "norcalli/nvim-colorizer.lua",
        commit = "a065833",
        config = config,
    },
}

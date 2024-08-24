local config = function()
    require("telescope").load_extension("harpoon")
    require("harpoon"):setup()
end

return {
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = config,
    },
}

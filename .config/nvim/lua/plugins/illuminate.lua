local config = function()
    require("illuminate").configure({
        filetypes_denylist = {
            "harpoon",
            "mason",
            "neo-tree",
            "NvimTree",
            "TelescopePrompt",
            "toggleterm",
            "Trouble",
        },
    })
end

return {
    {
        "RRethy/vim-illuminate",
        commit = "5eeb795",
        config = config,
    },
}

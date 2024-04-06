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
        commit = "305bf07",
        config = config,
    },
}

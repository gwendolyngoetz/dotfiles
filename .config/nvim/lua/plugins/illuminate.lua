return {
    {
        "RRethy/vim-illuminate",
        config = function(_, opts)
            require('illuminate').configure(opts)
        end,
        opts = {
            filetypes_denylist = {
                "harpoon",
                "mason",
                "neo-tree",
                "NvimTree",
                "TelescopePrompt",
                "toggleterm",
                "Trouble",
            },
        }
    },
}

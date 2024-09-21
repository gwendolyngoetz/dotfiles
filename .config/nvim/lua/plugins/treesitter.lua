local config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
end

return {
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
    },
    {
        "JoosepAlviste/nvim-ts-context-commentstring",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = config,
        opts = {
            auto_install = true,
            sync_install = false,
            ensure_installed = {
                "bash",
                "c_sharp",
                "cmake",
                "css",
                "go",
                "hcl",
                "html",
                "java",
                "javascript",
                "json",
                "lua",
                "python",
                "markdown",
                "ocaml",
                "scala",
                "sql",
                "vimdoc",
                "vim",
                "yaml",
            },
            ignore_install = { "" },
            modules = {},
            highlight = {
                enable = true,
                disable = { "css" },
            },
            autopairs = {
                enable = true,
            },
            indent = {
                enable = true,
                disable = { "python", "css" },
            },
        }
    },
}

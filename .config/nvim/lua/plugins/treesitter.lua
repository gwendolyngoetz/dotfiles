local config = function()
    require("nvim-treesitter.configs").setup({
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
    })
end

return {
    {
        "nvim-treesitter/nvim-treesitter",
        commit = "a80fe08",
        build = ":TSUpdate",
        config = config,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        commit = "fd41b7c",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
    },
    {
        "JoosepAlviste/nvim-ts-context-commentstring",
        commit = "cb06438",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
    },
}

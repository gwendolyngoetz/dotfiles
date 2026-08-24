local config = function(_, opts)
    require("nvim-treesitter").setup()

    require("nvim-treesitter").install({
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
        "markdown",
        "markdown_inline",
        "ocaml",
        "python",
        "scala",
        "sql",
        "vim",
        "vimdoc",
        "yaml",
    })

    local no_highlight = { css = true }
    local no_indent = { python = true, css = true }

    vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
            local lang = vim.treesitter.language.get_lang(args.match)
            if not lang or not vim.treesitter.language.add(lang) then
                return
            end
            if not no_highlight[lang] then
                vim.treesitter.start(args.buf, lang)
            end
            if not no_indent[lang] then
                vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end
        end,
    })
end

return {
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("nvim-treesitter-textobjects").setup()
        end,
    },
    {
        "JoosepAlviste/nvim-ts-context-commentstring",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        branch = "main",
        build = ":TSUpdate",
        config = config,
    },
}

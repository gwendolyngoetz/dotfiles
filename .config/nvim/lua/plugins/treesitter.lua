local config = function()
  require("nvim-treesitter.configs").setup({
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
    commit = "46dee16",
    build = ":TSUpdate",
    config = config,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    commit = "5627216",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  },
}

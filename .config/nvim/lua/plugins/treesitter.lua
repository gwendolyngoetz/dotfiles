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
    commit = "e49f1e8",
    build = ":TSUpdate",
    config = config,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    commit = "0e2d5bd",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    commit = "1277b4a",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  },
}

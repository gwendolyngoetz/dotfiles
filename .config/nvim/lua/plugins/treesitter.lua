local config = function()
  local helpers = require("config.helpers")

  local configs = helpers.require("nvim-treesitter.configs")
  if not configs then
    return
  end

  configs.setup({
    ensure_installed = {
      "bash",
      "c_sharp",
      "cmake",
      "css",
      "go",
      "hcl",
      "html",
      "java",
      "json",
      "lua",
      "markdown",
      "scala",
      "yaml",
    },
    ignore_install = { "" }, -- List of parsers to ignore installing
    highlight = {
      enable = true, -- false will disable the whole extension
      disable = { "css" }, -- list of language that will be disabled
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
    commit = "079a50f6",
    build = ":TSUpdate",
    config = config,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    commit = "542e087",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  },
}

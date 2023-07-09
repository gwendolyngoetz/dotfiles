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

local features = require("config.features")

return {
  {
    "nvim-treesitter/nvim-treesitter",
    enabled = features.treesitter,
    commit = "d9104a1",
    build = ":TSUpdate",
    config = config,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    enabled = features.treesitter,
    commit = "b55fe61",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  },
}

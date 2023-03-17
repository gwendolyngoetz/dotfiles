local features = require("config.features")

return {
  {
    "nvim-lua/popup.nvim",
    commit = "b7404d3",
  },
  {
    "nvim-lua/plenary.nvim",
    commit = "253d348",
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    enabled = features.treesitter,
    commit = "729d83e",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  },
  {
    "kyazdani42/nvim-web-devicons",
    commit = "4af94fe",
  },
  {
    "famiu/bufdelete.nvim",
    commit = "8933abc",
  },
}

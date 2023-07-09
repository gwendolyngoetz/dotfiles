local features = require("config.features")

return {
  {
    "nvim-lua/popup.nvim",
    commit = "b7404d3",
  },
  {
    "nvim-lua/plenary.nvim",
    commit = "bda256f",
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    enabled = features.treesitter,
    commit = "7f62520",
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
    commit = "07d1f8b",
  },
}

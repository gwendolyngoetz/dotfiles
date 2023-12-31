local config = function()
  local icons = require("config.settings").icons

  require("gitsigns").setup({
    signs = {
      add = {
        text = icons.git.add,
      },
      change = {
        text = icons.git.change,
      },
      delete = {
        text = icons.git.delete,
      },
      topdelete = {
        text = icons.git.topdelete,
      },
      changedelete = {
        text = icons.git.changedelete,
      },
    },
  })
end

return {
  {
    "lewis6991/gitsigns.nvim",
    commit = "d195f0c",
    config = config,
  },
}

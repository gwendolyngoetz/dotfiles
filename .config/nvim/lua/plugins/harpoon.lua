local config = function()
  local helpers = require("config.helpers")

  local harpoon = helpers.require("harpoon")
  if not harpoon then
    return
  end

  harpoon.setup()
end

local features = require("config.features")

return {
  {
    "ThePrimeagen/harpoon",
    enabled = features.harpoon,
    commit = "f7040fd",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = config,
  },
}

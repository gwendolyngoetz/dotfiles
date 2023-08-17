local config = function()
  local helpers = require("config.helpers")

  local harpoon = helpers.require("harpoon")
  if not harpoon then
    return
  end

  harpoon.setup()
end

return {
  {
    "ThePrimeagen/harpoon",
    commit = "21f4c47",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = config,
  },
}

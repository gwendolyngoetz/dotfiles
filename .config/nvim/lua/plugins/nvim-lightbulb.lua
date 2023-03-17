local config = function()
  local helpers = require("config.helpers")

  local lightbulb = helpers.require("nvim-lightbulb")
  if not lightbulb then
    return
  end

  lightbulb.setup({
    autocmd = {
      enabled = true,
    },
    float = {
      enabled = true,
    },
  })
end

local features = require("config.features")

return {
  {
    "kosayoda/nvim-lightbulb",
    enabled = features.nvim_lightbulb,
    commit = "56b9ce3",
    dependencies = {
      "antoinemadec/FixCursorHold.nvim",
    },
    config = config,
  },
}

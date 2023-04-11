local config = function()
  local helpers = require("config.helpers")

  local twilight = helpers.require("twilight")
  if not twilight then
    return
  end

  twilight.setup({})
end

local features = require("config.features")

return {
  {
    "folke/twilight.nvim",
    enabled = features.twilight,
    commit = "2e13bd1",
    config = config,
  },
}

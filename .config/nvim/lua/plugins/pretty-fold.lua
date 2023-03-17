local config = function()
  local helpers = require("config.helpers")

  local prettyfold = helpers.require("pretty-fold")
  if not prettyfold then
    return
  end

  prettyfold.setup()
end

local features = require("config.features")

return {
  {
    "anuvyklack/pretty-fold.nvim",
    enabled = features.pretty_fold,
    commit = "a7d8b42",
    config = config,
  },
}

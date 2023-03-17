local config = function()
  local helpers = require("config.helpers")

  local autotag = helpers.require("nvim-ts-autotag")
  if not autotag then
    return
  end

  autotag.setup()
end

local features = require("config.features")

return {
  {
    "windwp/nvim-ts-autotag",
    enabled = features.autotag,
    commit = "fdefe46",
    config = config,
  },
}

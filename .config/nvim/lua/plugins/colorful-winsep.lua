local config = function()
  local helpers = require("config.helpers")

  local winsep = helpers.require("colorful-winsep")
  if not winsep then
    return
  end

  winsep.setup({})
end

local features = require("config.features")

return {
  {
    "nvim-zh/colorful-winsep.nvim",
    enabled = features.colorful_winsep,
    commit = "4958d55",
    config = config,
  },
}

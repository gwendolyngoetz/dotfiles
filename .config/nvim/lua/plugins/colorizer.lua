local config = function()
  local helpers = require("config.helpers")
  local colorizer = helpers.require("colorizer")

  if not colorizer then
    return
  end

  colorizer.setup({
    "css",
    "javascript",
    html = {
      mode = "foreground",
    },
  })
end

local features = require("config.features")

return {
  {
    "norcalli/nvim-colorizer.lua",
    enabled = features.colorizer,
    commit = "36c610a",
    config = config,
  },
}

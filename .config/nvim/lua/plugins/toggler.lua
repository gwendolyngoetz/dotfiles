local config = function()
  local helpers = require("config.helpers")

  local toggler = helpers.require("nvim-toggler")
  if not toggler then
    return
  end

  toggler.setup({
    inverses = {
      ["True"] = "False",
    },
  })
end

local features = require("config.features")

return {
  {
    "nguyenvukhang/nvim-toggler",
    enabled = features.toggler,
    commit = "a9d320d",
    config = config,
  },
}

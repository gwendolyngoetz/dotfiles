local config = function()
  local helpers = require("config.helpers")

  local nvim_test = helpers.require("nvim-test")
  if not nvim_test then
    return
  end

  nvim_test.setup({
    term = "toggleterm",
    termOpts = {
      direction = "horizontal",
      width = 40,
      height = 15,
    },
  })
end

local features = require("config.features")

return {
  {
    "klen/nvim-test",
    enabled = features.testing.nvim_test,
    commit = "4e30d07",
    config = config,
  },
}
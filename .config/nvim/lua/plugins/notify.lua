local config = function()
  local helpers = require("config.helpers")

  local notify = helpers.require("notify")
  if not notify then
    return
  end

  notify.setup({
    background_colour = "Normal",
  })

  vim.notify = notify
end

local features = require("config.features")

return {
  {
    "rcarriga/nvim-notify",
    enabled = features.notify,
    commit = "281e4d7",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = config,
  },
}

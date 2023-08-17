local config = function()
  local helpers = require("config.helpers")

  local notify = helpers.require("notify")
  if not notify then
    return
  end

  notify.setup({
    background_colour = "Normal",
    max_width = 40,
  })

  vim.notify = notify
end

return {
  {
    "rcarriga/nvim-notify",
    commit = "ea9c8ce",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = config,
  },
}

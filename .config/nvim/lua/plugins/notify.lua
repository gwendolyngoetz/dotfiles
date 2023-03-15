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

return {
  {
    "rcarriga/nvim-notify",
    commit = "281e4d7",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = config,
  },
}

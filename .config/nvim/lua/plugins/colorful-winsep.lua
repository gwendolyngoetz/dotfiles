local config = function()
  local helpers = require("config.helpers")

  local winsep = helpers.require("colorful-winsep")
  if not winsep then
    return
  end

  winsep.setup({})
end

return {
  {
    "nvim-zh/colorful-winsep.nvim",
    commit = "4958d55",
    config = config,
  },
}

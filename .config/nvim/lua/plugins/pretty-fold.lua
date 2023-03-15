local config = function()
  local helpers = require("config.helpers")

  local prettyfold = helpers.require("pretty-fold")
  if not prettyfold then
    return
  end

  prettyfold.setup()
end

return {
  {
    "anuvyklack/pretty-fold.nvim",
    commit = "a7d8b42",
    config = config,
  },
}

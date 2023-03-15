local config = function()
  local helpers = require("config.helpers")

  local autotag = helpers.require("nvim-ts-autotag")
  if not autotag then
    return
  end

  autotag.setup()
end

return {
  {
    "windwp/nvim-ts-autotag",
    commit = "fdefe46",
    config = config,
  },
}

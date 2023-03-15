local config = function()
  local helpers = require("config.helpers")

  local impatient = helpers.require("impatient")
  if not impatient then
    return
  end

  impatient.enable_profile()
end

return {
  {
    "lewis6991/impatient.nvim",
    enabled = false,
    commit = "c90e273",
    config = config,
  },
}

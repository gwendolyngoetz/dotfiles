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

return {
  {
    "klen/nvim-test",
    commit = "e06f3d0",
    config = config,
  },
}

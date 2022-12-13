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

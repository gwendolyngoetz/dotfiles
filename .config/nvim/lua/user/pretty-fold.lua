local helpers = require("helpers")

local prettyfold = helpers.require("pretty-fold")
if not prettyfold then
  return
end

prettyfold.setup()

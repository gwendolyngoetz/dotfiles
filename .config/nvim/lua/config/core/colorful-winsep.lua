local helpers = require("config.helpers")

local winsep = helpers.require("colorful-winsep")
if not winsep then
  return
end

winsep.setup({})

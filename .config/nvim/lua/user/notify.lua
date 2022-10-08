local helpers = require("helpers")

local notify = helpers.require("notify")
if not notify then
  return
end

notify.setup {
  background_colour = "Normal"
}

vim.notify = notify

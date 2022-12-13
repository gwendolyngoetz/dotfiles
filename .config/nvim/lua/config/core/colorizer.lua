local helpers = require("config.helpers")

local colorizer = helpers.require("colorizer")
if not colorizer then
  return
end

colorizer.setup({
  "css",
  "javascript",
  html = {
    mode = "foreground",
  },
})

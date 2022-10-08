local helpers = require("helpers")
local autotag = helpers.require("nvim-ts-autotag")
if not autotag then
  return
end

autotag.setup()

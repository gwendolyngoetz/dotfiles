local helpers = require("helpers")

local impatient = helpers.require("impatient")
if not impatient then
  return
end

impatient.enable_profile()

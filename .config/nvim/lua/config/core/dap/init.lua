local helpers = require("config.helpers")

local dap = helpers.require("dap")
if not dap then
  return
end

require("config.core.dap.dapui")
require("config.core.dap.adapters")

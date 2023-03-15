local helpers = require("config.helpers")
local dap = require("plugins.dap.dap")
local dapui = require("plugins.dap.dapui")

return helpers.tbl_merge(dap, dapui)

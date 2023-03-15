local helpers = require("config.helpers")
local alpha = require("plugins.dashboard.alpha")
local dashboard = require("plugins.dashboard.dashboard-nvim")

return helpers.tbl_merge(alpha, dashboard)

local helpers = require("config.helpers")
local neotest = require("plugins.testing.neotest")
local nvimtest = require("plugins.testing.nvim-test")

return helpers.tbl_merge(neotest, nvimtest)

local helpers = require("config.helpers")
local neotree = require("plugins.tree.neotree")
local nvimtree = require("plugins.tree.nvim-tree")

return helpers.tbl_merge(neotree, nvimtree)

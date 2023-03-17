local helpers = require("config.helpers")
local M = {}

M.get_treetoggle_command = function()
  local ok_neo_tree, _ = pcall(require, "neo-tree")
  local ok_nvim_tree, _ = pcall(require, "nvim-tree")

  local command = ""

  if ok_neo_tree then
    command = "<cmd>Neotree toggle<CR>"
  elseif ok_nvim_tree then
    command = "<cmd>NvimTreeToggle<CR>"
  end

  return not helpers.is_empty(command), command
end

return M
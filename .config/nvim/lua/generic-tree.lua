local helpers = require("helpers")

local M = {}

M.get_treetoggle_command = function()
  local ok_neo_tree, _ = pcall(require, "neo-tree")
  local ok_nvim_tree, _ = pcall(require, "nvim-tree")

  local command = ""

  if ok_neo_tree then
    command = "<cmd>Neotree toggle<CR>"
  end

  if ok_nvim_tree then
    command = "<cmd>NvimTreeToggle<CR>"
  end

  return not helpers.is_empty(command), command
end

M.setup = function()
  local ok_neo_tree, _ = pcall(require, "neo-tree")
  local ok_nvim_tree, _ = pcall(require, "nvim-tree")

  if ok_neo_tree then
    require("user.neotree")
  end

  if ok_nvim_tree then
    require("user.nvim-tree")
  end
end

return M

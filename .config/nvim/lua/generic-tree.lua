local M = {}

M.get_treetoggle_commands = function()
  local ok_neo_tree, _ = pcall(require, "neo-tree")
  local ok_nvim_tree, _ = pcall(require, "nvim-tree")

  local is_set = false
  local commands = {}

  if ok_neo_tree then
    commands = { "<cmd>Neotree toggle<CR>", "Explorer" }
  elseif ok_nvim_tree then
    commands = { "<cmd>NvimTreeToggle<CR>", "Explorer" }
  end

  return is_set, commands
end

M.setup = function()
  local ok_neo_tree, _ = pcall(require, "neo-tree")
  local ok_nvim_tree, _ = pcall(require, "nvim-tree")

  if ok_neo_tree then
    require("user.tree.neotree")
  elseif ok_nvim_tree then
    require("user.tree.nvim-tree")
  end
end

return M

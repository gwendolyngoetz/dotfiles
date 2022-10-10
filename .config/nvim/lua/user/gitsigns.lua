local helpers = require("helpers")
local icons = require("settings").icons

local gitsigns = helpers.require("gitsigns")
if not gitsigns then
  return
end

gitsigns.setup {
  signs = {
    add = { hl = "GitSignsAdd", text = icons.git.add, numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
    change = { hl = "GitSignsChange", text = icons.git.change, numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
    delete = { hl = "GitSignsDelete", text = icons.git.delete, numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
    topdelete = { hl = "GitSignsDelete", text = icons.git.topdelete, numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
    changedelete = { hl = "GitSignsChange", text = icons.git.changedelete, numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
  }
}

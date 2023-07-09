local config = function()
  vim.g.Illuminate_ftblacklist = { "alpha", "dashboard", "NvimTree", "neo-tree" }
  vim.api.nvim_set_keymap(
    "n",
    "<a-n>",
    '<cmd>lua require"illuminate".next_reference{wrap=true}<cr>',
    { noremap = true }
  )
  vim.api.nvim_set_keymap(
    "n",
    "<a-p>",
    '<cmd>lua require"illuminate".next_reference{reverse=true,wrap=true}<cr>',
    { noremap = true }
  )
end

local features = require("config.features")

return {
  {
    "RRethy/vim-illuminate",
    enabled = features.illuminate,
    commit = "a290727",
    config = config,
  },
}

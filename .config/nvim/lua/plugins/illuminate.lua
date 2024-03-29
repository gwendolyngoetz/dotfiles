local config = function()
  vim.g.Illuminate_ftblacklist = { "NvimTree", "neo-tree" }
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

return {
  {
    "RRethy/vim-illuminate",
    commit = "3bd2ab6",
    config = config,
  },
}

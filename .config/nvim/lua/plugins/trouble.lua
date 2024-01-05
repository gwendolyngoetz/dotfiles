local config = function()
  -- -- toggle trouble with optional mode
  -- require("trouble").toggle(mode?)
  --
  -- -- open trouble with optional mode
  -- require("trouble").open(mode?)
  --
  -- -- close trouble
  -- require("trouble").close()
end

return {
  {
    "folke/trouble.nvim",
    commit = "f1168fe",
    config = config,
  },
}

local config = function()
  require("colorizer").setup({
    "css",
    "javascript",
    "html",
  }, {
    rgb_fn = true,
    hsl_fn = true,
  })
end

return {
  {
    "norcalli/nvim-colorizer.lua",
    commit = "36c610a",
    config = config,
  },
}

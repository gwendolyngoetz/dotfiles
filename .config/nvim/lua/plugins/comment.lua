local config = function()
  require("Comment").setup({
    mappings = {
      basic = false,
      extra = false,
    },
  })
end

return {
  {
    "numToStr/Comment.nvim",
    commit = "176e85e",
    config = config,
    lazy = false,
  },
}

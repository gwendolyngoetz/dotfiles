local config = function()
  require("nvim-lightbulb").setup({
    autocmd = {
      enabled = true,
    },
    float = {
      enabled = true,
    },
  })
end

return {
  {
    "kosayoda/nvim-lightbulb",
    enabled = false,
    commit = "56b9ce3",
    dependencies = {
      "antoinemadec/FixCursorHold.nvim",
    },
    config = config,
  },
}

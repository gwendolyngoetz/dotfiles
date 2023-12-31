return {
  {
    "folke/tokyonight.nvim",
    commit = "f247ee7",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },
}

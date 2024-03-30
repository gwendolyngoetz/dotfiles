return {
  {
    "folke/tokyonight.nvim",
    commit = "9bf9ec5",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },
}

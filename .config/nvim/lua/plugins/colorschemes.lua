return {
  {
    "folke/tokyonight.nvim",
    commit = "284667a",
    enabled = true,
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },
  {
    "Mofiqul/dracula.nvim",
    commit = "7ff76dd",
    enabled = false,
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("dracula")
    end,
  },
}

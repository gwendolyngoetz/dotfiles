local config = function()
  vim.cmd.colorscheme("tokyonight-night")
end

return {
  {
    "folke/tokyonight.nvim",
    commit = "3ebc29d",
    lazy = false,
    priority = 1000,
    config = config,
  },
  {
    "Mofiqul/dracula.nvim",
    commit = "7ff76dd",
    lazy = true,
    enabled = false,
  },
}

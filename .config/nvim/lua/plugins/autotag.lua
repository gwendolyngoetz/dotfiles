local config = function()
  require("nvim-ts-autotag").setup()
end

return {
  {
    "windwp/nvim-ts-autotag",
    commit = "8515e48",
    config = config,
  },
}

local config = function()
  require("nvim-ts-autotag").setup()
end

return {
  {
    "windwp/nvim-ts-autotag",
    commit = "6be1192",
    enabled = false,
    config = config,
  },
}

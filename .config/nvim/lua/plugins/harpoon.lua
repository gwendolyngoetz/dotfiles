local config = function()
  require("telescope").load_extension("harpoon")
  require("harpoon").setup()
end

return {
  {
    "ThePrimeagen/harpoon",
    commit = "ccae1b9",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = config,
  },
}

local config = function()
  local icons = require("config.settings").icons
  local actions = require("telescope.actions")

  require("telescope").setup({
    defaults = {
      layout_strategy = "vertical",
      layout_config = {
        vertical = { width = 0.9 },
        horizontal = { width = 0.9 },
      },
      prompt_prefix = icons.telescope.prompt_prefix,
      selection_caret = icons.telescope.selection_caret,
      path_display = { "smart" },
      file_ignore_patterns = { ".git/", "node_modules" },

      mappings = {
        i = {
          ["<Down>"] = actions.cycle_history_next,
          ["<Up>"] = actions.cycle_history_prev,
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
        },
      },
    },
  })

  -- Enable telescope fzf native, if installed
  pcall(require("telescope").load_extension, "fzf")
end

return {
  {
    "nvim-telescope/telescope.nvim",
    commit = "3466159",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
    },
    config = config,
  },
}

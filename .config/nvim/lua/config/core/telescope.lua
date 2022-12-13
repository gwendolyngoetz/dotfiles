local helpers = require("config.helpers")
local icons = require("config.settings").icons

local telescope = helpers.require("telescope")
if not telescope then
  return
end

local actions = require("telescope.actions")

telescope.setup({
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

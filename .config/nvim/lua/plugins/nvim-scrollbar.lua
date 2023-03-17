local config = function()
  local helpers = require("config.helpers")

  local scrollbar = helpers.require("scrollbar")
  if not scrollbar then
    return
  end

  local colors = helpers.require("tokyonight.colors")
  if not colors then
    return
  end

  local scrollbar_gitsigns = helpers.require("scrollbar.handlers.gitsigns")
  if not scrollbar_gitsigns then
    return
  end

  scrollbar.setup({
    handle = {
      color = colors.bg_highlight,
    },
    marks = {
      Search = { color = colors.orange },
      Error = { color = colors.error },
      Warn = { color = colors.warning },
      Info = { color = colors.info },
      Hint = { color = colors.hint },
      Misc = { color = colors.purple },
    },
    handlers = {
      cursor = false,
    },
    excluded_filetypes = {
      "prompt",
      "TelescopePrompt",
      "noice",
      "neo-tree",
      "NvimTree",
    },
  })

  scrollbar_gitsigns.setup()
end

local features = require("config.features")

return {
  {
    "petertriho/nvim-scrollbar",
    enabled = features.nvim_scrollbar,
    commit = "75210c5",
    dependencies = {
      "lewis6991/gitsigns.nvim",
    },
    config = config,
  },
}

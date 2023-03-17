local config = function()
  local helpers = require("config.helpers")
  local icons = require("config.settings").icons

  local indent_blankline = helpers.require("indent_blankline")
  if not indent_blankline then
    return
  end

  indent_blankline.setup({
    show_current_context = true,
    indent_blankline_char = icons.indent.blankline_char,
    indent_blankline_show_trailing_blankline_indent = false,
    indent_blankline_show_first_indent_level = true,
    indent_blankline_use_treesitter = true,
    indent_blankline_show_current_context = true,
    indent_blankline_buftype_exclude = { "terminal", "nofile" },
    indent_blankline_filetype_exclude = {
      "help",
      "packer",
      "NvimTree",
      "neo-tree",
    },
  })
end

local features = require("config.features")

return {
  {
    "lukas-reineke/indent-blankline.nvim",
    enabled = features.indentline,
    tag = "v2.20.4",
    config = config,
  },
}

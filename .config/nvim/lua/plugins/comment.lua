local config = function()
  local helpers = require("config.helpers")

  local comment = helpers.require("Comment")
  if not comment then
    return
  end

  comment.setup({
    mappings = {
      basic = false,
      extra = false,
    },
    pre_hook = function(ctx)
      local utils = require("Comment.utils")
      local ts_utils = require("ts_context_commentstring.utils")
      local ts_internal = require("ts_context_commentstring.internal")

      local location = nil

      if ctx.ctype == utils.ctype.block then
        location = ts_utils.get_cursor_location()
      elseif ctx.cmotion == utils.cmotion.v or ctx.cmotion == utils.cmotion.V then
        location = ts_utils.get_visual_start_location()
      end

      return ts_internal.calculate_commentstring({
        key = ctx.ctype == utils.ctype.line and "__default" or "__multiline",
        location = location,
      })
    end,
  })
end

local features = require("config.features")

return {
  {
    "numToStr/Comment.nvim",
    enabled = features.comment,
    commit = "176e85e",
    config = config,
  },
}

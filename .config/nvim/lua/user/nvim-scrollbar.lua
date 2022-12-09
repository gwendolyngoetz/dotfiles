local helpers = require("helpers")

local scrollbar = helpers.require("scrollbar")
if not scrollbar then
  return
end

local colors = helpers.require("tokyonight.colors")
if not colors then
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
  },
})
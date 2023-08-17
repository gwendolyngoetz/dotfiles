local config = function()
  local helpers = require("config.helpers")
  local colorizer = helpers.require("colorizer")

  if not colorizer then
    return
  end

  colorizer.setup({
    css = {
      rgb_fn = true,
      hsl_fn = true,
      RRGGBBAA = true,
    },
    "javascript",
    html = {
      mode = "foreground",
      rgb_fn = true,
      hsl_fn = true,
      RRGGBBAA = true,
    },
  })
end

return {
  {
    "norcalli/nvim-colorizer.lua",
    commit = "36c610a",
    config = config,
  },
}

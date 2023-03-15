local config = function()
  local helpers = require("config.helpers")

  local lightbulb = helpers.require("nvim-lightbulb")
  if not lightbulb then
    return
  end

  lightbulb.setup({
    autocmd = {
      enabled = true,
    },
    float = {
      enabled = true,
    },
  })
end

return {
  {
    "kosayoda/nvim-lightbulb",
    commit = "56b9ce3",
    enabled = false,
    config = config,
  },
}

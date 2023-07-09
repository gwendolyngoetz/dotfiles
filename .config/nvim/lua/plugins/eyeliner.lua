local config = function()
  vim.api.nvim_set_hl(0, "EyelinerPrimary", {
    fg = "#ff6347",
    bg = "#000000",
    bold = true,
    underline = true,
  })

  vim.api.nvim_set_hl(0, "EyelinerSecondary", {
    fg = "#47e3ff",
    bg = "#000000",
    bold = true,
    underline = true,
  })

  require("eyeliner").setup({
    highlight_on_key = true,
  })
end

local features = require("config.features")

return {
  {
    "jinh0/eyeliner.nvim",
    enabled = features.eyeliner,
    commit = "a6c05ed",
    config = config,
  },
}

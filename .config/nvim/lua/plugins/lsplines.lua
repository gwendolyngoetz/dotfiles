local config = function()
  local helpers = require("config.helpers")

  local lsplines = helpers.require("lsp_lines")
  if not lsplines then
    return
  end

  lsplines.setup()

  vim.diagnostic.config({
    virtual_text = false,
    --virtual_lines = {
    -- only_current_line = true,
    --},
  })
end

local features = require("config.features")

return {
  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    enabled = features.lsplines,
    commit = "dcff567b",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    config = config,
  },
}

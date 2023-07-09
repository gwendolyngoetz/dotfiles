local config = function()
  local helpers = require("config.helpers")
  local icons = require("config.settings").icons

  local navic = helpers.require("nvim-navic")
  if not navic then
    return
  end

  navic.setup({
    highlight = true,
    separator = " " .. icons.chevron.right .. " ",
  })

  vim.api.nvim_create_autocmd({ "CursorMoved", "BufWinEnter", "BufFilePost", "InsertEnter", "BufWritePost" }, {
    callback = function()
      require("plugins.winbar.winbar-mod").get_winbar()
    end,
  })
end

local features = require("config.features")

return {
  {
    "SmiteshP/nvim-navic",
    enabled = features.winbar,
    commit = "6e8850a",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    config = config,
  },
}

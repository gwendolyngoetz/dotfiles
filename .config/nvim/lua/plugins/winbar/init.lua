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

return {
  {
    "SmiteshP/nvim-navic",
    commit = "cdd2453",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    config = config,
  },
}

local config = function()
  local icons = require("config.settings").icons

  require("nvim-navic").setup({
    highlight = true,
    separator = " " .. icons.chevron.right .. " ",
  })

  vim.api.nvim_create_autocmd({
    "CursorMoved",
    --"BufWinEnter",
    "CursorHoldI",
    "CursorHold",
    "BufReadPost",
    "BufFilePost",
    "InsertEnter",
    "BufWritePost",
    "TabClosed",
    "TabEnter",
  }, {
    callback = function()
      require("plugins.winbar.winbar-mod").get_winbar()
    end,
  })
end

return {
  {
    "SmiteshP/nvim-navic",
    commit = "8649f69",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    config = config,
  },
}
